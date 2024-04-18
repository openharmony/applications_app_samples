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

import CameraService from '../model/CameraService';
import Logger from '../model/Logger';

const TAG: string = 'SlidePage';

// 变焦组件
@Component
export struct SlidePage {
  @StorageLink('zoomRatioMin') zoomMin: number = 1;
  @StorageLink('zoomRatioMax') zoomMax: number = 6;
  // slide滑块
  @State outSetValueOne: number = 1;
  // slide滑块移动值
  @State sliderTextPos: string = '-10';

  slideChange(value: number) {
    CameraService.setZoomRatioFn(value);
    this.sliderTextPos = (value - this.zoomMin) / (this.zoomMax - this.zoomMin) * 80 + '%';
  }

  build() {
    Column() {
      Text(this.outSetValueOne + 'x')
        .fontColor('#182431')
        .height('50px')
        .borderRadius(25)
        .backgroundColor(Color.White)
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .margin({ left: this.sliderTextPos })
        .padding('3px')
        .alignSelf(ItemAlign.Start)

      Row() {
        Text(this.zoomMin + 'x').fontColor(Color.White)
        Text(this.zoomMax + 'x').fontColor(Color.White)
      }.justifyContent(FlexAlign.SpaceBetween).width('95%')


      Row() {
        Slider({
          value: this.outSetValueOne,
          min: this.zoomMin,
          max: this.zoomMax,
          step: 0.1,
          style: SliderStyle.OutSet
        })
          .showSteps(false)
          .trackColor('rgba(255,255,255,0.6)')
          .selectedColor($r('app.color.theme_color'))
          .onChange((value: number) => {
            let val = Number(value.toFixed(2));
            this.slideChange(val);
            this.outSetValueOne = val;
            Logger.info(TAG, `onChange value: ${val}, sliderTextPos: ${this.sliderTextPos}`);
          })
      }.onAppear(() => {
        this.slideChange(1);
      })
      .width('100%')
    }
    .height('60')
    .width('100%')
    .padding({ left: '20%', right: '20%' })
    .position({ y: '65%' })
  }
}
