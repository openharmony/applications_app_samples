/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import image from '@ohos.multimedia.image';
import { CommonConstants } from '../common/constant/CommonConstants';
import { pixelMapProcessByTaskPool } from '../utils/TreadUtil';

@Component
export struct AdjustImageView {
  @Consume currentAdjustData: number;

  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_saturation'))
          .width($r('app.float.adjust_icon_width'))
          .height($r('app.float.adjust_icon_height'))

        Text($r('app.string.saturation'))
          .fontColor(Color.White)
          .fontSize($r('app.float.adjust_font_size'))
          .margin({ top: $r('app.float.adjust_margin_top') })
      }
      .width($r('app.string.layout_10_percent'))

      SliderCustom({
        min: CommonConstants.SLIDER_MIN.valueOf(),
        max: CommonConstants.SLIDER_MAX.valueOf(),
        currentAdjustData: $currentAdjustData
      })
    }
    .width($r('app.string.layout_80_percent'))
  }
}

@Component
struct SliderCustom {
  @Link currentAdjustData: number;
  @Prop min: number;
  @Prop max: number;
  @Consume pixelMap: image.PixelMap | undefined;
  @Consume isPixelMapChanged: boolean;
  @Consume currentTaskNum: number;
  @Consume isParamsByTransfer: boolean;
  @State postState: boolean = true;
  lastAdjustData: number = CommonConstants.SLIDER_MAX;
  deviceListDialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog(),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: true,
  });

  build() {
    Column() {
      Text(`${this.currentAdjustData}`)
        .fontColor(Color.White)
        .margin({ top: $r('app.float.slider_margin_top') })
        .fontSize($r('app.float.slider_font_size'))
      Row() {
        Slider({
          value: this.currentAdjustData,
          step: CommonConstants.SLIDER_STEP,
          min: this.min,
          max: this.max
        }).id('thread_transfer_data_slider')
          .trackColor(Color.White)
          .width($r('app.string.layout_80_percent'))
          .showSteps(true)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.sliderChange(value, mode);
          })
      }
      .width($r('app.string.layout_100_percent'))
      .justifyContent(FlexAlign.Center)
    }
  }

  async sliderChange(value: number, mode: SliderChangeMode) : Promise<void>{
    if (this.pixelMap !== undefined && mode === SliderChangeMode.End) {
      if (this.postState) {
        this.deviceListDialogController.open();
      }
      this.postState = false;
      this.currentAdjustData = Math.round(value);
      pixelMapProcessByTaskPool(this.pixelMap, this.lastAdjustData, this.currentAdjustData, this.currentTaskNum, this.isParamsByTransfer, (data: ArrayBuffer) => {
        if (this.pixelMap !== undefined) {
          const newPixel: image.PixelMap = this.pixelMap;
          newPixel.writeBufferToPixels(data).then(() => {
            this.pixelMap = newPixel;
            this.lastAdjustData = Math.round(value);
            this.isPixelMapChanged = !this.isPixelMapChanged;
            this.deviceListDialogController.close();
            this.postState = true;
          });
        }
      });
    }
  }
}


@CustomDialog
export struct Dialog {
  controller: CustomDialogController;

  build() {
    Column() {
      LoadingProgress()
        .color(Color.White)
        .width($r('app.string.layout_30_percent'))
        .height($r('app.string.layout_30_percent'))
    }
  }
}