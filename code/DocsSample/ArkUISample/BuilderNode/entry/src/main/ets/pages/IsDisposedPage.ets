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
// [Start Main_IsDisposedPage]
import { NodeController, FrameNode, BuilderNode } from '@kit.ArkUI';

@Builder
function buildText() {
  Text('Test')
    .fontSize(20)
    .fontWeight(FontWeight.Bold)
}

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  private builderNode: BuilderNode<[]> | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(uiContext);
    this.rootNode.commonAttribute.width(100)
      .height(100)
      .backgroundColor(Color.Pink);
    this.builderNode = new BuilderNode<[]>(uiContext);
    this.builderNode.build(wrapBuilder<[]>(buildText));

    // 挂载BuilderNode
    this.rootNode.appendChild(this.builderNode.getFrameNode());
    return this.rootNode;
  }

  disposeBuilderNode() {
    // 解除BuilderNode与后端实体节点的引用关系
    this.builderNode?.dispose();
  }

  isDisposed(): string {
    if (this.builderNode !== null) {
      // 查询BuilderNode是否解除引用
      if (this.builderNode.isDisposed()) {
        return 'builderNode isDisposed is true';
      } else {
        return 'builderNode isDisposed is false';
      }
    }
    return 'builderNode is null';
  }
}

@Entry
@Component
struct Index {
  @State text: string = '';
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Column({ space: 4 }) {
      NodeContainer(this.myNodeController)
      Button('BuilderNode dispose')
        .onClick(() => {
          this.myNodeController.disposeBuilderNode();
          this.text = '';
        })
        .width(200)
        .height(50)
      Button('BuilderNode isDisposed')
        .onClick(() => {
          this.text = this.myNodeController.isDisposed();
        })
        .width(200)
        .height(50)
      Text(this.text)
        .fontSize(25)
    }
    .width('100%')
    .height('100%')
  }
}
// [End Main_IsDisposedPage]