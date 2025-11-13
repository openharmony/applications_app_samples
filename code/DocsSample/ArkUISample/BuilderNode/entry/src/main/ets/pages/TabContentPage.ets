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

// [Start Main_TabContentPage]
import { BuilderNode, FrameNode, NodeController } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const INITIAL_VALUE_ZERO = 0;
const INDEX_INCREMENT_STEP = 1;

class Params {
  public message: number = INITIAL_VALUE_ZERO;

  constructor( message: number) {
    this.message = message;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    buildNodeChild({ message: params.message});
  }
}

class TextNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  private textNode: BuilderNode<[Params]> | null = null;
  private message: number = INITIAL_VALUE_ZERO;

  makeNode(context: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(context);
    this.textNode = new BuilderNode(context, { selfIdealSize: { width: 150, height: 150 } });
    this.textNode.build(wrapBuilder<[Params]>(buildText), new Params(this.message));
    this.textNode.inheritFreezeOptions(true); // 设置BuilderNode的冻结继承状态为True。
    if (this.rootNode !== null) {
      this.rootNode.appendChild(this.textNode.getFrameNode()); // 将BuilderNode上树。
    }
    return this.rootNode;
  }

  update(): void {
    if (this.textNode !== null) {
      this.message += 1;
      this.textNode.update(new Params(this.message)); // 更新BuilderNode中的数据，可以触发Log。
    }
  }
}

const textNodeController: TextNodeController = new TextNodeController();

@Entry
@ComponentV2
struct TabContentTest {
  @Local message: number = INITIAL_VALUE_ZERO;
  @Local index:number = INDEX_INCREMENT_STEP;

  build() {
    Row() {
      Column() {
        Button('change message').onClick(() => {
          textNodeController.update();
        })
          .fontSize(25)
          .height(40)

        Tabs() {
          TabContent() {
            Column() {
              FreezeBuildNode({ message: this.message })
              Text('Tabs遍历后BuilderNode处于冻结')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 48, bottom: 48 })
                .fontSize(30)
            }
          }.tabBar(`tab`+`${this.index}`)
          TabContent() {
            Column() {
              FreezeBuildNode({ message: this.message })
            }
          }.tabBar(`tab`+`${this.index+1}`)
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

@ComponentV2({ freezeWhenInactive: true })
struct FreezeBuildNode {
  @Param message: number = INITIAL_VALUE_ZERO;
  @Param index: number = INDEX_INCREMENT_STEP;
  @Monitor('message') onMessageUpdated(mon: IMonitor) {
    hilog.info(0xF811, 'testTag', '%{public}s',`FreezeBuildNode message callback func ${this.message}`);
  }
  build() {
    if (this.index === 0) {
      NodeContainer(textNodeController);
    }
  }
}

@ComponentV2({ freezeWhenInactive: true }) // BuilderNode下面的子组件开启冻结。
struct buildNodeChild {
  @Param message: number = INITIAL_VALUE_ZERO;
  @Param index: number = INDEX_INCREMENT_STEP;

  @Monitor('message') onMessageUpdated(mon: IMonitor) {
    hilog.info(0xF811, 'testTag', '%{public}s',`FreezeBuildNode buildNodeChild message callback func ${this.message}`);
  }

  build() {
    Text('message' + `${this.message}`)
      .fontSize(40)
      .fontWeight(FontWeight.Bold)
  }
}
// [End Main_TabContentPage]