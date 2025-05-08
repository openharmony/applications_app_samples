  /*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// [Start promise_then_catch_handling]
import { BusinessError } from '@kit.BasicServicesKit';

// [StartExclude promise_then_catch_handling]
// [Start promise_async_operation]
const promise: Promise<number> = new Promise((resolve: Function, reject: Function) => {
  setTimeout(() => {
    const randomNumber: number = Math.random();
    if (randomNumber > 0.5) {
      resolve(randomNumber);
    } else {
      reject(new Error('Random number is too small'));
    }
  }, 1000);
})
// [End promise_async_operation]
// [EndExclude promise_then_catch_handling]

  promise.then((result: number) => {
  console.info(`Random number is ${result}`);
}).catch((error: BusinessError) => {
  console.error(error.message);
});
// [End promise_then_catch_handling]

/*
// [Start async_operation_error_handling_with_try_catch]
async function myAsyncFunction(): Promise<void> {
  try {
     const result: string = await new Promise((resolve: Function) => {
        resolve('Hello, world!');
     });
  } catch (e) {
     console.error(`Get exception: ${e}`);
  }
}
// [End async_operation_error_handling_with_try_catch]
*/

// [Start async_await_sync_operation]
async function myAsyncFunction(): Promise<string> {
  const result: string = await new Promise((resolve: Function) => {
    setTimeout(() => {
      resolve('Hello, world!');
    }, 3000);
  });
  console.info(result); // 输出： Hello, world!
  return result;
}

@Entry
@Component
struct PromiseAsyncAwait {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            let res = await myAsyncFunction();
            console.info('res is: ' + res);
            // [StartExclude update_message_on_success]
            this.message = 'success';
            // [EndExclude update_message_on_success]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End async_await_sync_operation]