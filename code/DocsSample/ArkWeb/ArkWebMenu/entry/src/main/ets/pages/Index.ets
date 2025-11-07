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
import { common } from '@kit.AbilityKit';

//Column space
const COLUMN_SPACE: Length = 10;
@Entry
@Component
struct Index {
  build() {
    Column({ space: COLUMN_SPACE }) {
      Button('textMenuItem')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebTextMenuItem',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`)
            })
        })
      Button('contextMenu')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebContextMenu',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('bindSelectionMenu')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebBindSelectionMenu',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('previewBuilder')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebPreviewBuilder',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('saveImage')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebSaveImage',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('editMenuOptions')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebEditMenuOptions',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('scanQRCode')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebScanQRCode',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('disableLongPress')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebDisableLongPress',
          })
            .catch((error: BusinessError) => {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })
    }.height('100%')
    .width('100%')
  }
}