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

// [Start Create_Node]

import { BuilderNode, FrameNode, NodeContent, NodeController, typeNode } from '@kit.ArkUI';
import entry from 'libentry.so';
import { webview } from '@kit.ArkWeb';

// 定义传递参数的接口
interface ParamsInterface {
  text: string;
  func: Function;
}
class MyNodeController extends NodeController {
  private imperativeNode: FrameNode | null = null;
  public rootNode: typeNode.Column |null = null;
  private buildNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = typeNode.createNode(uiContext, 'Column');

    this.imperativeNode = new FrameNode(uiContext);
    this.rootNode?.appendChild(this.imperativeNode);
    return this.rootNode;
  }

  adoptNode(uiContext:UIContext, message:string):void {
    let buildNode = new BuilderNode<[ParamsInterface]>(uiContext);
    // 创建节点树
    buildNode.build(wrapBuilder<[ParamsInterface]>(buildText), {
      text: message, func: () => {
        return 'FUNCTION';
      }
    }, { nestingBuilderSupported: true });
    this.buildNode = buildNode.getFrameNode();
    entry.adopt(buildNode);
  }
  removeAdoptedNode(uiContext:UIContext):void {
    entry.removeAdopt();
  }
}

@Builder
function buildTextWithFunc(fun: Function) {
  Web({ src: 'www.baidu.com', controller: new webview.WebviewController() })
}

@Builder
function buildText(params: ParamsInterface) {
  Column() {
    buildTextWithFunc(params.func)
  }
}

@Component
struct CAPIComponent {
  private rootSlot = new NodeContent();

  aboutToAppear(): void {
    entry.createRenderNodeGetNodeExample(this.rootSlot, this.getUIContext())
  }

  aboutToDisappear(): void {
    // 页面销毁前释放已创建的Native组件。
    entry.disposeNodeTree(this.rootSlot)
  }

  build() {
    Column() {
      // Native组件挂载点。
      ContentSlot(this.rootSlot)
    }
  }
}

@Entry
@Component
struct Index {
  @State isShow: boolean = false;
  @State isAdopt: boolean = false;
  @State message: string = 'CreateNodeTree';
  @State adoptmsg: string = 'adopt web component';

  private myNodeController: MyNodeController = new MyNodeController();
  build() {
    Flex() {
      Column() {
        Text('create CustomDrawNode，')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Button(this.message)
          .onClick(() => {
            this.isShow = !this.isShow;
          })
        if (this.isShow) {
          CAPIComponent()

          Button(this.adoptmsg)
            .onClick(() => {
              if (this.isAdopt) {
                this.myNodeController.removeAdoptedNode(this.getUIContext());
                this.adoptmsg = 'adopt web component';
              } else {
                this.myNodeController.adoptNode(this.getUIContext(),this.message);
                this.adoptmsg = 'remove adopt web';
              }
              this.isAdopt = !this.isAdopt;
            })

          NodeContainer(this.myNodeController)
        }
      }.width('100%')
    }.width('100%')
  }
}

// [End Create_Node]