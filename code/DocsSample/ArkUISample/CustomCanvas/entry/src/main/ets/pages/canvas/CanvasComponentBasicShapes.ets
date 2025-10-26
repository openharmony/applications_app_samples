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
struct CanvasComponentBasicShapes {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      // [Start CanvasComponentBasicShapes_start]
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          //绘制矩形
          this.context.beginPath();
          this.context.rect(100, 50, 100, 100);
          this.context.stroke();
          //绘制圆形
          this.context.beginPath();
          this.context.arc(150, 250, 50, 0, 6.28);
          this.context.stroke();
          //绘制椭圆
          this.context.beginPath();
          this.context.ellipse(150, 450, 50, 100, Math.PI * 0.25, Math.PI * 0, Math.PI * 2);
          this.context.stroke();
        })
      // [End CanvasComponentBasicShapes_start]
    }
    .width('100%')
    .height('100%')
  }
}