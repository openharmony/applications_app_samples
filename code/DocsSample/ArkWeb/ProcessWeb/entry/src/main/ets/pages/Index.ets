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
      Button('setRenderProcessModeButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/SetRenderProcessMode',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('terminateRenderProcessButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/TerminateRenderProcess',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('onRenderExitedButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/OnRenderExited',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('onRenderProcessNotRespondingButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/OnRenderProcessNotResponding',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('onRenderProcessRespondingButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/OnRenderProcessResponding',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('WebComponentCreatButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebComponentCreat',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })

      Button('FixingPageFlickeringButton')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/FixingPageFlickering',
          })
            .catch((error: BusinessError) => {
              console.info(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            })
        })
    }.height('100%')
    .width('100%')
  }
}
