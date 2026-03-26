/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { FrameNode, NodeController, typeNode, UIContext } from '@kit.ArkUI';
import testNapi from 'libentry.so';

class MyNodeController extends NodeController {
  public xComponent: typeNode.XComponent | undefined = undefined;
  public xComponentId: string = 'xcp' + (new Date().getTime());
  public node: FrameNode | undefined = undefined;
  public column: typeNode.Column | undefined = undefined;
  public attachButton: typeNode.Button | undefined = undefined;
  public detachButton: typeNode.Button | undefined = undefined;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.node = new FrameNode(uiContext);
    this.column = typeNode.createNode(uiContext, 'Column')
    this.column.initialize()
      .width('100%')
      .height('100%')
    try {
      this.node.appendChild(this.column);
    } catch (error) {
      console.error('Fail to append child: ', error);
    }

    this.xComponent = typeNode.createNode(uiContext, 'XComponent', { type: XComponentType.SURFACE });
    this.xComponent.attribute
      .id(this.xComponentId)
      .focusable(true)
      .focusOnTouch(true)
    testNapi.bindNode(this.xComponentId, this.xComponent); // 将XComponent节点传入native侧
    try {
      this.column.appendChild(this.xComponent);
    } catch (error) {
      console.error('Fail to append child: ', error);
    }

    return this.node;
  }

  aboutToDisappear(): void {
    testNapi.unbindNode(this.xComponentId);
    try {
      this.node?.removeChild(this.xComponent);
    } catch (error) {
      console.error('Fail to remove child: ', error);
    }
    this.xComponent?.dispose();
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'XComponent Dispose Test';
  @State isShow: boolean = true;
  myNodeController: MyNodeController = new MyNodeController();

  build() {
    Column({ space: 20 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50 })

      Button('create/destroy XComponent')
        .width('80%')
        .height(50)
        .onClick(() => {
          this.isShow = !this.isShow;
        })
      if (this.isShow) {
        NodeContainer(this.myNodeController)
          .width(200)
          .height(200)
          .focusable(true)
          .focusOnTouch(true)
          .defaultFocus(true)
      }
    }
    .width('100%')
    .height('100%')
  }
}
