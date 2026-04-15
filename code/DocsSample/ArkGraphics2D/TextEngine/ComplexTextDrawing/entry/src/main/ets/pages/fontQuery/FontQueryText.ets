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

import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { text } from '@kit.ArkGraphics2D'
import { BusinessError } from '@kit.BasicServicesKit'

class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    let canvas = context.canvas;
    // [Start arkts_font_query_step1]
    // 按类型获取字体路径列表
    let fontPaths: Array<string> = text.getFontPathsByType(text.SystemFontType.GENERIC);
    for (let i = 0; i < fontPaths.length; i++) {
      console.info("MetricsMSG: fontPath[" + i + "]: " + fontPaths[i]);
    }
    // [End arkts_font_query_step1]
    // [Start arkts_font_query_step2]
    // 异步获取系统字体全名列表
    text.getSystemFontFullNamesByType(text.SystemFontType.GENERIC).then((names: Array<string>) => {
      for (let i = 0; i < names.length; i++) {
        console.info("MetricsMSG: fontName[" + i + "]: " + names[i]);
      }
    }).catch((err: BusinessError) => {
      console.error(`Failed to get font names. Code: ${err.code}, message: ${err.message}`);
    });
    // [End arkts_font_query_step2]
    // [Start arkts_font_query_step3]
    // 异步从字体文件获取描述符
    if (fontPaths.length > 0) {
      text.getFontDescriptorsFromPath(fontPaths[0]).then((descriptors: Array<text.FontDescriptor>) => {
        for (let i = 0; i < descriptors.length; i++) {
          let desc = descriptors[i];
          console.info("MetricsMSG: descriptor fullName: " + desc.fullName +
            ", family: " + desc.fontFamily + ", weight: " + desc.weight);
        }
      }).catch((err: BusinessError) => {
        console.error(`Failed to get font descriptors. Code: ${err.code}, message: ${err.message}`);
      });
    }
    // [End arkts_font_query_step3]
  }
}

const textNode = new MyRenderNode();
textNode.frame = { x: 0, y: 0, width: 400, height: 600 };
textNode.pivot = { x: 0.2, y: 0.8 };
textNode.scale = { x: 1, y: 1 };

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode == null) { return this.rootNode; }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) { renderNode.frame = { x: 0, y: 0, width: 10, height: 500 }; }
    return this.rootNode;
  }
  addNode(node: RenderNode): void {
    if (this.rootNode == null) { return; }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) { renderNode.appendChild(node); }
  }
  clearNodes(): void {
    if (this.rootNode == null) { return; }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) { renderNode.clearChildren(); }
  }
}

let myNodeController: MyNodeController = new MyNodeController();
async function performTask() { myNodeController.clearNodes(); myNodeController.addNode(textNode); }

@Entry
@Component
struct FontQueryText {
  @State src: Resource = $r('app.media.startIcon');
  build() {
    Column() {
      Row() {
        NodeContainer(myNodeController).height('100%').width('100%')
        Image(this.src).width('0%').height('0%').onComplete(() => { performTask(); })
      }.width('100%')
    }
  }
}
