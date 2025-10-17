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

// [Start import_the_motion_module]
import { motion } from '@kit.MultimodalAwarenessKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_the_motion_module]

@Entry
@Component
struct Index {
  @State message: string = 'motion';

  private subscribeOperating() {
    // [Start motion_subscribe_operating_parameter]
    let callback:Callback<motion.OperatingHandStatus> = (data:motion.OperatingHandStatus) => {
      console.info('callback succeeded' + data);
    };
    // [End motion_subscribe_operating_parameter]

    // [Start motion_subscribe_operating]
    try {
      motion.on('operatingHandChanged', callback);
      console.info('on succeeded');
      // [StartExclude motion_subscribe_operating]
      this.message = 'motion subscribeOperating';
      // [EndExclude motion_subscribe_operating]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Failed on and err code is ' + error.code);
      // [StartExclude motion_subscribe_operating]
      this.message = 'motion subscribeOperating';
      // [EndExclude motion_subscribe_operating]
    }
    // [End motion_subscribe_operating]
  }

  private unsubscribeOperating() {
    // [Start motion_unsubscribe_operating]
    try {
      motion.off('operatingHandChanged');
      console.info('off succeeded');
      // [StartExclude motion_unsubscribe_operating]
      this.message = 'motion unsubscribeOperating';
      // [EndExclude motion_unsubscribe_operating]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Failed off and err code is ' + error.code);
      // [StartExclude motion_unsubscribe_operating]
      this.message = 'motion unsubscribeOperating';
      // [EndExclude motion_unsubscribe_operating]
    }
    // [End motion_unsubscribe_operating]
  }

  private getOperating() {
    // [Start motion_get_operating]
    try {
      let data:motion.OperatingHandStatus = motion.getRecentOperatingHandStatus();
      console.info('get succeeded' + data);
      // [StartExclude motion_get_operating]
      this.message = 'motion getOperating';
      // [EndExclude motion_get_operating]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Failed get and err code is ' + error.code);
      // [StartExclude motion_get_operating]
      this.message = 'motion getOperating';
      // [EndExclude motion_get_operating]
    }
    // [End motion_get_operating]
  }

  private subscribeHolding() {
    // [Start motion_subscribe_holding_parameter]
    let callback:Callback<motion.HoldingHandStatus> = (data:motion.HoldingHandStatus) => {
      console.info('callback succeeded' + data);
    };
    // [End motion_subscribe_holding_parameter]

    // [Start motion_subscribe_holding]
    try {
      motion.on('holdingHandChanged', callback);
      console.info('on succeeded');
      // [StartExclude motion_subscribe_holding]
      this.message = 'motion subscribeHolding';
      // [EndExclude motion_subscribe_holding]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Failed on and err code is ' + error.code);
      // [StartExclude motion_subscribe_holding]
      this.message = 'motion subscribeHolding';
      // [EndExclude motion_subscribe_holding]
    }
    // [End motion_subscribe_holding]
  }

  private unsubscribeHolding() {
    // [Start motion_unsubscribe_holding]
    try {
      motion.off('holdingHandChanged');
      console.info('off succeeded');
      // [StartExclude motion_unsubscribe_holding]
      this.message = 'motion unsubscribeHolding';
      // [EndExclude motion_unsubscribe_holding]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Failed off and err code is ' + error.code);
      // [StartExclude motion_unsubscribe_holding]
      this.message = 'motion unsubscribeHolding';
      // [EndExclude motion_unsubscribe_holding]
    }
    // [End motion_unsubscribe_holding]
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(35)
        .fontWeight(FontWeight.Bold).margin({ bottom:10 })
        .height('20%')
        .id('show')
      Button('订阅操作手')
        .margin(10)
        .id('button1')
        .width('30%')
        .onClick(() => this.subscribeOperating())
      Button('取消订阅操作手')
        .margin(10)
        .id('button2')
        .width('30%')
        .onClick(() => this.unsubscribeOperating())
      Button('获取操作手状态')
        .margin(10)
        .id('button3')
        .width('30%')
        .onClick(() => this.getOperating())
      Button('订阅握持手')
        .margin(10)
        .id('button4')
        .width('30%')
        .onClick(() => this.subscribeHolding())
      Button('取消订阅握持手')
        .margin(10)
        .id('button5')
        .width('30%')
        .onClick(() => this.unsubscribeHolding())
    }
    .height('100%')
    .width('100%')
  }
}