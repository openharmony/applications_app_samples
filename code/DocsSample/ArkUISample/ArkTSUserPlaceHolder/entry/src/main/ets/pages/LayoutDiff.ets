/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
// [Start place_holder_layout_diff]
import { FrameNode, NodeContent, NodeController, typeNode, UIContext } from '@kit.ArkUI';

class NodeContentCtrl {
  content: NodeContent
  textNode: Array<typeNode.Text> = new Array();
  uiContext: UIContext
  width: number

  constructor(uiContext: UIContext) {
    this.content = new NodeContent();
    this.uiContext = uiContext;
    this.width = Infinity;
  }

  AddNode() {
    let node = typeNode.createNode(this.uiContext, "Text");
    node.initialize("ContentText:" + this.textNode.length).fontSize(20);
    this.textNode.push(node);
    this.content.addFrameNode(node);
  }

  RemoveNode() {
    let node = this.textNode.pop();
    this.content.removeFrameNode(node);
  }

  RemoveFront() {
    let node = this.textNode.shift();
    this.content.removeFrameNode(node);
  }

  GetContent(): NodeContent {
    return this.content;
  }
}

class MyNodeController extends NodeController {
  public rootNode: FrameNode | null = null;
  textNode: Array<typeNode.Text> = new Array();

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    return this.rootNode;
  }

  AddNode(frameNode: FrameNode | null, uiContext: UIContext) {
    let node = typeNode.createNode(uiContext, "Text");
    node.initialize("ControllerText:" + this.textNode.length).fontSize(20);
    this.textNode.push(node);
    frameNode?.appendChild(node);
  }

  RemoveNode(frameNode: FrameNode | null) {
    let node = this.textNode.pop();
    frameNode?.removeChild(node);
  }

  RemoveFront(frameNode: FrameNode | null) {
    let node = this.textNode.shift();
    frameNode?.removeChild(node);
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  controller = new NodeContentCtrl(this.getUIContext());
  myNodeController = new MyNodeController();

  build() {
    Row() {
      Column() {
        ContentSlot(this.controller.GetContent())
        Button("AddToSlot")
          .onClick(() => {
            this.controller.AddNode();
          })
          .margin(10)
        Button("RemoveBack")
          .onClick(() => {
            this.controller.RemoveNode();
          })
          .margin(10)
        Button("RemoveFront")
          .onClick(() => {
            this.controller.RemoveFront();
          })
          .margin(10)
      }
      .width('50%')

      Column() {
        NodeContainer(this.myNodeController)
        Button("AddToNodeContainer")
          .onClick(() => {
            this.myNodeController.AddNode(this.myNodeController.rootNode, this.getUIContext());
          })
          .margin(10)
        Button("RemoveBack")
          .onClick(() => {
            this.myNodeController.RemoveNode(this.myNodeController.rootNode);
          })
          .margin(10)
        Button("RemoveFront")
          .onClick(() => {
            this.myNodeController.RemoveFront(this.myNodeController.rootNode);
          })
          .margin(10)
      }
      .width('50%')
    }
    .height('100%')
  }
}
// [End place_holder_layout_diff]