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
// [Start provide_consume_Builder_Node]
import { NodeController, BuilderNode, FrameNode, UIContext } from '@kit.ArkUI';

@Builder
function buildText() {
  Column() {
    Child()
  }
}

class TextNodeController extends NodeController {
  private builderNode: BuilderNode<[]> | null = null;

  constructor() {
    super();
  }

  makeNode(context: UIContext): FrameNode | null {
    this.builderNode = new BuilderNode(context);
    // 配置跨BuilderNode支持@Provide/@Consume
    this.builderNode.build(wrapBuilder(buildText), undefined,
      { enableProvideConsumeCrossing: true });
    // 将BuilderNode的根节点挂载到NodeContainer
    return this.builderNode.getFrameNode();
  }
}

@Entry
@Component
struct Index {
  @Provide message: string = 'hello';
  controller: TextNodeController = new TextNodeController();

  build() {
    Column() {
      NodeContainer(this.controller)
        .width('100%')
        .height(100)
    }
    .width('100%')
    .height('100%')
  }
}


@Component
struct Child {
  // Child通过BuilderNode上树后，@Consume和Index中的@Provide建立连接时发现类型不一致，抛出运行时错误
  @Consume message: string = '';

  build() {
    Column() {
      Text(`@Consume ${this.message}`)
    }
  }
}
// [End provide_consume_Builder_Node]

@Component
export struct ProvideConsumeBuilderNode {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title('')
  }
}