/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import CameraService, { SliderValue } from '../model/CameraService';
import Logger from '../common/utils/Logger';
import { Constants } from  '../common/Constants';

const TAG = 'SlideComponent';

@Component
export struct SlideComponent {
  @StorageLink('zoomRatio') zoomRatio: number = 1;
  @StorageLink('sliderValue') sliderValue: SliderValue | undefined = undefined;
  private fractionDigits = 2;
  private xString = 'x';
  private defaultValue = 0;

  slideChange(value: number) {
    CameraService.setZoomRatioFn(value);
  }

  build() {
    if (this.sliderValue) {
      Column() {
        Row() {
          Text(this.zoomRatio + this.xString)
            .fontColor($r('app.color.slide_text_font_color'))
            .width($r('app.float.text_width_120'))
            .height($r('app.float.text_height_50'))
            .borderRadius(Constants.TEXT_BORDER_RADIUS)
            .backgroundColor(Color.White)
            .fontSize(Constants.FONT_SIZE_14)
            .textAlign(TextAlign.Center)
        }
        .justifyContent(FlexAlign.Center)
        .width(Constants.FULL_PERCENT)

        Row() {
          Text(this.sliderValue?.min + this.xString).fontColor(Color.White)
          Text(this.sliderValue?.max + this.xString).fontColor(Color.White)
        }.justifyContent(FlexAlign.SpaceBetween).width(Constants.FULL_PERCENT)

        Row() {
          Slider({
            value: this.zoomRatio,
            min: this.sliderValue?.min,
            max: this.sliderValue?.max,
            step: this.sliderValue?.step,
            style: SliderStyle.OutSet
          })
            .showSteps(false)
            .trackColor($r('app.color.slider_track_color'))
            .selectedColor($r('app.color.theme_color'))
            .onChange((value: number) => {
              if (this.defaultValue != value) {
                this.defaultValue = value;
                Logger.info(TAG, 'onChange');
                let val = Number(value.toFixed(this.fractionDigits));
                this.slideChange(val);
                this.zoomRatio = val;
              }
            })
        }
        .width(Constants.FULL_PERCENT)
      }
      .height($r('app.float.size_60'))
      .width(Constants.FORTY_PERCENT)
      .position({ x: Constants.THIRTY_PERCENT, y: Constants.SEVENTY_FIVE_PERCENT })
    }
  }
}
