/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { NodeController, FrameNode, RenderNode, DrawContext } from "@ohos.arkui.node";
import { UIContext } from '@ohos.arkui.UIContext';
import bridge from "libentry.so";
import image from '@ohos.multimedia.image';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@kit.BasicServicesKit';

enum drawType {
  none,
  path,
  text,
  image
}


class MyRenderNode extends RenderNode {
  private type: drawType = drawType.none;
  private pMap: image.PixelMap | undefined = undefined;
  draw(context: DrawContext) {
    bridge.nativeOnDraw(666, context, vp2px(this.size.width), vp2px(this.size.height), this.type, this.pMap);
  }

  resetType(t: drawType) {
    this.type = t;
  }

  setPixelMap(p: PixelMap) {
    this.pMap = p;
  }
}

// 创建一个MyRenderNode对象
const newNode = new MyRenderNode();
// 定义newNode的大小和位置
newNode.frame = { x: 0, y: 0, width: 400, height: 600 };

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.appendChild(newNode);
    }
    return this.rootNode;
  }
}


@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController();
  aboutToAppear() {
    const context: Context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    resourceMgr.getRawFileContent('test.jpg').then((fileData: Uint8Array) => {
      console.log("Succeeded in getting RawFileContent");
      const buffer = fileData.buffer.slice(0);
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      imageSource.createPixelMap().then((pMap: image.PixelMap) => {
        newNode.setPixelMap(pMap);
      }).catch((err: BusinessError) => {
        console.error("Failed to creating PixelMap");
      });
    }).catch((err: BusinessError) => {
      console.error("Failed to get RawFileContent");
    });
  }
  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
      }
      .width('100%')
      .height('80%')
      Row() {
        Button("Draw Path")
          .margin({ bottom: 50, right: 12 })
          .onClick(() => {
            newNode.resetType(drawType.path);
            newNode.invalidate();
          })
        Button("Draw Text")
          .margin({ bottom: 50, right: 12 })
          .onClick(() => {
            newNode.resetType(drawType.text);
            newNode.invalidate();
          })
        Button("Draw Image")
          .margin({ bottom: 50, right: 12 })
          .onClick(() => {
            newNode.resetType(drawType.image);
            newNode.invalidate();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}
