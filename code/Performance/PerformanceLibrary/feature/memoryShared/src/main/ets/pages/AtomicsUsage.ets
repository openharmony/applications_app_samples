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
import { BusinessError } from '@ohos.base';
import logger from "../util/Logger";

@Component
export struct AtomicsUsage {
  @State result: string = "";
  private taskNum: number = 2;
  private scroller: Scroller = new Scroller();

  build() {
    Row() {
      Column() {
        Button($r('app.string.not_use_atomics'))
          .width("80%")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
          .onClick(async () => {
            this.sharedArrayBufferUsage(false);
          })
        Button($r('app.string.use_atomics'))
          .width("80%")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
          .onClick(async () => {
            this.sharedArrayBufferUsage(true);
          })
        Text($r('app.string.result'))
          .width("80%")
          .fontSize(30)
          .margin({ top: 30 })
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Blue)
        Scroll(this.scroller) {
          Text(this.result)
            .width("80%")
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Blue)
        }
        .height("60%")
        .margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }

  // 根据传入的值isAtomics判断是否使用原子操作
  sharedArrayBufferUsage(isAtomics: boolean) {
    // 创建长度为4的SharedArrayBuffer对象
    let sab: SharedArrayBuffer = new SharedArrayBuffer(4);
    // 由于SharedArrayBuffer是原始二进制数据缓冲区，无法直接使用，所以这里转换为Int32Array类型进行后续操作
    let int32Array: Int32Array = new Int32Array(sab);
    int32Array[0] = 0;
    // 创建Task对象，并放入TaskGroup中执行
    let taskGroup: taskpool.TaskGroup = new taskpool.TaskGroup();
    for (let i = 0; i < this.taskNum; i++) {
      if (isAtomics) {
        taskGroup.addTask(new taskpool.Task(atomicsProcess, int32Array));
      } else {
        taskGroup.addTask(new taskpool.Task(normalProcess, int32Array));
      }
    }

    taskpool.execute(taskGroup).then(() => {
      // 将结果打印在Text上
      this.result = this.result + "\n" + int32Array;
      // 如果Scroll不在底部，则滑到到底部
      if (!this.scroller.isAtEnd()) {
        this.scroller.scrollEdge(Edge.Bottom);
      }
    }).catch((e: BusinessError) => {
      logger.error(e.message);
    })

  }
}
// 非原子操作，进行10000次++
@Concurrent
function normalProcess(int32Array: Int32Array) {
  for (let i = 0; i < 10000; i++) {
    int32Array[0]++;
  }
}
// 原子操作，进行10000次++
@Concurrent
function atomicsProcess(int32Array: Int32Array) {
  for (let i = 0; i < 10000; i++) {
    Atomics.add(int32Array, 0, 1);
  }
}