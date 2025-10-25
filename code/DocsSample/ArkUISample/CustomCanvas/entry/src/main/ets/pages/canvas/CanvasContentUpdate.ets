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
// [Start canvasContentUpdate_start]
@Entry
@Component
struct CanvasContentUpdate {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  @State @Watch('draw')content: string = 'Hello World';

  draw() {
    this.context.clearRect(0, 0, 400, 200); // 清空Canvas的内容
    this.context.fillText(this.content, 50, 100); // 重新绘制
  }

  build() {
    Column() {
      Canvas(this.context)
        .width('100%')
        .height('25%')
        .backgroundColor('rgb(39, 135, 217)')
        .onReady(() => {
          this.context.font = '65px sans-serif';
          this.context.fillText(this.content, 50, 100);
        })
      TextInput({
        text:$$this.content // 修改文本输入框里的内容时，状态变量的更新会驱动Canvas刷新
      })
        .fontSize(35)
    }
    .width('100%')
    .height('100%')
  }
}
// [End canvasContentUpdate_start]