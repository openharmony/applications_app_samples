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

import testNapi2 from 'libnativerender.so';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {

  build() {
    Row() {
      Column() {
        Button($r('app.string.dialog_controller'))
          .height(50)
          .width('85%')
          .margin({ top: 20, bottom: 10 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/IndexController',
            })
          })
        Button($r('app.string.custom_dialog'))
          .height(50)
          .width('85%')
          .margin({ top: 20, bottom: 10 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/IndexCustomDialog',
            })
          })
        Button($r('app.string.dialog_demo'))
          .height(50)
          .width('85%')
          .margin({ top: 20, bottom: 10 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({url: 'pages/DialogDemo'});
          })
        Text($r('app.string.exit_app'))
          .fontSize(20)
          .fontColor(0xCCCCCC)
          .width('100%')
          .margin({ left: 10 })
        Button($r('app.string.close_app'))
          .fontSize(18)
          .width(240)
          .onClick(() => {
            testNapi2.Close();
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext
            context.terminateSelf()
          })
          .margin({ top: 20, bottom: 20 })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}