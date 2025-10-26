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
// [Start Main_BuilderProxyNode02]
import { BuilderNode, typeNode, NodeController, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
struct BlueRowComponent {
  build() {
    Row() {
      Row() {
      }
      .width('100%')
      .height('200vp')
      .backgroundColor(0xFF2787D9)
      .onTouch((event: TouchEvent) => {
        // 触摸绿色Column，蓝色Row的触摸事件触发
        hilog.info(0xF811, 'testTag', '%{public}s','blue touched: ' + event.type);
      })
    }
  }
}

@Component
struct GreenColumnComponent {
  build() {
    Column() {
    }
    .id('BuilderProxyNode02')
    .width('100%')
    .height('100vp')
    .backgroundColor(0xFF17A98D)
    .hitTestBehavior(HitTestMode.Transparent)
    .onTouch((event: TouchEvent) => {
      hilog.info(0xF811, 'testTag', '%{public}s','green touched: ' + event.type);
    })
  }
}

@Builder
function buildBlueRow() {
  // Builder直接挂载自定义组件，生成BuilderProxyNode
  BlueRowComponent()
}

@Builder
function buildGreenColumn() {
  // Builder根节点为容器组件，不会生成BuilderProxyNode，可以设置属性
  Stack() {
    GreenColumnComponent()
  }
  .hitTestBehavior(HitTestMode.Transparent)
}

class MyNodeController extends NodeController {
  makeNode(uiContext: UIContext): FrameNode | null {
    const relativeContainer = typeNode.createNode(uiContext, 'RelativeContainer');

    const blueRowNode = new BuilderNode(uiContext);
    blueRowNode.build(wrapBuilder(buildBlueRow));

    const greenColumnNode = new BuilderNode(uiContext);
    greenColumnNode.build(wrapBuilder(buildGreenColumn));

    // greenColumnNode覆盖在blueRowNode上
    relativeContainer.appendChild(blueRowNode.getFrameNode());
    relativeContainer.appendChild(greenColumnNode.getFrameNode());

    return relativeContainer;
  }
}

@Entry
@Component
struct BuilderProxyNode02 {
  build() {
    Column() {
      NodeContainer(new MyNodeController())
    }
  }
}
// [End Main_BuilderProxyNode02]