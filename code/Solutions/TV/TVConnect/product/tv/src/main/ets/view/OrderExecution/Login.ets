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
import cert from '@ohos.security.cert';
import { router } from '@kit.ArkUI';
import { Logger } from '@ohos/common';

let i = 0;

@Component
export default struct Login {
  @State userName: string = '';
  controller: TextInputController = new TextInputController();

  build() {
    Column() {
      Text('lOGO')
        .borderRadius(5)
        .shadow({
          radius: 20,
          color: $r('app.color.gray999'),
          offsetX: 2,
          offsetY: 2
        })
        .margin({ top: 80 })
        .fontSize(14)
        .width(40)
        .height(40)
        .backgroundColor('#fff')
        .textAlign(TextAlign.Center);
      Column() {
        Image($r('app.media.login_ewm')).width(16).margin({ top: 10 }).position({ x: '90%', y: 10 });
        Line()
          .width(200)
          .height(150)
          .startPoint([180, 0])
          .endPoint([238, 56])
          .stroke($r('app.color.nurse_blue'))
          .position({ x: 0 });
        Image($r('app.media.login_face')).width(40).margin({ top: 20 });
        Text($r('app.string.Hepatobiliary_Surgery_Ward1')).fontSize(10).fontColor($r('app.color.nurse_blue')).margin({ top: 20 });
        Text($r('app.string.DeviceNumber_001')).fontSize(8).fontColor($r('app.color.nurse_blue')).margin({ top: 15, bottom: 30 });
        // 账号
        Row() {
          Row() {
            Image($r('app.media.nurse_icon_user')).width(10);
          }
          .backgroundColor($r('app.color.nurse_blue'))
          .padding(8)
          .position({ x: 0 })
          .borderRadius({
            bottomLeft: 15,
            bottomRight: 0,
            topRight: 0,
            topLeft: 15
          });

          TextInput({ text: this.userName, placeholder: '工号', controller: this.controller })
            .placeholderColor(Color.Gray)
            .placeholderFont({ size: 10, weight: 400 })
            .caretColor(Color.Blue)
            .width(160)
            .height(26)
            .padding({
              left: 35,
              top: 5,
              bottom: 5,
              right: 5
            })
            .margin({ bottom: 20 })
            .fontSize(10)
            .fontColor(Color.Black)
            .border({
              width: 0.5,
              color: $r('app.color.nurse_blue'),
              style: {
                bottom: BorderStyle.Solid,
              }
            })
            .inputFilter('[a-z]', (e) => {
              Logger.info(JSON.stringify(e));
            })
            .onChange((value: string) => {
              this.userName = value;
            });
        };

        //密码
        Row() {
          Row() {
            Image($r('app.media.nurse_icon_pwd')).width(10);
          }
          .backgroundColor($r('app.color.nurse_blue'))
          .padding(8)
          .position({ x: 0 })
          .borderRadius({
            bottomLeft: 15,
            bottomRight: 0,
            topRight: 0,
            topLeft: 15
          });

          TextInput({ placeholder: '密码' })
            .placeholderColor(Color.Gray)
            .placeholderFont({ size: 10, weight: 400 })
            .width(160)
            .height(26)
            .padding({
              left: 35,
              top: 5,
              bottom: 5,
              right: 5
            })
            .fontSize(10)
            .fontColor(Color.Black)
            .type(InputType.Password)
            .maxLength(9)
            .showPasswordIcon(true)
            .border({
              width: 0.5,
              color: $r('app.color.nurse_blue'),
              style: {
                bottom: BorderStyle.Solid,
              }
            });

        };

        Image($r('app.media.login_btn')).width(86).margin({ top: 20 })
          .onClick(() => {
            i += 1;

            if (i == 10) {
              i = 0;
              router.pushUrl({
                url: 'pages/OrderExecution/OrderExecutionTestPage'
              });
            }
          });
      }.margin({ top: 61 }).width('88%').height('62%');

      Text($r('app.string.operating_system_settings'))
        .fontSize(8)
        .fontColor($r('app.color.nurse_blue'))
        .lineHeight(16)
        .margin({ top: 5 })
        .border({
          width: { bottom: 1 },
          color: $r('app.color.nurse_blue'),
        });
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.login_bg'))
    .backgroundImageSize({ width: '100%', height: '100%' });
  }
}