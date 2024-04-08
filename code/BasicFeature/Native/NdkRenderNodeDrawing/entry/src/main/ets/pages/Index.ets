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

enum drawType {
  none,
  path,
  rect,
  text
}

class MyRenderNode extends RenderNode {
  private type: drawType = drawType.none

  draw(context: DrawContext) {
    bridge.nativeOnDraw(666, context, vp2px(this.size.width), vp2px(this.size.height), this.type)
  }

  resetType(t: drawType) {
    this.type = t
  }
}

// 创建一个MyRenderNode对象
const newNode = new MyRenderNode()
// 定义newNode的大小和位置
newNode.frame = { x: 0, y: 0, width: 750, height: 800 }

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext)
    if (this.rootNode === null) {
      return this.rootNode
    }
    const renderNode = this.rootNode.getRenderNode()
    if (renderNode !== null) {
      renderNode.frame = { x: 0, y: 0, width: 10, height: 500 }
      renderNode.pivot = { x: 50, y: 50 }
      renderNode.appendChild(newNode)
    }
    return this.rootNode
  }

  addNode(node: RenderNode): void {
    if (this.rootNode === null) {
      return
    }
    const renderNode = this.rootNode.getRenderNode()
    if (renderNode !== null) {
      renderNode.appendChild(node)
    }
  }
}


@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController()
  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
        Button("Draw Path")
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            newNode.resetType(drawType.path)
            newNode.invalidate()
          })
        Button("Draw Rect")
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            newNode.resetType(drawType.rect)
            newNode.invalidate()
          })
        Button("Draw Text")
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            newNode.resetType(drawType.text)
            newNode.invalidate()
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
