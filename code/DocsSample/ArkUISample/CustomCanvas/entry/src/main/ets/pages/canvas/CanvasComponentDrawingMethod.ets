/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
@Entry
@Component
struct CanvasComponentDrawingMethod {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private settings2: RenderingContextSettings = new RenderingContextSettings(true);
  private context2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings2);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      List({ space: 20 }) {
        ListItem() {
          // [Start contextCallApi_start]
          Canvas(this.context)
            .width('100%')
            .height('100%')
            .backgroundColor('#F5DC62')
            .onReady(() => {
              this.context.beginPath();
              this.context.moveTo(50, 50);
              this.context.lineTo(280, 160);
              this.context.stroke();
            })
          // [End contextCallApi_start]
        }.height('50%')

        ListItem() {
          // [Start definePath2d_start]
          Canvas(this.context2)
            .width('100%')
            .height('100%')
            .backgroundColor('#F5DC62')
            .onReady(() => {
              let region = new Path2D();
              region.arc(100, 75, 50, 0, 6.28);
              this.context2.stroke(region);
            })
          // [End definePath2d_start]
        }.height('50%')

      }.width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
  }
}