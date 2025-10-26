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
// [Start provide_consume_Two_Way]
import { NodeController, BuilderNode, FrameNode, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Builder
function buildText() {
  Column() {
    Child()
  }
}

class TextNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  private uiContext: UIContext | null = null;
  private builderNode: BuilderNode<[]> | null = null;

  constructor() {
    super();
  }

  makeNode(context: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(context);
    this.uiContext = context;
    // 将rootNode节点挂载在NodeContainer下
    return this.rootNode;
  }

  addBuilderNode(): void {
    if (this.builderNode === null && this.uiContext && this.rootNode) {
      this.builderNode = new BuilderNode(this.uiContext);
      // 配置跨BuilderNode支持@Provide/@Consume
      this.builderNode.build(wrapBuilder(buildText), undefined,
        { enableProvideConsumeCrossing: true });
      // 将BuilderNode的根节点挂载到rootNode节点下
      this.rootNode.appendChild(this.builderNode.getFrameNode());
    }
  }

  removeBuilderNode(): void {
    if (this.rootNode && this.builderNode) {
      // 从rootNode节点下的BuildNode节点移除
      this.rootNode.removeChild(this.builderNode.getFrameNode());
    }
  }

  disposeNode(): void {
    if (this.rootNode && this.builderNode) {
      // 立即释放当前BuilderNode
      this.builderNode.dispose();
    }
  }
}

@Entry
@Component
struct Index {
  @Provide @Watch('onChange') message: string = 'hello';
  controller: TextNodeController = new TextNodeController();

  onChange() {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `Index Provide change ${this.message}`);
  }

  build() {
    Column() {
      Text(`@Provide: ${this.message}`)
        .fontSize(20)
        .onClick(() => {
          this.message += ' Provide';
        })

      // 执行BuilderNode的build方法，构造Child自定义组件
      // 并将BuilderNode挂载在NodeContainer下
      // Child中@Consume可以和当前Index中的@Provide配对
      // @Consume装饰的变量message从default value变为hello，并回调@Consume的@Watch方法
      Button('add Child')
        .onClick(() => {
          this.controller.addBuilderNode();
        })
      // 将BuilderNode下的节点从NodeContainer上移除
      // @Consume修饰的变量message从和@Provide配对的值变为default value，并回调@Consume的@Watch方法
      Button('remove Child')
        .onClick(() => {
          this.controller.removeBuilderNode();
        })

      // 立即释放当前BuilderNode，BuilderNode下节点销毁，Child组件执行aboutToDisappear
      Button('dispose Child')
        .onClick(() => {
          this.controller.disposeNode();
        })
      NodeContainer(this.controller)
        .width('100%')
        .height(100)
        .backgroundColor(Color.Pink)
    }
    .width('100%')
    .height('100%')
  }
}


@Component
struct Child {
  @Consume @Watch('onChange') message: string = 'default value';

  onChange() {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `Child Consume change ${this.message}`);
  }

  aboutToDisappear(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `Child aboutToDisappear`);
  }

  build() {
    Column() {
      Text(`@Consume ${this.message}`)
        .fontSize(20)
        .onClick(() => {
          this.message += ' Consume';
        })
    }
  }
}
// [End provide_consume_Two_Way]

@Component
export struct ProvideConsumeTwoWay {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.provide_consume_two_way'))
  }
}