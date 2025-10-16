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

// [Start import_the_user_status_module]
import { userStatus } from '@kit.MultimodalAwarenessKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_the_user_status_module]

@Entry
@Component
struct Index {
  @State message: string = 'userStatus';

  private subscribe() {
    // [Start user_status_parameter]
    let callback : Callback<userStatus.UserClassification> = (data : userStatus.UserClassification) => {
      console.info('callback succeeded, ageGroup:' + data.ageGroup + ", confidence:" + data.confidence);
    };
    // [End user_status_parameter]

    // [Start user_status_subscribe]
    try {
      userStatus.on('userAgeGroupDetected', callback);
      console.info("on succeeded");
      // [StartExclude user_status_subscribe]
      this.message = 'userStatus subscribe';
      // [EndExclude user_status_subscribe]
    } catch (err) {
      let error = err as BusinessError;
      console.error("Failed on and err code is " + error.code);
      // [StartExclude user_status_subscribe]
      this.message = 'userStatus subscribe';
      // [EndExclude user_status_subscribe]
    }
    // [End user_status_subscribe]
  }

  private unsubscribe() {
    // [Start user_status_unsubscribe]
    try {
      userStatus.off('userAgeGroupDetected');
      console.info("off succeeded");
      // [StartExclude user_status_unsubscribe]
      this.message = 'userStatus unsubscribe';
      // [EndExclude user_status_unsubscribe]
    } catch (err) {
      let error = err as BusinessError;
      console.error("Failed off and err code is " + error.code);
      // [StartExclude user_status_unsubscribe]
      this.message = 'userStatus unsubscribe';
      // [EndExclude user_status_unsubscribe]
    }
    // [End user_status_unsubscribe]
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
    }
    .height('100%')
    .width('100%')
  }
}