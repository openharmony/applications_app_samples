/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
// 滑动控制子组件（如变焦、参数调节等）
import CameraService, { SliderValue } from '../model/CameraService';
import Logger from '../common/utils/Logger';
import { Constants } from  '../common/Constants';

const TAG = 'SlideComponent';
// 被component修饰的说明是一个自定义组件 滑条
@Component
export struct SlideComponent {
  // 当前变焦倍数（如 1.0、1.5），默认值 1，通过@StorageLink与全局存储关联，实现主组件与子组件的参数同步
  @StorageLink('zoomRatio') zoomRatio: number = 1;
  // SliderValue（来自CameraService）：滑动条参数类型，包含min（最小值）、max（最大值）、step（步长）；
  @StorageLink('sliderValue') sliderValue: SliderValue | undefined = undefined;
  // 变焦倍数的小数位数（固定为 2，如 1.00、2.50）
  private fractionDigits = 2;
  // 显示变焦倍数的单位（固定为 “x”，如 “1.0x”）
  private xString = 'x';
  // 滑动条的临时值，用于过滤重复触发的onChange事件（避免同一值多次处理）
  private defaultValue = 0;
  // 处理滑动条值变化
  slideChange(value: number) {
    // 将用户调整的变焦倍数传递给CameraService，实现相机硬件的变焦控制。
    CameraService.setZoomRatioFn(value);
  }
  // 渲染ui
  build() {
    if (this.sliderValue) {
      // 纵向容器
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
        // 横向容器
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
            .onChange((value: number) => { //滑动时触发
              if (this.defaultValue != value) {
                this.defaultValue = value;
                Logger.info(TAG, 'onChange');
                let val = Number(value.toFixed(this.fractionDigits));
                // 调用相机方法设置变焦。更新zoomRatio以同步 UI 显示。
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
