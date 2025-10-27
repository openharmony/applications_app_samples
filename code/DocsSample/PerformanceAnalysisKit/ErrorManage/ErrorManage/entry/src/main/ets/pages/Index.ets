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

// [Start index_h]
import { errorManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End index_h]

// [Start error_observer]
let observer: errorManager.ErrorObserver = {
  onUnhandledException(errorMsg) {
    hilog.info(0x0000, 'testTag','onUnhandledException, errorMsg: ', errorMsg);
  },
  onException(errorObj) {
    hilog.info(0x0000, 'testTag','onException, name: ', errorObj.name);
    hilog.info(0x0000, 'testTag','onException, message: ', errorObj.message);
    if (typeof(errorObj.stack) === 'string') {
      hilog.info(0x0000, 'testTag','onException, stack: ', errorObj.stack);
    }
  }
};
// [End error_observer]

// [Start error_func]
function errorFunc(observer: errorManager.GlobalError) {
  hilog.info(0x0000, 'testTag','result name :' + observer.name);
  hilog.info(0x0000, 'testTag','result message :' + observer.message);
  hilog.info(0x0000, 'testTag','result stack :' + observer.stack);
  hilog.info(0x0000, 'testTag','result instanceName :' + observer.instanceName);
  hilog.info(0x0000, 'testTag','result instanceType :' + observer.instanceType);
};
// [End error_func]

// [Start loop_observer]
let loopObserver: errorManager.LoopObserver = {
  onLoopTimeOut(timeout: number) {
    hilog.info(0x0000, 'testTag','Duration timeout: ' + timeout);
  }
};
// [End loop_observer]

// [Start promise_func]
function promiseFunc(observer: errorManager.GlobalError) {
  hilog.info(0x0000, 'testTag','result name :' + observer.name);
  hilog.info(0x0000, 'testTag','result message :' + observer.message);
  hilog.info(0x0000, 'testTag','result stack :' + observer.stack);
  hilog.info(0x0000, 'testTag','result instanceName :' + observer.instanceName);
  hilog.info(0x0000, 'testTag','result instanceType :' + observer.instanceType);
}
// [End promise_func]

// [Start unhandled_rejection_observer]
let promise1 = new Promise<void>(() => {}).then(() => {
  throw new Error('uncaught error');
});

let unhandledrejectionObserver: errorManager.UnhandledRejectionObserver = (reason: Error, promise: Promise<void>) => {
  if (promise === promise1) {
    hilog.info(0x0000, 'testTag','promise1 is rejected');
  }
  hilog.info(0x0000, 'testTag','reason.name: ', reason.name);
  hilog.info(0x0000, 'testTag','reason.message: ', reason.message);
  if (reason.stack) {
    hilog.info(0x0000, 'testTag','reason.stack: ', reason.stack);
  }
};
// [End unhandled_rejection_observer]

// [Start freeze_call_back]
function freezeCallback() {
  hilog.info(0x0000, 'testTag','freezecallback');
}
// [End freeze_call_back]

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      // [Start onclick_error_observer]
      Button('单线程监听场景').onClick(()=>{
        let observerId = -1;
        try {
          observerId = errorManager.on('error', observer);
        } catch (paramError) {
          let code = (paramError as BusinessError).code;
          let message = (paramError as BusinessError).message;
          hilog.error(0x0000, 'testTag',`error: ${code}, ${message}`);
        }
      }).position({x:50, y:50});
      // [End onclick_error_observer]

      // [Start onclick_error_func]
      Button('进程监听异常场景').onClick(()=>{
        try {
          errorManager.on('globalErrorOccurred', errorFunc);
        } catch (paramError) {
          let code = (paramError as BusinessError).code;
          let message = (paramError as BusinessError).message;
          hilog.error(0x0000, 'testTag',`error: ${code}, ${message}`);
        }
      }).position({x:50, y:100});
      // [End onclick_error_func]

      // [Start onclick_loop_observer]
      Button('主线程监听消息处理耗时').onClick(()=>{
        try {
          errorManager.on('loopObserver', 1, loopObserver);
        } catch (paramError) {
          let code = (paramError as BusinessError).code;
          let message = (paramError as BusinessError).message;
          hilog.error(0x0000, 'testTag',`error: ${code}, ${message}`);
        }
      }).position({x:50, y:150});
      // [End onclick_loop_observer]

      // [Start onclick_promise_func]
      Button('进程监听promise异常场景').onClick(()=>{
        try {
          errorManager.on('globalUnhandledRejectionDetected', promiseFunc);
        } catch (paramError) {
          let code = (paramError as BusinessError).code;
          let message = (paramError as BusinessError).message;
          hilog.error(0x0000, 'testTag',`error: ${code}, ${message}`);
        }
      }).position({x:50, y:200});
      // [End onclick_promise_func]

      // [Start onclick_unhandled_rejection_observer]
      Button('进程promise监听注册被拒绝').onClick(()=>{
        try {
          errorManager.on('unhandledRejection', unhandledrejectionObserver);
        } catch (paramError) {
          let code = (paramError as BusinessError).code;
          let message = (paramError as BusinessError).message;
          hilog.error(0x0000, 'testTag',`error: ${code}, ${message}`);
        }
      }).position({x:50, y:250});
      // [End onclick_unhandled_rejection_observer]

      // [Start onclick_freeze_call_back]
      Button('主线程监听freeze').onClick(()=>{
        try {
          errorManager.on('freeze', freezeCallback);
        } catch (paramError) {
          let code = (paramError as BusinessError).code;
          let message = (paramError as BusinessError).message;
          hilog.error(0x0000, 'testTag',`error: ${code}, ${message}`);
        }
      }).position({x:50, y:300});
      // [End onclick_freeze_call_back]
    }
  }
}