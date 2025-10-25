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
// [Start drawingRegularBaseShape_start]
@Entry
@Component
struct ClearRect {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          // 设定填充样式，填充颜色设为蓝色
          this.context.fillStyle = '#0097D4';
          // 以(50, 50)为左上顶点，画一个宽高200的矩形
          this.context.fillRect(50, 50, 200, 200);
          // 以(70, 70)为左上顶点，清除宽150高100的区域
          this.context.clearRect(70, 70, 150, 100);
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End drawingRegularBaseShape_start]