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

// [Start native_transient_task]
import testTransientTask from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = '';
  @State requestId: number = 0;

  build() {
    Row() {
      Column() {
        // [StartExclude native_transient_task]
        Row(){
          Text($r('app.string.transient_task_id')).fontSize(20);
          Text(this.requestId.toString()).fontSize(20).id('transient_task_id');
        }
        // [EndExclude native_transient_task]
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.request_suspend_delay'))
          .onClick(event => {
          this.RequestSuspendDelay();
        })
          // [StartExclude native_transient_task]
          .id('request_suspend_delay')
          .fontSize(20)
          .margin({ top: 10, bottom: 10 })
          // [EndExclude native_transient_task]
        Button($r('app.string.get_remaining_delay_time'))
          .onClick(event =>{
          this.GetRemainingDelayTime();
        })
          // [StartExclude native_transient_task]
          .id('get_remaining_delay_time')
          .fontSize(20)
          .margin({ top: 10, bottom: 10 })
          // [EndExclude native_transient_task]
        Button($r('app.string.cancel_suspend_delay'))
          .onClick(event =>{
          this.CancelSuspendDelay();
        })
          // [StartExclude native_transient_task]
          .id('cancel_suspend_delay')
          .fontSize(20)
          .margin({ top: 10, bottom: 10 })
          // [EndExclude native_transient_task]
        Button($r('app.string.get_transient_task_info'))
          .onClick(event =>{
          this.GetTransientTaskInfo();
        })
          // [StartExclude native_transient_task]
          .id('get_transient_task_info')
          .fontSize(20)
          .margin({ top: 10, bottom: 10 })
          // [EndExclude native_transient_task]
      }
      .width('100%')
    }
    .height('100%')
  }

  RequestSuspendDelay() {
    let requestId = testTransientTask.RequestSuspendDelay();
    // [StartExclude native_transient_task]
    this.requestId = requestId;
    // [EndExclude native_transient_task]
    console.log('The return requestId is ' + requestId);
  }

  GetRemainingDelayTime() {
    let time = testTransientTask.GetRemainingDelayTime();
    console.log('The time is ' + time);
  }

  CancelSuspendDelay() {
    let ret = testTransientTask.CancelSuspendDelay();
    console.log('The ret is ' + ret);
  }

  GetTransientTaskInfo() {
    let ret = testTransientTask.GetTransientTaskInfo();
    console.log('The ret is ' + JSON.stringify(ret));
  }
}
// [End native_transient_task]
