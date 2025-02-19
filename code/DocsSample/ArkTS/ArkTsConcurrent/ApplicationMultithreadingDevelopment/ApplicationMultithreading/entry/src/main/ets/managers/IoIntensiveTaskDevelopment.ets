/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { write } from './write'
import { BusinessError } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';

@Concurrent
async function concurrentTest(context: common.UIAbilityContext): Promise<boolean> {
  let filePath1: string = context.filesDir + '/path1.txt'; // 应用文件路径
  let filePath2: string = context.filesDir + '/path2.txt';
  // 循环写文件操作
  let fileList: string[] = [];
  fileList.push(filePath1);
  fileList.push(filePath2)
  for (let i: number = 0; i < fileList.length; i++) {
    write('Hello World!', fileList[i]).then(() => {
      console.info(`Succeeded in writing the file. FileList: ${fileList[i]}`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to write the file. Code is ${err.code}, message is ${err.message}`)
      return false;
    })
  }
  return true;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let context = getContext() as common.UIAbilityContext;
            // 使用TaskPool执行包含密集I/O的并发函数
            // 数组较大时，I/O密集型任务任务分发也会抢占UI主线程，需要使用多线程能力
            taskpool.execute(concurrentTest, context).then(() => {
              // 调度结果处理
              console.info('taskpool: execute success')
            })
            this.message = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}