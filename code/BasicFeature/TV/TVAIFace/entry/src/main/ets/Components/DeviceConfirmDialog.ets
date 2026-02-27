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

import { KeyCode } from '@kit.InputKit';

@CustomDialog
export default struct DeviceConfirmDialog {
  content: string = '';
  title: ResourceStr = '';
  controller: CustomDialogController;
  confirm: (title: ResourceStr, deviceId: string, deviceName: string, path: string) => void = () => {
  };
  deviceId: string = '';
  deviceName: string = '';
  path: string = '';
  @State selectedFontColor: string = '#DB000000';
  @State unSelectedFontColor: string = '#DBFFFFFF';
  @State selectedBgColor: string = '#DBFFFFFF';
  @State unselectedBgColor: string = '#33FFFFFF';
  @State focusId: string = '';

  aboutToAppear(): void {
    console.log('777');
    this.focusId = 'cancel';
    focusControl.requestFocus('cancel');
  }

  build() {
    Column() {
      Column() {
        // 1.标题
        Text(this.title)
          .fontSize('40lpx')
          .fontWeight(500)
          .height('47lpx')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.white'));
        // 2.内容
        Text(this.content)
          .fontSize('24lpx')
          .fontWeight(500)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.white'))
          .margin({ top: '48lpx' });

        Row() {
          Row() {
            Button($r('app.string.cancel'))
              .width('248lpx')
              .height('72lpx')
              .fontWeight(500)
              .backgroundColor(this.focusId === 'cancel' ? this.selectedBgColor : this.unselectedBgColor)
              .fontColor(this.focusId === 'cancel' ? this.selectedFontColor : this.unSelectedFontColor)
              .fontSize('36lpx')
              .focusable(true)
              .defaultFocus(true)
              .id('cancel')
              .onClick(() => {
                this.controller.close();
              });
          }
          .padding('8lpx')
          .borderRadius('72lpx')
          .border({
            width: '2lpx',
            color: this.focusId === 'cancel' ? '#ffffff' : 'transparent'
          });

          // 3.按钮
          Row() {
            Button($r('app.string.sure'))
              .width('248lpx')
              .height('72lpx')
              .fontSize('36lpx')
              .fontWeight(500)
              .focusable(true)
              .id('sure')
              .backgroundColor(this.focusId === 'sure' ? this.selectedBgColor : this.unselectedBgColor)
              .fontColor(this.focusId === 'sure' ? this.selectedFontColor : this.unSelectedFontColor)
              .onClick(() => {
                this.confirm(this.title, this.deviceId, this.deviceName, this.path);
                this.controller.close();
              });
          }
          .padding('8lpx')
          .borderRadius('72lpx')
          .border({
            width: '2lpx',
            color: this.focusId === 'sure' ? '#ffffff' : 'transparent'
          });
        }
        .width('100%')
        .margin({ top: '48lpx', bottom: '30lpx' })
        .justifyContent(FlexAlign.SpaceAround)
        .focusable(true)
        .onKeyEvent(e => {
          if (e.keyCode === KeyCode.KEYCODE_DPAD_LEFT && e.type === KeyType.Up) {
            this.focusId = 'cancel';
            focusControl.requestFocus('cancel');
          }
          if (e.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && e.type === KeyType.Up) {
            this.focusId = 'sure';
            focusControl.requestFocus('sure');
          }
        });
      }
      .width('692lpx')
      .backgroundColor('#404040')
      .borderRadius('24lpx')
      .padding({
        top: '48lpx',
        bottom: '30lpx',
        left: '30lpx',
        right: '30lpx'
      });
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#cc000000');
  }
}