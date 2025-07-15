  /*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
  /*
   * Promise对象创建后，可以使用then方法和catch方法指定fulfilled状态和rejected状态的回调函数。
   * then方法可接受两个参数，一个处理fulfilled状态的函数，另一个处理rejected状态的函数。
   *
   * 只传一个参数则表示当Promise对象状态变为fulfilled时，then方法会自动调用这个回调函数，并将Promise对象的结果作为参数传递给它。
   * 使用catch方法注册一个回调函数，用于处理“失败”的结果，即捕获Promise的状态改变为rejected状态或操作失败抛出的异常。
   */
  // 使用 then 方法定义成功和失败的回调
  promise.then((result: number) => {
    console.info(`Succesed number is ${result}`); // 成功时执行
  }, (error: BusinessError) => {
    console.error(error.message); // 失败时执行
  }
  );

  // 使用 then 方法定义成功的回调，catch 方法定义失败的回调
  promise.then((result: number) => {
    console.info(`Random number is ${result}`); // 成功时执行
  }).catch((error: BusinessError) => {
    console.error(error.message); // 失败时执行
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