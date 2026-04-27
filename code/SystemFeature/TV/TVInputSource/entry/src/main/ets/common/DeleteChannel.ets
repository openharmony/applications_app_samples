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
export default struct deletechannel {
  deletemessage: string = '';
  deletetitle: string = '';
  deletecontroller: CustomDialogController;
  deleteconfirm: () => void = () => {
  }
  @State deleteselectedFontColor: string = '#DB000000'
  @State deleteunSelectedFontColor: string = '#DBFFFFFF'
  @State deleteselectedBgColor: string = '#DBFFFFFF'
  @State deleteunselectedBgColor: string = '#33FFFFFF'
  @State deletefocusId: string = ''

  aboutToAppear(): void {
    this.deletefocusId = 'deletecancel';
    focusControl.requestFocus('deletecancel');
  }

  build() {
    Column() {
      Column() {
        // 1.标题
        Text(this.deletetitle)
          .fontSize('40lpx')
          .fontWeight(500)
          .height('47lpx')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor('#ffffff');
        // 2.内容
        Text(this.deletemessage)
          .fontSize('24lpx')
          .fontWeight(500)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor('#ffffff')
          .margin({ top: '48lpx' });

        Row() {
          Row() {
            Button('取消')
              .width('248lpx')
              .height('72lpx')
              .fontWeight(500)
              .backgroundColor(this.deletefocusId === 'deletecancel' ? this.deleteselectedBgColor : this.deleteunselectedBgColor)
              .fontColor(this.deletefocusId === 'deletecancel' ? this.deleteselectedFontColor : this.deleteunSelectedFontColor)
              .fontSize('36lpx')
              .focusable(true)
              .defaultFocus(true)
              .id('deletecancel')
              .onClick(() => {
                this.deletecontroller.close();
              });
          }
          .padding('8lpx')
          .borderRadius('72lpx')
          .border({
            width: '2lpx',
            color: this.deletefocusId === 'deletecancel' ? '#ffffff' : 'transparent'
          });

          // 3.按钮
          Row() {
            Button('删除')
              .width('248lpx')
              .height('72lpx')
              .fontSize('36lpx')
              .fontWeight(500)
              .focusable(true)
              .id('deletesure')
              .backgroundColor(this.deletefocusId === 'deletesure' ? this.deleteselectedBgColor : this.deleteunselectedBgColor)
              .fontColor(this.deletefocusId === 'deletesure' ? this.deleteselectedFontColor : this.deleteunSelectedFontColor)
              .onClick(() => {
                this.deleteconfirm();
                this.deletecontroller.close();
              });
          }
          .padding('8lpx')
          .borderRadius('72lpx')
          .border({
            width: '2lpx',
            color: this.deletefocusId === 'deletesure' ? '#ffffff' : 'transparent'
          });
        }
        .width('100%')
        .margin({ top: '48lpx', bottom: '30lpx' })
        .justifyContent(FlexAlign.SpaceAround)
        .focusable(true)
        .onKeyEvent((e?: KeyEvent) => {
          if (!e) {
            return;
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
            this.deletefocusId = 'deletecancel';
            focusControl.requestFocus('deletecancel');
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
            this.deletefocusId = 'deletesure';
            focusControl.requestFocus('deletesure');
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
