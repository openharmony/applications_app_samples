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

import Logger from '../model/Logger';
import prompt from '@ohos.promptAction';

const TAG: string = '[picker]';

@CustomDialog
export struct ButtonDialogBuilder {
  private controller?: CustomDialogController;
  private context = getContext(this) as any;
  private messages: string = 'It is a shared message';

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Row() {
            Text($r('app.string.toShare'))
              .fontSize($r('app.float.fontSize_twenty'))
              .fontWeight(FontWeight.Medium)
          }
          .id('toShare')
          .margin({ top: $r('app.float.margin_twenty'), bottom: $r('app.float.margin_twenty') })

          Column() {
            Image($r('app.media.icon'))
              .width($r('app.float.width_height_value'))
              .height($r('app.float.width_height_value'))
              .margin({
                bottom: $r('app.float.margin_bottom_ten')
              })
              .id('Shared')
            Text($r('app.string.UiExtension'))
              .fontSize($r('app.float.fontSize_eighteen'))
              .fontWeight(FontWeight.Normal)
          }
          .onClick(() => {
            this.controller.close();
            this.context.startAbility({
              bundleName: "com.samples.template",
              abilityName: "EntryAbility",
              parameters: {
                'shareMessages': this.messages,
                'sharedFlag': true
              }
            }, (err, data) =>{
              Logger.info(`${TAG}`, `startAbility, err: ${JSON.stringify(err)}`, `data: ${JSON.stringify(data)}`);
              if(err.code != 0) {
                prompt.showToast({ message: '分享Demo启动失败！', duration: 3000 });
              }
            });
          })

          Row() {
            Text($r('app.string.cancel'))
              .fontSize($r('app.float.fontSize_twenty'))
              .fontWeight(FontWeight.Normal)
              .id('cancellation')
          }
          .margin({
            top: $r('app.float.margin_twenty'),
            bottom: $r('app.float.margin_twenty')
          })
          .onClick(() => {
            Logger.info(TAG, `onclick close`);
            this.controller.close();
          })
        }
        .width("100%")
        .borderRadius(16)
        .height($r('app.float.wh_height'))
        .backgroundColor('#F1F3F5')
      }
      .height("100%")
    }
    .width("100%")
  }
}