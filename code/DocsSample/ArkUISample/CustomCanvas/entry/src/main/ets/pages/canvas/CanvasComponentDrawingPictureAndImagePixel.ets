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
// [Start CanvasComponentDrawingPictureAndImagePixel_start]
@Entry
@Component
struct CanvasComponentDrawingPictureAndImagePixel {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private offCanvas: OffscreenCanvas = new OffscreenCanvas(600, 600);
  // "/common/images/1234.png"需要替换为开发者所需的图像资源文件
  private img: ImageBitmap = new ImageBitmap("/common/images/1234.png");  //找别的图片代替

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          let offContext = this.offCanvas.getContext("2d", this.settings)
          // 使用drawImage接口将图片画在（0，0）为起点，宽高130的区域
          offContext.drawImage(this.img, 0, 0, 130, 130);
          // 使用getImageData接口，获得canvas组件区域中，（50，50）为起点，宽高130范围内的绘制内容
          let imageData = offContext.getImageData(50, 50, 130, 130);
          // 使用putImageData接口将得到的ImageData画在起点为（150， 150）的区域中
          offContext.putImageData(imageData, 150, 150);
          // 将离屏绘制的内容画到canvas组件上
          let image = this.offCanvas.transferToImageBitmap();
          this.context.transferFromImageBitmap(image);
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End CanvasComponentDrawingPictureAndImagePixel_start]