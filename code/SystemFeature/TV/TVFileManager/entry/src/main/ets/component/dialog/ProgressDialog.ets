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
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { Units } from '../../common/utils/PixelUnitConversion';

@CustomDialog
export struct ProgressDialog {
  controller: CustomDialogController;
  @State focusIndex: number = 0;
  @LocalStorageLink('progressOne') progressOne: string ='';
  @LocalStorageLink('progressValue') currentNum: number = 1;
  @LocalStorageLink('progressSize') totalNum: number = 10;
  cancel?: Function;

  build() {
    Column() {
      Text($r('app.string.progress_dialog_title'))
        .fontSize(Units.px2vp(40))
        .fontColor($r('app.color.progress_dialog_title'))
        .margin({ top: Units.px2vp(40) })

      Progress({
        value: Number.parseInt(this.progressOne),
        total: 100,
        type: ProgressType.Linear
      })
        .width(Units.px2vp(440))
        .height(Units.px2vp(12))
        .margin({ top: Units.px2vp(60) })
        .color(new LinearGradient([{ color: $r('app.color.progress_dialog_progress_color1'), offset: 1 }, {
          color: $r('app.color.progress_dialog_progress_color2'),
          offset: 0
        }]))
        .backgroundColor($r('app.color.file_list_item_bg'))
        .style({ strokeWidth: Units.px2vp(15) })

      Text(`${this.currentNum}/${this.totalNum}`)
        .fontSize(Units.px2fp(28))
        .fontColor($r('app.color.progress_dialog_text'))
        .margin({ top: Units.px2vp(24) })

      Stack() {
        Text($r('app.string.cancel'))
          .id('progressCancel')
          .fontSize(Units.px2fp(36))
          .textAlign(TextAlign.Center)
          .fontColor(this.focusIndex == 0 ? Color.Black : Color.White)
          .backgroundColor(this.focusIndex == 0 ? Color.White : $r('app.color.file_list_item_bg'))
          .width(Units.px2vp(248))
          .height(Units.px2vp(72))
          .borderRadius(Units.px2vp(72))
        if (this.focusIndex == 0) {
          Image($r('app.media.ic_public_button_selected'))
            .width('100%')
            .height('100%')
        }
      }
      .id('progressCancel')
      .focusBox( {
        strokeColor: ColorMetrics.numeric(Color.Transparent),
        strokeWidth: LengthMetrics.px(0)
      })
      .width(Units.px2vp(268))
      .height(Units.px2vp(92))
      .margin({ top: Units.px2vp(44) })
      .onFocus(() => { this.focusIndex = 0; })
      .onClick(() => {
        this.controller.close();
        this.cancel && this.cancel();
      })
      .onTouch((e: TouchEvent) => {
        if (e.type === TouchType.Down) {
          this.focusIndex = 0;
        }
      })
      .focusable(true)
      .defaultFocus(true)
      .focusBox( {
        strokeColor: ColorMetrics.numeric(Color.Transparent),
        strokeWidth: LengthMetrics.px(0)
      })
    }
    .width(Units.px2vp(692))
    .padding({ bottom: Units.px2vp(30) })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.progress_dialog_bg'))
    .borderRadius(Units.px2vp(24))
  }
}