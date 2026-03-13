/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
// [Start load_nativeSendable]
// Index.ets
import { MyObject } from 'libentry.so';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function sum(object: MyObject) {
  object.value = 2000;
  let num = object.plusOne();
  console.info('taskpool thread num is ' + num); // 日志输出：taskpool thread num is 2001
  return num;
}

@Entry
@Component
struct Index {
  @State message: string = '使用Sendable对象进行线程间通信';

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            let object: MyObject = new MyObject(0);
            object.value = 1023;
            let num = object.plusOne();
            console.info('host thread num1 is ' + num); // 日志输出：host thread num1 is 1024
            let task = new taskpool.Task(sum, object);
            let result = await taskpool.execute(task);
            console.info('host thread result is ' + result); // 日志输出：host thread result is 2001
            console.info('host thread num2 is ' + object.value); // 日志输出：host thread num2 is 2001
            this.message = 'host thread num2 is ' + object.value;
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End load_nativeSendable]