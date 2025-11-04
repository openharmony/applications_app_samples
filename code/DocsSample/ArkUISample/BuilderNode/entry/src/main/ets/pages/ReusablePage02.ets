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
// [Start Main_ReusablePage02]
import { FrameNode, NodeController, BuilderNode, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TEST_TAG: string = 'Reusable';

class Params {
  public item: string = '';

  constructor(item: string) {
    this.item = item;
  }
}

@Builder
function buildNode(param: Params = new Params('Hello')) {
  ChildComponent2({ item: param.item })
}

class MyNodeController extends NodeController {
  public builderNode: BuilderNode<[Params]> | null = null;
  public item: string = '';

  constructor(item: string) {
    super();
    this.item = item;
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.builderNode == null) {
      this.builderNode = new BuilderNode(uiContext, { selfIdealSize: { width: 300, height: 200 } });
      this.builderNode.build(wrapBuilder<[Params]>(buildNode), new Params(this.item));
    }
    return this.builderNode.getFrameNode();
  }
}

// 标记了@Reusable的自定义组件，无法直接被BuilderNode挂载为子节点
@Reusable
@Component
struct ReusableChildComponent {
  @Prop item: string = '';

  aboutToReuse(params: object): void {
    hilog.info(0xF811,'testTag','%{public}s',`${TEST_TAG} ReusableChildComponent aboutToReuse ${JSON.stringify(params)}`);
  }

  aboutToRecycle(): void {
    hilog.info(0xF811,'testTag','%{public}s',`${TEST_TAG} ReusableChildComponent aboutToRecycle ${this.item}`);
  }

  build() {
    Text(`A--${this.item}`)
      .id('ReusablePage02')
  }
}

// 未标记@Reusable的自定义组件
@Component
struct ChildComponent2 {
  @Prop item: string = '';

  aboutToReuse(params: Record<string, object>) {
    hilog.info(0xF811,'testTag','%{public}s',`${TEST_TAG} ChildComponent2 aboutToReuse ${JSON.stringify(params)}`);
  }

  aboutToRecycle(): void {
    hilog.info(0xF811,'testTag','%{public}s',`${TEST_TAG} ChildComponent2 aboutToRecycle ${this.item}`);
  }

  build() {
    ReusableChildComponent({ item: this.item })
  }
}


@Entry
@Component
struct Index {
  @State controller: MyNodeController = new MyNodeController('Child');

  build() {
    Column() {
      NodeContainer(this.controller)
    }
    .width('100%')
    .height('100%')
  }
}
// [End Main_ReusablePage02]