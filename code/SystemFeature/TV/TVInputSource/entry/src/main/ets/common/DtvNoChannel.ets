/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { KeyCode } from '@kit.InputKit';
@CustomDialog
export default struct dtvnoChannel {
  private countdownInterval: number = -1;
  dtvmessage: string = '';
  dtvtitle: string = '';
  controllerdtv: CustomDialogController;
  @State focusId: string = ''
  @State countdown:number=8;
  aboutToAppear(): void {
    this.focusId = 'cancel1';
    focusControl.requestFocus('cancel1');
    this.countdownInterval = setInterval(() => {
      this.countdown -= 1;
      // 倒计时结束
      if (this.countdown <= 0) {
        clearInterval(this.countdownInterval);
        this.controllerdtv.close();
      }
    }, 1000);
  }
  aboutToDisappear(): void {
    clearInterval(this.countdownInterval);
  }

  build() {
    Column() {
      Column() {
        // 1.标题
        Text(this.dtvtitle)
          .fontSize('40lpx')
          .fontWeight(500)
          .height('47lpx')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor('#ffffff');
        // 2.内容
        Text(this.dtvmessage)
          .fontSize('24lpx')
          .fontWeight(500)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor('#ffffff')
          .margin({ top: '48lpx' });

        Row() {
          Row() {
            Button('确定('+this.countdown+')')
              .width('248lpx')
              .height('72lpx')
              .fontWeight(500)
              .borderRadius('72lpx')
              .backgroundColor('#DBFFFFFF')
              .fontColor('#DB000000')
              .fontSize('36lpx')
              .focusable(true)
              .defaultFocus(true)
              .id('cancel1')
              .onClick(() => {
                this.controllerdtv.close();
              })
              .onKeyEvent((e?: KeyEvent)=>{
                if (!e) {
                  return;
                }
                if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Down) {
                  this.controllerdtv.close();
                }
              });
          }
          .padding('8lpx')
          .borderRadius('72lpx')
          .border({
            width: '2lpx',
            color: '#ffffff'
          });
        }
        .width('100%')
        .margin({ top: '48lpx', bottom: '30lpx' })
        .justifyContent(FlexAlign.SpaceAround)
        .focusable(true);
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
