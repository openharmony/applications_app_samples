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
  // [StartExclude native_transient_task]
  @State requestId: number = 0;
  // [EndExclude native_transient_task]

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
        Button() {
          Text("申请短时任务").fontSize(20)
        }
        .id('request_suspend_delay')
        .margin({ top: 10, bottom: 10 })
        .width(250)
        .height(40)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.RequestSuspendDelay();
        })

        Button(){
          Text('获取剩余时间').fontSize(20)
        }
        .id('get_remaining_delay_time')
        .margin({ top: 10, bottom: 10 })
        .width(250)
        .height(40)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.GetRemainingDelayTime();
        })

        Button(){
          Text('取消短时任务').fontSize(20)
        }
        .id('cancel_suspend_delay')
        .margin({ top: 10, bottom: 10 })
        .width(250)
        .height(40)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.CancelSuspendDelay();
        })

        Button(){
          Text('获取所有短时任务信息').fontSize(20)
        }
        .id('get_transient_task_info')
        .margin({ top: 10, bottom: 10 })
        .width(250)
        .height(40)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.GetTransientTaskInfo();
        })
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
    console.info('The return requestId is ' + requestId);
  }

  GetRemainingDelayTime() {
    let time = testTransientTask.GetRemainingDelayTime();
    console.info('The time is ' + time);
  }

  CancelSuspendDelay() {
    let ret = testTransientTask.CancelSuspendDelay();
    console.info('The ret is ' + ret);
  }

  GetTransientTaskInfo() {
    let ret = testTransientTask.GetTransientTaskInfo();
    console.info('The ret is ' + JSON.stringify(ret));
  }
}
// [End native_transient_task]
