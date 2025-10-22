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
// [Start canvasComponentTextBorder_start]
// xxx.ets
@Entry
@Component
struct CanvasComponentTextBorder {
  drawText: string = 'Hello World'
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          // 文本的水平对齐方式为'top'
          this.context.textBaseline = 'top';
          // 文本字号为30px，字体系列为monospace
          this.context.font = '30px monospace';
          let textWidth = this.context.measureText(this.drawText).width;
          let textHeight = this.context.measureText(this.drawText).height;
          this.context.fillText(this.drawText, 20, 100);
          this.context.strokeRect(20, 100, textWidth, textHeight);
          // 文本字体粗细为粗体，字号为60px，字体系列为sans-serif
          this.context.font = 'bold 60px sans-serif';
          textWidth = this.context.measureText(this.drawText).width;
          textHeight = this.context.measureText(this.drawText).height;
          this.context.fillText(this.drawText, 20, 150);
          this.context.strokeRect(20, 150, textWidth, textHeight);
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End canvasComponentTextBorder_start]