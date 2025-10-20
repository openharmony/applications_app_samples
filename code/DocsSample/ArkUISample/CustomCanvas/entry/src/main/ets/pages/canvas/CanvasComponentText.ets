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
struct CanvasComponentText {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      // [Start canvasComponentText_start]
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          // 文本填充
          this.context.font = '50px bolder sans-serif';
          this.context.fillText('Hello World!', 50, 100);
          // 文本描边
          this.context.strokeStyle = "#ff0000"
          this.context.lineWidth = 2
          this.context.font = '50px bolder sans-serif';
          this.context.strokeText('Hello World!', 50, 150);
        })
      // [End canvasComponentText_start]
    }
    .width('100%')
    .height('100%')
  }
}