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

// [Start import_the_stationary_module]
import { stationary } from '@kit.MultimodalAwarenessKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_the_stationary_module]

@Entry
@Component
struct Index {
  @State message: string = 'stationary';

  private subscribe() {
    // [Start stationary_subscribe]
    let reportLatencyNs = 1000000000;
    try {
      stationary.on('still', stationary.ActivityEvent.ENTER, reportLatencyNs, (data) => {
        console.info('data=' + JSON.stringify(data));
      })
      // [StartExclude stationary_subscribe]
      this.message = 'stationary subscribe';
      // [EndExclude stationary_subscribe]
    } catch (error) {
      let message = (error as BusinessError).message;
      console.error('stationary on failed:' + message);
    }
    // [End stationary_subscribe]
  }

  private unsubscribe() {
    // [Start stationary_unsubscribe]
    try {
      stationary.off('still', stationary.ActivityEvent.ENTER, (data) => {
        console.info('data=' + JSON.stringify(data));
      })
      // [StartExclude stationary_unsubscribe]
      this.message = 'stationary unsubscribe';
      // [EndExclude stationary_unsubscribe]
    } catch (error) {
      let message = (error as BusinessError).message;
      console.error('stationary off failed:' + message);
    }
    // [End stationary_unsubscribe]
  }

  private getStatus() {
    // [Start stationary_getStatus]
    try {
      stationary.once('still', (data) => {
        console.info('data=' + JSON.stringify(data));
      })
      // [StartExclude stationary_getStatus]
      this.message = 'stationary getStatus';
      // [EndExclude stationary_getStatus]
    } catch (error) {
      let message = (error as BusinessError).message;
      console.error('stationary once failed:' + message);
    }
    // [End stationary_getStatus]
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(35)
        .fontWeight(FontWeight.Bold).margin({ bottom:10 })
        .height('20%')
        .id('show')
      Button('订阅')
        .margin(10)
        .id('button1')
        .width('30%')
        .onClick(() => this.subscribe())
      Button('取消订阅')
        .margin(10)
        .id('button2')
        .width('30%')
        .onClick(() => this.unsubscribe())
      Button('获取')
        .margin(10)
        .id('button3')
        .width('30%')
        .onClick(() => this.getStatus())
    }
    .height('100%')
    .width('100%')
  }
}