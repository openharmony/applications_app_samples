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

// [Start operation_node_tree]
import { FrameNode, NodeController, RenderNode } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

const TEST_TAG: string = 'RenderNode';
const renderNode = new RenderNode();
renderNode.frame = {
  x: 0,
  y: 0,
  width: 200,
  height: 350
};
renderNode.backgroundColor = 0xffff0000;
for (let i = 0; i < 5; i++) {
  const node = new RenderNode();
  // 设置node节点的Frame大小
  node.frame = {
    x: 10,
    y: 10 + 60 * i,
    width: 50,
    height: 50
  };
  // 设置node节点的背景颜色
  node.backgroundColor = 0xff00ff00;
  // 将新增节点挂载在renderNode上
  renderNode.appendChild(node);
}

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(uiContext);

    const rootRenderNode = this.rootNode?.getRenderNode();
    if (rootRenderNode) {
      rootRenderNode.appendChild(renderNode);
    }
    return this.rootNode;
  }
}

@Entry
@Component
export struct OperationNodeTree {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    // [StartExclude operation_node_tree]
    NavDestination() {
      // [EndExclude operation_node_tree]
      Row() {
        NodeContainer(this.myNodeController)
          .width(200)
          .height(350);
        Button('getNextSibling')
          .onClick(() => {
            const child = renderNode.getChild(1);
            const nextSibling = child!.getNextSibling()
            if (child === null || nextSibling === null) {
              hilog.info(DOMAIN, TEST_TAG, ' the child or nextChild is null');
            } else {
              // 获取子节点的位置信息
              hilog.info(DOMAIN, TEST_TAG, `the position of child is x: ${child.position.x}, y: ${child.position.y}, ` +
                `the position of nextSibling is x: ${nextSibling.position.x}, y: ${nextSibling.position.y}`);
            }
          });
      };

      // [StartExclude operation_node_tree]
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.OperationNodeTree')需要替换为开发者所需的字符串资源文件
    .title($r('app.string.OperationNodeTree'));

    // [EndExclude operation_node_tree]
  }
}

// [End operation_node_tree]