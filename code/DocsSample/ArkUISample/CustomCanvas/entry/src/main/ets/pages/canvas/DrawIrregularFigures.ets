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
// [Start drawIrregularFigures_start]
@Entry
@Component
struct Path2d {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Row() {
      Column() {
        Canvas(this.context)
          .width('100%')
          .height('100%')
          .backgroundColor('#F5DC62')
          .onReady(() => {
            // 使用Path2D的接口构造一个五边形
            let path = new Path2D();
            path.moveTo(150, 50);
            path.lineTo(50, 150);
            path.lineTo(100, 250);
            path.lineTo(200, 250);
            path.lineTo(250, 150);
            path.closePath();
            // 设定填充色为蓝色
            this.context.fillStyle = '#0097D4';
            // 使用填充的方式，将Path2D描述的五边形绘制在canvas组件内部
            this.context.fill(path);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End drawIrregularFigures_start]