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

// [Start sensor_capi_index_example]
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import sensorCapi from 'libentry.so';

const DOMAIN = 0xD002700;
// [StartExclude sensor_capi_index_example]
@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller;
  @State private sensorCapiResult: string = '';

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Scroll(this.scroller) {
        Column() {
          Text(`${this.sensorCapiResult}`)
            .fontSize(14)
            .margin({ top: 15 })
            .id('sensorCapiResult')
        }
      }
      .width('96%')
      .height('20%')
      .backgroundColor('#F1F1F1')
      .borderRadius(10)
      .borderColor($r('sys.color.popup_border_color'))

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Button('getSensorInfos').onClick(() => {
          // [EndExclude sensor_capi_index_example]
          try {
            sensorCapi.getSensorInfos();
            // [StartExclude sensor_capi_index_example]
            this.sensorCapiResult = 'getSensorInfos:success';
            // [EndExclude sensor_capi_index_example]
          } catch (error) {
            let e: BusinessError = error as BusinessError;
            hilog.error(DOMAIN, 'testTag', `Failed to invoke getSensorInfos. Code: ${e.code}, message: ${e.message}`);
          }
          // [StartExclude sensor_capi_index_example]
        }).id('getSensorInfosId')

        Button('subscriber').onClick(() => {
          // [EndExclude sensor_capi_index_example]
          try {
            sensorCapi.subscriber();
            // [StartExclude sensor_capi_index_example]
            this.sensorCapiResult = 'subscriber:success';
            // [EndExclude sensor_capi_index_example]
          } catch (error) {
            let e: BusinessError = error as BusinessError;
            hilog.error(DOMAIN, 'testTag', `Failed to invoke getSensorInfos. Code: ${e.code}, message: ${e.message}`);
          }
          // [End sensor_capi_index_example]
        }).id('subscriberId')
      }
      .margin({ top: 10 })
      .width('100%')
      .height('70%')
    }
    .height('100%')
    .width('100%')
  }
}
