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

// [Start import_the_device_status_module]
import { deviceStatus } from '@kit.MultimodalAwarenessKit';
// [End import_the_device_status_module]

@Entry
@Component
struct Index {
  @State message: string = 'deviceStatus';

  private subscribe() {
    // [Start device_status_subscribe]
    try {
      deviceStatus.on('steadyStandingDetect', (data:deviceStatus.SteadyStandingStatus) => {
        console.info('succeed to get status, now status = ' + data);
      });
      // [StartExclude device_status_subscribe]
      this.message = 'deviceStatus subscribe';
      // [EndExclude device_status_subscribe]
    } catch (err) {
      console.error('on failed, err = ' + err);
      // [StartExclude device_status_subscribe]
      this.message = 'deviceStatus subscribe';
      // [EndExclude device_status_subscribe]
    }
    // [End device_status_subscribe]
  }

  private unsubscribeAll() {
    // [Start device_status_unsubscribe_all]
    try {
      deviceStatus.off('steadyStandingDetect');
      // [StartExclude device_status_unsubscribe_all]
      this.message = 'deviceStatus unsubscribeAll';
      // [EndExclude device_status_unsubscribe_all]
    } catch (err) {
      console.error('off failed, err = ' + err);
      // [StartExclude device_status_unsubscribe_all]
      this.message = 'deviceStatus unsubscribeAll';
      // [EndExclude device_status_unsubscribe_all]
    }
    // [End device_status_unsubscribe_all]
  }

  private unsubscribe() {
    // [Start device_status_unsubscribe]
    // 定义callback变量
    let callback : Callback<deviceStatus.SteadyStandingStatus> = (data : deviceStatus. SteadyStandingStatus) => {
      console.info('succeed to get status, now status = ' + data);
    };
    // 以callback为回调函数，订阅设备静止姿态感知（支架态）事件
    try {
      deviceStatus.on('steadyStandingDetect', callback);
      // [StartExclude device_status_unsubscribe]
      this.message = 'deviceStatus subscribe';
      // [EndExclude device_status_unsubscribe]
    } catch (err) {
      console.error('on failed, err = ' + err);
      // [StartExclude device_status_unsubscribe]
      this.message = 'deviceStatus subscribe';
      // [EndExclude device_status_unsubscribe]
    }
    // 取消该客户端订阅设备静止姿态感知（支架态）事件的特定回调函数
    try {
      deviceStatus.off('steadyStandingDetect', callback);
      // [StartExclude device_status_unsubscribe]
      this.message = 'deviceStatus unsubscribe';
      // [EndExclude device_status_unsubscribe]
    } catch (err) {
      console.error('off failed, err = ' + err);
      // [StartExclude device_status_unsubscribe]
      this.message = 'deviceStatus unsubscribe';
      // [EndExclude device_status_unsubscribe]
    }
    // [End device_status_unsubscribe]
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
      Button('取消全部订阅')
        .margin(10)
        .id('button2')
        .width('30%')
        .onClick(() => this.unsubscribeAll())
      Button('取消单个订阅')
        .margin(10)
        .id('button3')
        .width('30%')
        .onClick(() => this.unsubscribe())
    }
    .height('100%')
    .width('100%')
  }
}