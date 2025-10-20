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
struct CanvasComponentOtherMethods {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      // [Start canvasComponentOtherMethods_start]
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          //创建一个径向渐变色的CanvasGradient对象
          let grad = this.context.createRadialGradient(200, 200, 50, 200, 200, 200)
          //为CanvasGradient对象设置渐变断点值，包括偏移和颜色
          grad.addColorStop(0.0, '#E87361');
          grad.addColorStop(0.5, '#FFFFF0');
          grad.addColorStop(1.0, '#BDDB69');
          //用CanvasGradient对象填充矩形
          this.context.fillStyle = grad;
          this.context.fillRect(0, 0, 400, 400);
        })
      // [End canvasComponentOtherMethods_start]
    }
    .width('100%')
    .height('100%')
  }
}
