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
import { InputKeyEventUtils } from '../../common/utils/InputKeyEventUtils';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { Units } from '../../common/utils/PixelUnitConversion';

@CustomDialog
export struct DeleteDialog {
  controller: CustomDialogController;
  @State focusIndex: number = 0;
  cancel?: () => void;
  confirm?: () => void;

  aboutToAppear(): void {
    setTimeout(() => {
      focusControl.requestFocus('deleteCancel');
    }, 100);
  }

  aboutToDisappear(): void {
    AppStorage.setOrCreate('isSelect', false);
    AppStorage.setOrCreate('operationFiles', []);
  }

  build() {
    Column() {
      Text($r('app.string.prompt')).fontSize(Units.px2fp(40)).fontColor(Color.White)

      Text($r('app.string.sure_to_delete')).fontSize(Units.px2fp(28)).fontColor(Color.White)
        .margin({ top: Units.px2vp(48) })

      Row() {
        Stack() {
          Button($r('app.string.cancel'))
            .fontSize(Units.px2fp(36))
            .fontColor(this.focusIndex == 0 ? Color.Black : Color.White)
            .backgroundColor(this.focusIndex == 0 ? Color.White : $r('app.color.file_list_item_bg'))
            .width(Units.px2vp(248))
            .height(Units.px2vp(72))
            .borderRadius(Units.px2vp(72))
            .focusBox({
              strokeColor: ColorMetrics.numeric(Color.Transparent),
              strokeWidth: LengthMetrics.px(0)
            })
          if (this.focusIndex == 0) {
            Image($r('app.media.ic_public_button_selected'))
              .width('100%')
              .height('100%')
          }
        }
        .id('deleteCancel')
        .width(Units.px2vp(268))
        .height(Units.px2vp(92))
        .onHover(() => {
          this.focusIndex = 0;
        })
        .onTouch((e: TouchEvent) => {
          if (e.type === TouchType.Down) {
            this.focusIndex = 0;
          }
        })
        .onFocus(() => { this.focusIndex = 0; })
        .onClick(() => {
          this.controller.close();
          this.cancel && this.cancel();
        })

        Stack() {
          Button($r('app.string.sure'))
            .fontSize(Units.px2fp(36))
            .fontColor(this.focusIndex == 1 ? Color.Black : Color.White)
            .backgroundColor(this.focusIndex == 1 ? Color.White : $r('app.color.file_list_item_bg'))
            .width(Units.px2vp(248))
            .height(Units.px2vp(72))
            .borderRadius(Units.px2vp(72))
            .focusBox( {
              strokeColor: ColorMetrics.numeric(Color.Transparent),
              strokeWidth:LengthMetrics.px(0)
            })
          if (this.focusIndex == 1) {
            Image($r('app.media.ic_public_button_selected'))
              .width('100%')
              .height('100%')
          }
        }
        .id('deleteConfirm')
        .width(Units.px2vp(268))
        .height(Units.px2vp(92))
        .onHover(() => {
          this.focusIndex = 1;
        })
        .onTouch((e: TouchEvent) => {
          if (e.type === TouchType.Down) {
            this.focusIndex = 1;
          }
        })
        .onFocus(() => { this.focusIndex = 1; })
        .onClick(() => {
          this.confirm && this.confirm();
          this.controller.close();
        })
      }.margin({ top: Units.px2vp(54) })
    }
    .width(Units.px2vp(692))
    .height(Units.px2vp(332))
    .backgroundColor($r('app.color.dialog_bg'))
    .borderRadius(Units.px2vp(24))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onTouch((e) => {
      if (e.type === TouchType.Down) {
        if (this.focusIndex) {
          focusControl.requestFocus('deleteConfirm');
        } else {
          focusControl.requestFocus('deleteCancel');
        }
        InputKeyEventUtils.inputTab();
      }
    })
  }
}