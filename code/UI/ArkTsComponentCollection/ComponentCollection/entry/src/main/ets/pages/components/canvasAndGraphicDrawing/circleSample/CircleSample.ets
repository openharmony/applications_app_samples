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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { CircleControlPanel } from './ChangePanel'

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(24)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct CircleSample {
  @State circleRadius: number = 100;
  @State fillOpacity: number = 0.5;
  @State strokeWidth: number = 3;
  @State stroke: Color = Color.Red;
  @State strokeDashArray: number = 1;
  @State fill: Color = Color.Blue;
  @State strokeOpacity: number = 0.5;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.circle_title') })
      Column() {
        Column() {
          // 绘制一个直径为100的圆,宽高设置不一致时以短边为直径
          Circle()
            .width(this.circleRadius)
            .height(this.circleRadius)
            .fill(this.fill)
            .fillOpacity(this.fillOpacity)
            .stroke(this.stroke)
            .strokeWidth(this.strokeWidth)
            .strokeDashArray([this.strokeDashArray])
            .strokeOpacity(this.strokeOpacity)
        }.cardStyle()

        IntroductionTitle({ introduction: $r('app.string.circle_change') })
        Column() {
          CircleControlPanel({
            circleRadius: $circleRadius,
            fill: $fill,
            fillOpacity: $fillOpacity,
            stroke: $stroke,
            strokeWidth: $strokeWidth,
            strokeDashArray: $strokeDashArray,
            strokeOpacity: $strokeOpacity
          })
        }.cardStyle()
      }.padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}