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
import { Units } from '../../common/utils/PixelUnitConversion';

@CustomDialog
export struct OverrideDialog {
  controller: CustomDialogController;
  @State focusIndex: number = 0;
  @State filename:string = '';
  cancel?: () => void;
  confirm?: () => void;

  aboutToAppear(): void {
    setTimeout(() => {
      focusControl.requestFocus('overrideCancel');
    }, 200);
  }

  aboutToDisappear(): void {
  }

  build() {
    Column() {
      Text($r('app.string.prompt'))
        .fontSize(Units.px2fp(40)).fontColor(Color.White)

      Text($r('app.string.override_dialog_context',this.filename))
        .fontSize(Units.px2fp(28)).fontColor(Color.White)
        .margin({ top: Units.px2vp(48) })

      Row() {
        Stack() {
          Text($r('app.string.override_dialog_cancel'))
            .fontSize(Units.px2fp(36))
            .fontColor(this.focusIndex == 0 ? Color.Black : Color.White)
            .backgroundColor(this.focusIndex == 0 ? Color.White : $r('app.color.file_list_item_bg'))
            .textAlign(TextAlign.Center)
            .width(Units.px2vp(248))
            .height(Units.px2vp(72))
            .borderRadius(Units.px2vp(72))
          if (this.focusIndex == 0) {
            Image($r('app.media.ic_public_button_selected'))
              .width('100%')
              .height('100%')
          }
        }
        .id('overrideCancel')
        .width(Units.px2vp(268))
        .height(Units.px2vp(92))
        .stateStyles({
          focused: {
            .border({
              color: Color.Transparent
            })
          }
        })
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
        .margin({
          right:Units.px2vp(36)
        })

        Stack() {
          Text($r('app.string.override_dialog_confirm'))
            .fontSize(Units.px2fp(36))
            .fontColor(this.focusIndex == 1 ? Color.Black : Color.White)
            .width(Units.px2vp(248))
            .height(Units.px2vp(72))
            .borderRadius(Units.px2vp(72))
            .textAlign(TextAlign.Center)
            .backgroundColor(this.focusIndex == 1 ? Color.White : $r('app.color.file_list_item_bg'))
          if (this.focusIndex == 1) {
              Image($r('app.media.ic_public_button_selected'))
                .width('100%')
                .height('100%')
            }
        }
        .id('overrideConfirm')
        .width(Units.px2vp(268))
        .height(Units.px2vp(92))
        .stateStyles({
          focused: {
            .border({
              color: Color.Transparent
            })
          }
        })
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
        .margin({
          left:Units.px2vp(36)
        })
      }.margin({ top: Units.px2vp(54) })
      .justifyContent(FlexAlign.SpaceBetween)
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
          focusControl.requestFocus('overrideConfirm');
        } else {
          focusControl.requestFocus('overrideCancel');
        }
        InputKeyEventUtils.inputTab();
      }
    })
  }
}