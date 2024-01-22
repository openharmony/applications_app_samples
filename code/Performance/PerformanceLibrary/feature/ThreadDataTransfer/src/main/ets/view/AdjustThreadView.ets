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
import { CommonConstants } from '../common/constant/CommonConstants';

@Component
export struct AdjustThreadView {
  @Consume currentTaskNum: number;
  @Consume isParamsByTransfer: boolean;

  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.ic_task'))
            .width($r('app.float.adjust_icon_width'))
            .height($r('app.float.adjust_icon_height'))

          Text($r('app.string.task_num'))
            .fontColor(Color.White)
            .fontSize($r('app.float.adjust_font_size'))
            .margin({ top: $r('app.float.adjust_margin_top') })
        }
        .width($r('app.string.layout_15_percent'))

        SliderCustom({
          min: CommonConstants.TASK_MIN.valueOf(),
          max: CommonConstants.TASK_MAX.valueOf(),
          currentTaskNum: $currentTaskNum
        })
      }
      .width($r('app.string.layout_80_percent'))

      Row() {
        Column() {
          Image($r('app.media.ic_copy'))
            .width($r('app.float.adjust_icon_width'))
            .height($r('app.float.adjust_icon_height'))

          Text($r('app.string.pass_params'))
            .fontColor(Color.White)
            .fontSize($r('app.float.adjust_font_size'))
            .margin({ top: $r('app.float.adjust_margin_top') })
        }
        .width($r('app.string.layout_15_percent'))

        Column() {
          Row() {
            Text($r('app.string.start_transfer'))
              .fontSize($r('app.float.slider_font_size'))
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
            Toggle({
              type: ToggleType.Switch,
              isOn: this.isParamsByTransfer
            })
              .selectedColor(Color.Green)
              .switchPointColor(Color.White)
              .onChange((isOn: boolean) => {
                this.isParamsByTransfer = isOn;
              })
          }
        }
        .width($r('app.string.layout_100_percent'))
        .justifyContent(FlexAlign.Center)
      }
      .width($r('app.string.layout_80_percent'))
    }
  }
}

@Component
struct SliderCustom {
  @Link currentTaskNum: number;
  @Prop min: number;
  @Prop max: number;
  build() {
    Column() {
      Text(`${this.currentTaskNum}`)
        .fontColor(Color.White)
        .margin({ top: $r('app.float.slider_margin_top') })
        .fontSize($r('app.float.slider_font_size'))
      Row() {
        Slider({
          value: this.currentTaskNum,
          step: CommonConstants.SLIDER_STEP,
          min: this.min,
          max: this.max
        })
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

  sliderChange(value: number, mode: SliderChangeMode) :void{
    if (mode === SliderChangeMode.End) {
      this.currentTaskNum = Math.round(value);
    }
  }
}