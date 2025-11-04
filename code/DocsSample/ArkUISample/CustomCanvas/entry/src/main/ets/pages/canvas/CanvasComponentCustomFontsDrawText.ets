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
// [Start canvasComponentCustomFontsDrawText_start]
import { text } from '@kit.ArkGraphics2D';

@Entry
@Component
struct CustomFont {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          //加载自定义字体
          let fontCollection = text.FontCollection.getGlobalInstance();
          fontCollection.loadFontSync('customFont', $rawfile('customFont.ttf'));
          this.context.font = '30vp customFont';
          this.context.fillText('Hello World!', 20, 50);
          this.context.strokeText('Hello World!', 20, 100);
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End canvasComponentCustomFontsDrawText_start]
