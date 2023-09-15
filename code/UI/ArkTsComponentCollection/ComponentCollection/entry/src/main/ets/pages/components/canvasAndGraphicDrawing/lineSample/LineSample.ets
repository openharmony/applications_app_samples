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
import { LineControlPanel } from './ChangePanel';

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct LineSample {
  @State startPointX: number = 0;
  @State startPointY: number = 0;
  @State endPointX: number = 200;
  @State endPointY: number = 150;
  @State strokeWidth: number = 10;
  @State stroke: Color = Color.Blue;
  @State strokeDashArray: number = 1;
  @State strokeOpacity: number = 50;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.line_title') })
      Column() {
        Column() {
          Line()
            .width(200)
            .height(150)
            .startPoint([this.startPointX, this.startPointY])
            .endPoint([this.endPointX, this.endPointY])
            .stroke(this.stroke)
            .strokeWidth(this.strokeWidth)
            .strokeDashArray([this.strokeDashArray])
            .strokeOpacity(this.strokeOpacity/100)
            .backgroundColor('#F5F5F5')
        }.cardStyle()
        .height('35%')
        .margin({ bottom: 10 })

        Column() {
          Scroll(){
            LineControlPanel({
              startPointX: $startPointX,
              startPointY: $startPointY,
              endPointX: $endPointX,
              endPointY: $endPointY,
              stroke: $stroke,
              strokeWidth: $strokeWidth,
              strokeDashArray: $strokeDashArray,
              strokeOpacity: $strokeOpacity
            })
          }
        }.cardStyle()
        .layoutWeight(1)
        .margin({bottom:4})
      }.padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .layoutWeight(1)
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}