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
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 20 }) {
      Button('ControlWebGestureZoomingButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/ControlWebGestureZooming',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('ControlMouseAndKeyBoardZoomingButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/ControlMouseAndKeyBoardZooming',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('MonitorZoomRatioButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/MonitorZoomRatio',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('ControlZoomByFixedRatioButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/ControlZoomByFixedRatio',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('ControlZoomByInputButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/ControlZoomByInput',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('ControlZoomToFixedRatioButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/ControlZoomToFixedRatio',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

    }.height('100%')
    .width('100%')
  }
}
