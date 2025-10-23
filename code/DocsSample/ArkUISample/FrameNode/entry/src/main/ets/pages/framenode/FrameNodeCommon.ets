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

//[Start frameNodeCommon_start]
import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit';

class Params {
  public text: string = 'this is a text'
}

@Builder
function buttonBuilder(params: Params) {
  Button(params.text)
    .fontSize(12)
    .borderRadius(8)
    .borderWidth(2)
    .backgroundColor(Color.Orange)
    .onClick((event: ClickEvent) => {
      hilog.info(0x0000, `Button ${JSON.stringify(event)}`, 'isClicked');
    })
}

class MyNodeController extends NodeController {
  public buttonNode: BuilderNode<[Params]> | null = null;
  public frameNode: FrameNode | null = null;
  public rootNode: FrameNode | null = null;
  private wrapBuilder: WrappedBuilder<[Params]> = wrapBuilder(buttonBuilder);

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode == null) {
      this.rootNode = new FrameNode(uiContext);
      // 对rootNode进行属性修改，该节点为自定义的FrameNode节点，修改生效
      this.rootNode.commonAttribute
        .width('100%')
        .height(100)
        .borderWidth(1)
        .backgroundColor(Color.Gray)
    }

    if (this.frameNode == null) {
      this.frameNode = new FrameNode(uiContext);
      // 对frameNode进行属性修改，该节点为自定义的FrameNode节点，修改生效
      this.frameNode.commonAttribute
        .width('50%')
        .height(50)
        .borderWidth(1)
        .backgroundColor(Color.Pink);
      this.rootNode.appendChild(this.frameNode);
    }
    if (this.buttonNode == null) {
      this.buttonNode = new BuilderNode<[Params]>(uiContext);
      this.buttonNode.build(this.wrapBuilder, { text: 'This is a Button' })
      // 对BuilderNode中获取的FrameNode进行属性修改，该节点非自定义的FrameNode节点，修改不生效
      this.buttonNode?.getFrameNode()?.commonAttribute.position({ x: 100, y: 100 })
      this.rootNode.appendChild(this.buttonNode.getFrameNode())
    }
    return this.rootNode;
  }

  modifyNode(frameNode: FrameNode | null | undefined, sizeValue: SizeOptions, positionValue: Position) {
    if (frameNode) {
      frameNode.commonAttribute.size(sizeValue).position(positionValue);
    }
  }

  addClickEvent(frameNode: FrameNode | null | undefined) {
    if (frameNode) {
      frameNode.commonEvent.setOnClick((event: ClickEvent) => {
        console.info(`FrameNode ${JSON.stringify(event)}`);
      })
    }
  }
}

@Entry
@Component
struct Index {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Column({ space: 10 }) {
        // $r('app.media.Modify_Node_Common_Properties_Width_And_Height')需要替换为开发者所需的文本资源文件
        Text($r('app.string.Modify_Node_Common_Properties_Width_And_Height'))
        Button('modify ArkTS-FrameNode')
          .onClick(() => {
            // 获取到的是当前页面中的开发者创建的FrameNode对象，该节点可修改。即节点大小与位置。
            hilog.info(0x0000, `Check the weather the node can be modified ${this.myNodeController?.frameNode
            ?.isModifiable()}`, 'isClicked');
            this.myNodeController.modifyNode(this.myNodeController?.frameNode, { width: 150, height: 100 }, {
              x: 100,
              y: 0
            })
          })
        Button('modify FrameNode get by BuilderNode')
          .onClick(() => {
            // 获取到的是当前页面中的BuilderNode的根节点，该节点不可修改。即节点大小与位置未发生改变。
            hilog.info(0x0000, `Check the weather the node can be modified
            ${this.myNodeController?.buttonNode?.getFrameNode()
            ?.isModifiable()}`, 'isClicked');
            this.myNodeController.modifyNode(this.myNodeController?.buttonNode?.getFrameNode(), {
              width: 100,
              height: 100
            }, { x: 50, y: 50 })
          })
        Button('modify proxyFrameNode get by search')
          .onClick(() => {
            // rootNode调用getParent()获取到的是当前页面中的NodeContainer节点，该节点不可修改。即节点大小与位置未发生改变。
            hilog.info(0x0000,
              `Check the weather the node can be modified ${this.myNodeController?.rootNode?.getParent()
              ?.isModifiable()}`, 'isClicked');
            this.myNodeController.modifyNode(this.myNodeController?.rootNode?.getParent(), {
              width: 500,
              height: 500
            }, {
              x: 0,
              y: 0
            })
          })
      }
      .padding({
        left: 35,
        right: 35,
        top: 35,
        bottom: 35
      })

      Column({ space: 10 }) {
        // $r('app.media.Modify_Node_Click_Event')需要替换为开发者所需的文本资源文件
        Text($r('app.string.Modify_Node_Click_Event'))
        Button('add click event to ArkTS-FrameNode')
          .onClick(() => {
            // 获取到的是当前页面中的开发者创建的FrameNode对象，该节点可增加点击事件。
            // 增加的点击事件参与事件竞争，即点击事件会在该节点被消费且不不再向父组件冒泡。
            hilog.info(0x0000,
              `Check the weather the node can be modified ${this.myNodeController?.rootNode?.getParent()
              ?.isModifiable()}`, 'isClicked');
            this.myNodeController.addClickEvent(this.myNodeController?.frameNode)
          })
        Button('add click event to FrameNode get by BuilderNode')
          .onClick(() => {
            // 获取到的是当前页面中的BuilderNode的根节点，该类节点可增加点击事件。
            // 点击的时候优先回调通过系统组件接口设置的click事件回调，然后回调通过commonEvent增加的click监听。
            hilog.info(0x0000, `Check the weather the node can be modified
            ${this.myNodeController?.buttonNode?.getFrameNode()
            ?.isModifiable()}`, 'isClicked');
            this.myNodeController.addClickEvent(this.myNodeController?.buttonNode?.getFrameNode())
          })
        Button('add click event to proxyFrameNode get by search')
          .onClick(() => {
            // rootNode调用getParent()获取到的是当前页面中的NodeContainer节点，该类节点可增加点击事件。
            hilog.info(0x0000,
              `Check the weather the node can be modified ${this.myNodeController?.rootNode?.getParent()
              ?.isModifiable()}`, 'isClicked');
            this.myNodeController.addClickEvent(this.myNodeController?.rootNode?.getParent());
          })
      }
      .padding({
        left: 35,
        right: 35,
        top: 35,
        bottom: 35
      })

      NodeContainer(this.myNodeController)
        .borderWidth(1)
        .width('100%')
        .height(100)
        .onClick((event: ClickEvent) => {
          hilog.info(0x0000, `NodeContainer ${JSON.stringify(event)}`, 'isClicked');
        })
    }
    .padding({
      left: 35,
      right: 35,
      top: 35,
      bottom: 35
    })
    .width('100%')
    .height('100%')
  }
}

//[End frameNodeCommon_start]