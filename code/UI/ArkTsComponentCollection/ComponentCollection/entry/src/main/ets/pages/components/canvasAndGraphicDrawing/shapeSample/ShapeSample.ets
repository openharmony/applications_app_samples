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
import { ShapeControlPanel } from './ChangePanel';

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct ShapeSample {
  @State viewPortX: number = 0;
  @State viewPortY: number = 0;
  @State viewPortWidth: number = 450;
  @State viewPortHeight: number = 450;
  @State fillOpacity: number = 50;
  @State strokeWidth: number = 3;
  @State stroke: Color = Color.Blue;
  @State strokeDashArray: number = 1;
  @State fill: Color = Color.Blue;
  @State strokeOpacity: number = 50;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.shape_title') })
      Column() {
        Column() {
          Shape() {
            Rect().width('100%').height('100%')
            Circle({ width: 75, height: 75 })
          }
          .viewPort({ x: this.viewPortX, y: this.viewPortY, width: this.viewPortWidth, height: this.viewPortHeight })
          .width(300)
          .height(200)
          .backgroundColor('#F5DC62')
          .fill(this.fill)
          .fillOpacity(this.fillOpacity / 100)
          .stroke(this.stroke)
          .strokeWidth(this.strokeWidth)
          .strokeOpacity(this.strokeOpacity / 100)
          .strokeDashArray([this.strokeDashArray])
        }.cardStyle()
        .height('35%')
        .margin({ bottom: 10 })

        Column() {
          Scroll() {
            ShapeControlPanel({
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
