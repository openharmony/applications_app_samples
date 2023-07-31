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
import { PolylineControlPanel } from './ChangePanel'

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(24)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct PolylineSample {
  @State polylineFirstX: number = 0;
  @State polylineFirstY: number = 0;
  @State polylineSecondX: number = 20;
  @State polylineSecondY: number = 60;
  @State polylineThirdX: number = 100;
  @State polylineThirdY: number = 100;
  @State strokeWidth: number = 3;
  @State stroke: Color = Color.Red;
  @State strokeDashArray: number = 1;
  @State strokeOpacity: number = 0.5;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.polyline_title') })
      Column() {
        Column() {
          // 在 100 * 100 的矩形框中绘制一段折线，起点(0, 0)，经过(20,60)，到达终点(100, 100)
          Polyline({ width: 100, height: 100 })
            .points([[this.polylineFirstX, this.polylineFirstY], [this.polylineSecondX, this.polylineSecondY], [this.polylineThirdX, this.polylineThirdY]])
            .fillOpacity(0)
            .stroke(this.stroke)
            .strokeWidth(this.strokeWidth)
            .strokeDashArray([this.strokeDashArray])
            .strokeOpacity(this.strokeOpacity)
              // 设置折线拐角处为圆弧
            .strokeLineJoin(LineJoinStyle.Round)
              // 设置折线两端为半圆
            .strokeLineCap(LineCapStyle.Round)
        }.cardStyle()

        Column() {
          PolylineControlPanel({
            polylineFirstX: $polylineFirstX,
            polylineFirstY: $polylineFirstY,
            polylineSecondX: $polylineSecondX,
            polylineSecondY: $polylineSecondY,
            polylineThirdX: $polylineThirdX,
            polylineThirdY: $polylineThirdY,
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