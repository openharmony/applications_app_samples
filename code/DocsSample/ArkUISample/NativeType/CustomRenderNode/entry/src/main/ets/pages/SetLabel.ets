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

// [Start set_label]
import { RenderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(uiContext);
    const renderNode: RenderNode | null = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      const renderChildNode: RenderNode = new RenderNode();
      renderChildNode.frame = {
        x: 0,
        y: 0,
        width: 100,
        height: 100
      };
      renderChildNode.backgroundColor = 0xffff0000;
      renderChildNode.label = 'customRenderChildNode';
      hilog.info(DOMAIN, 'label:', renderChildNode.label);
      renderNode.appendChild(renderChildNode);
    }

    return this.rootNode;
  }
}

@Entry
@Component
export struct SetLabel {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    // [StartExclude set_label]
    NavDestination() {
      // [EndExclude set_label]
      Column() {
        NodeContainer(this.myNodeController)
          .width(300)
          .height(700)
          .backgroundColor(Color.Gray);
      };

      // [StartExclude set_label]
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.SetLabel')需要替换为开发者所需的字符串资源文件
    .title($r('app.string.SetLabel'));

    // [EndExclude set_label]
  }
}

// [End set_label]