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

import { ComponentCard } from '../../common/Card';
import resource from '../../common/resource';
// [Start styledStringHtml_start]
// xxx.ets
import { image } from '@kit.ImageKit';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
export struct StyledStringHtml {
  imagePixelMap: image.PixelMap | undefined = undefined;
  @State html: string | undefined = undefined;
  @State styledString: StyledString | undefined = undefined;
  controller1: TextController = new TextController;
  controller2: TextController = new TextController;
  private uiContext: UIContext = this.getUIContext();

  async aboutToAppear() {
    console.info('aboutToAppear initial imagePixelMap');
    this.imagePixelMap = await this.getPixmapFromMedia($r('app.media.startIcon'));
  }

  private async getPixmapFromMedia(resource: Resource) {
    let unit8Array = await this.uiContext.getHostContext()?.resourceManager?.getMediaContent(resource.id);
    let imageSource = image.createImageSource(unit8Array?.buffer.slice(0, unit8Array.buffer.byteLength));
    let createPixelMap: image.PixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    });
    await imageSource.release();
    return createPixelMap;
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.StyledStringHtml_title')替换为实际资源文件，在本示例中该资源文件的value值为"格式转换"
        ComponentCard({ title: $r('app.string.StyledStringHtml_title') }) {
          Column() {
            Text(undefined, { controller: this.controller1 }).height(100)
            Row() {
              // 请将$r('app.string.StyledStringHtml_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"添加属性字符串"
              Button($r('app.string.StyledStringHtml_Button_1')).onClick(() => {
                // 请将$r('app.string.StyledStringHtml_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"属性字符串"
                let mutableStyledString1: MutableStyledString =
                  new MutableStyledString(resource.resourceToString($r('app.string.StyledStringHtml_Text_1')), [{
                  start: 0,
                  length: 6,
                  styledKey: StyledStringKey.FONT,
                  styledValue: new TextStyle({ fontColor: Color.Green, fontSize: LengthMetrics.px(50) })
                }]);
                if (this.imagePixelMap !== undefined) {
                  let mutableStyledString2 = new MutableStyledString(new ImageAttachment({
                    value: this.imagePixelMap,
                    size: { width: 50, height: 50 },
                  }));
                  mutableStyledString1.appendStyledString(mutableStyledString2);
                }
                this.styledString = mutableStyledString1;
                this.controller1.setStyledString(mutableStyledString1);
              }).margin(5)
              // 请将$r('app.string.StyledStringHtml_Button_2')替换为实际资源文件，在本示例中该资源文件的value值为"toHtml"
              Button($r('app.string.StyledStringHtml_Button_2')).onClick(() => {
                this.html = StyledString.toHtml(this.styledString);
              }).margin(5)
              // 请将$r('app.string.StyledStringHtml_Button_3')替换为实际资源文件，在本示例中该资源文件的value值为"fromHtml"
              Button($r('app.string.StyledStringHtml_Button_3')).onClick(async () => {
                let styledString = await StyledString.fromHtml(this.html);
                this.controller2.setStyledString(styledString);
              }).margin(5)
            }

            Text(undefined, { controller: this.controller2 }).height(100)
            Text(this.html)
          }.width('100%')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.StyledStringHtml_title')替换为实际资源文件，在本示例中该资源文件的value值为"格式转换"
    .title($r('app.string.StyledStringHtml_title'))
  }
}
// [End styledStringHtml_start]