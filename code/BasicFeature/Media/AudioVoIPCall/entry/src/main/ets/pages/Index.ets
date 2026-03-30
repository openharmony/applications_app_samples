/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { router, window } from '@kit.ArkUI';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  private context: Context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    let windowClass = window.getLastWindow(getContext(this))
    windowClass.then((win) => {
      win.setWindowLayoutFullScreen(true)
    })
  }

  build() {
    Stack() {
      Image($r('app.media.background_main'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        Text($r('app.string.SAMPLE_NAME'))
          .fontSize($r('app.float.page_title_font_size'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.float.page_title_margin') })

        Row({ space: $r('app.float.main_button_space') }) {
          Column({ space: 10 }) {
            Button() {
              Image($r('app.media.phone'))
                .width($r('app.float.main_button_size'))
                .height($r('app.float.main_button_size'))
                .objectFit(ImageFit.Contain)
                .borderRadius(50)
            }
            .type(ButtonType.Circle)
            .width($r('app.float.main_button_size'))
            .height($r('app.float.main_button_size'))
            .onClick(async () => {
              let atManager = abilityAccessCtrl.createAtManager();
              atManager.requestPermissionsFromUser(this.context, ['ohos.permission.MICROPHONE']).then((data) => {
                console.info('data' + JSON.stringify(data));
                console.info('data permission:' + data.permissions);
                console.info('data authResults:' + data.authResults);
              }).catch((err: BusinessError) => {
                console.info('data:' + JSON.stringify(err));
              });
              await router.pushUrl({ url: 'pages/CallOut' })
            })

            Text($r('app.string.CALL_OUT'))
              .fontSize($r('app.float.main_button_text_font_size'))
              .fontColor(Color.White)
          }

          Column({ space: 10 }) {
            Button() {
              Image($r('app.media.phone'))
                .width($r('app.float.main_button_size'))
                .height($r('app.float.main_button_size'))
                .objectFit(ImageFit.Contain)
                .borderRadius(50)
            }
            .type(ButtonType.Circle)
            .width($r('app.float.main_button_size'))
            .height($r('app.float.main_button_size'))
            .onClick(async () => {
              let atManager = abilityAccessCtrl.createAtManager();
              atManager.requestPermissionsFromUser(this.context, ['ohos.permission.MICROPHONE']).then((data) => {
                console.info('data' + JSON.stringify(data));
                console.info('data permission:' + data.permissions);
                console.info('data authResults:' + data.authResults);
              }).catch((err: BusinessError) => {
                console.info('data:' + JSON.stringify(err));
              });
              await router.pushUrl({ url: 'pages/CallIn' })
            })

            Text($r('app.string.CALL_IN'))
              .fontSize($r('app.float.main_button_text_font_size'))
              .fontColor(Color.White)
          }
        }
        .margin({ top: $r('app.float.button_margin') })
      }
      .height('100%')
      .width('100%')
    }
  }
}