/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

// Zoom component
// For changes in components - can only be integers 1 to 6
import cameraDemo from 'libentry.so'
import Logger from '../model/Logger';

const TAG: string = 'SlidePage';

@Component
export struct SlidePage {
  // Slide slider
  @State outSetValueOne: number = 1;
  // Slide slider movement value
  @State sliderTextPos: string = '-10';

  slideChange(value: number) {
    cameraDemo.setZoomRatio(value);
    switch (value) {
      case 1:
        this.sliderTextPos = '-10';
        break;
      case 2:
        this.sliderTextPos = '70';
        break;
      case 3:
        this.sliderTextPos = '145';
        break;
      case 4:
        this.sliderTextPos = '220';
        break;
      case 5:
        this.sliderTextPos = '300';
        break;
      case 6:
        this.sliderTextPos = '380';
        break;
      default:
        break;
    }
  }

  build() {

    Column() {
      Row() {
        Text('1x').fontColor(Color.White);
        Text('6x').fontColor(Color.White);
      }.justifyContent(FlexAlign.SpaceBetween).width('95%')

      Text(this.outSetValueOne + 'x')
        .fontColor('#182431')
        .width('100px')
        .height('50px')
        .borderRadius(25)
        .backgroundColor(Color.White)
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .position({ x: this.sliderTextPos, y: '-5' })
        .zIndex(9)

      Row() {
        Slider({
          value: this.outSetValueOne,
          min: 1,
          max: 6,
          step: 1,
          style: SliderStyle.OutSet
        }).showSteps(false)
          .trackColor('rgba(255,255,255,0.6)')
          .selectedColor($r('app.color.theme_color'))
          .onChange((value: number) => {
            let val = Number(value.toFixed(2));
            this.slideChange(val);
            this.outSetValueOne = val;
            console.info('value:' + val + 'this.sliderTextPos:' + this.sliderTextPos);
          })
      }.width('100%')

    }
    .height('60')
    .width('32.5%')
    .position({ x: '35%', y: '3%' })
  }
}