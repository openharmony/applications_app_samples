/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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


import router from '@ohos.router';
import { BusinessError } from '@ohos.base';


let g_tunFd = -1
let g_tunnelFd = -1

@Entry
@Component
struct Index {
  @State message: string = 'Toy VPN'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            console.info("vpn Client")
          })
        Button('启用VPN').onClick(() => {
          console.info(`Succeeded in clicking the 'Next' button.`)
          router.pushUrl({ url: 'pages/StartVpn' }).then(() => {
            console.info('Succeeded in jumping to the second page.')
          }).catch((err: BusinessError) => {
            console.error(`Failed to jump to the second page.Code is ${err.code}, message is ${err.message}`)
          })
        }).width('100%')
        Button('停用VPN').onClick(() => {
          console.info(`Succeeded in clicking the 'Next' button.`)
          router.pushUrl({ url: 'pages/StopVpn' }).then(() => {
            console.info('Succeeded in jumping to the second page.')
          }).catch((err: BusinessError) => {
            console.error(`Failed to jump to the second page.Code is ${err.code}, message is ${err.message}`)
          })
        })
          .width('100%')
      }
      .height('100%')
    }
  }
}