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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { PolygonControlPanel } from './ChangePanel';

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct PolygonSample {
  @State fillOpacity: number = 50;
  @State strokeWidth: number = 3;
  @State stroke: Color = Color.Blue;
  @State strokeDashArray: number = 1;
  @State fill: Color = Color.Blue;
  @State strokeOpacity: number = 50;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.polygon_title') })
      Column() {
        Column() {
          Scroll() {
            Column() {
              Polygon({ width: 100, height: 100 })
                .points([[0, 0], [50, 100], [100, 0]])
                .fill(this.fill)
                .fillOpacity(this.fillOpacity / 100)
                .stroke(this.stroke)
                .strokeWidth(this.strokeWidth)
                .strokeDashArray([this.strokeDashArray])
                .strokeOpacity(this.strokeOpacity / 100)
                .margin({ bottom: 20 })
              Polygon()
                .width(100)
                .height(100)
                .points([[0, 0], [0, 100], [100, 100], [100, 0]])
                .fill(this.fill)
                .fillOpacity(this.fillOpacity / 100)
                .stroke(this.stroke)
                .strokeWidth(this.strokeWidth)
                .strokeDashArray([this.strokeDashArray])
                .strokeOpacity(this.strokeOpacity / 100)
                .margin({ bottom: 20 })
              Polygon()
                .width(100)
                .height(100)
                .points([[50, 0], [0, 50], [20, 100], [80, 100], [100, 50]])
                .fill(this.fill)
                .fillOpacity(this.fillOpacity / 100)
                .stroke(this.stroke)
                .strokeWidth(this.strokeWidth)
                .strokeDashArray([this.strokeDashArray])
                .strokeOpacity(this.strokeOpacity / 100)
            }
          }.height('100%')
          .width('100%')
        }
        .cardStyle()
        .height('35%')
        .margin({ bottom: 10 })

        Column() {
          Scroll() {
            PolygonControlPanel({
              fill: $fill,
              fillOpacity: $fillOpacity,
              stroke: $stroke,
              strokeWidth: $strokeWidth,
              strokeDashArray: $strokeDashArray,
              strokeOpacity: $strokeOpacity
            })
          }
        }.cardStyle()
        .layoutWeight(1)
        .margin({ bottom: 4 })
      }.padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .layoutWeight(1)
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}