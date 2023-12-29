/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import taskpool from '@ohos.taskpool';
import fs from '@ohos.file.fs';
import { NonReentrantLock } from '../util/LockUtil';
import logger from "../util/Logger";

@Component
export struct LockUsage {
  taskNum: number = 10; // 任务数，实际并行线程数依设备而定
  baseDir: string = getContext().filesDir + '/TextDir'; // 文件写入的应用沙箱路径
  sabInLock: SharedArrayBuffer = new SharedArrayBuffer(4); // 在主线程，初始化子线程锁标志位，所使用的共享内存
  sabForLine: SharedArrayBuffer = new SharedArrayBuffer(4); // 在主线程，初始化子线程偏移位，所使用的共享内存
  @State result: string = "";
  loadDialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog(),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: true
  });

  build() {
    Row() {
      Column() {
        // 不使用锁写入的按钮
        Button($r('app.string.not_use_lock'))
          .width("80%")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
          .onClick(async () => {
            this.startWrite(false);
          })
        // 使用锁写入的按钮
        Button($r('app.string.use_lock'))
          .width("80%")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
          .onClick(async () => {
            this.startWrite(true);
          })
        // 运行状态说明
        Text(this.result)
          .width("80%")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Blue)
          .margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }

  startWrite(useLock: boolean): void {
    this.loadDialogController.open();
    // 指明运行状态为“写入文件开始”
    this.result = getContext().resourceManager.getStringSync($r('app.string.write_file_start'));
    // 初始化写入时的偏移量
    let whichLineToWrite: Int32Array = new Int32Array(this.sabForLine);
    Atomics.store(whichLineToWrite, 0, 0);
    // 开启多线程依据偏移量指定位置写入文件
    // 通过主线程的sabInLock：SharedArrayBuffer初始化锁，保证多线程操作同一处锁标志位
    // 通过主线程的sabForLine：SharedArrayBuffer初始化偏移位，保证多线程操作同一处偏移位置
    let taskPoolGroup: taskpool.TaskGroup = new taskpool.TaskGroup();
    for (let i: number = 0; i < this.taskNum; i++) {
      taskPoolGroup.addTask(new taskpool.Task(createWriteTask, this.baseDir, i, this.sabInLock, this.sabForLine, useLock));
    }
    taskpool.execute(taskPoolGroup).then(() => {
      // 指明运行状态为“写入文件成功”
      this.result = getContext().resourceManager.getStringSync($r('app.string.write_file_success'));
      this.loadDialogController.close();
    }).catch(() => {
      // 指明运行状态为“写入文件失败”
      this.result = getContext().resourceManager.getStringSync($r('app.string.write_file_failed'));
      this.loadDialogController.close();
    })
  }
}

@Concurrent
async function createWriteTask(baseDir: string, writeText: number, sabInLock: SharedArrayBuffer, sabForLine: SharedArrayBuffer, useLock: boolean): Promise<void> {
  class Option { // 写入文件时的接口方法参数类
    offset: number = 0;
    length: number = 0;
    encoding: string = 'utf-8';

    constructor(offset: number, length: number) {
      this.offset = offset;
      this.length = length;
    }
  }

  // 初始化文件目录
  let filePath: string | undefined = baseDir + (useLock ? "/useLock.txt" : "/unusedLock.txt");

  if (!fs.accessSync(baseDir)) {
    fs.mkdirSync(baseDir);
  }
  // 利用主线程传入的SharedArrayBuffer初始化锁
  let nrl: NonReentrantLock | undefined = undefined;
  if (useLock) {
    // 不可重入锁
    nrl = new NonReentrantLock(sabInLock);
  }

  // 利用主线程传入的SharedArrayBuffer初始化写入文件时的偏移量
  let whichLineToWrite: Int32Array = new Int32Array(sabForLine);
  let str: string = writeText + '\n';

  for (let i: number = 0; i < 100; i++) {
    if (useLock && nrl !== undefined) {
      // 获取锁
      nrl.lock();
    }
    // 写入文件
    let file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    try {
      fs.writeSync(file.fd, str, new Option(whichLineToWrite[0], str.length));
    } catch (err) {
      logger.error(`errorCode : ${err.code},errMessage : ${err.message}`);
    }
    fs.closeSync(file);
    // 修改偏移量，指定下次写入时的位置
    whichLineToWrite[0] += str.length;
    if (useLock && nrl !== undefined) {
      // 释放锁
      nrl.unlock();
    }
  }
}

@CustomDialog
export struct Dialog {
  controller: CustomDialogController;

  build() {
    Column() {
      LoadingProgress()
        .color(Color.White)
        .width("30%")
        .height("30%")
    }
  }
}