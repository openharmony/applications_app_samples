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

// [Start Main_RepeatPage]
import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const INDEX_INITIAL_VALUE = 0;

// 定义一个Params类，用于传递参数。
@ObservedV2
class Params {
  // 单例模式，确保只有一个Params实例。
  public static singleton_: Params;

  // 获取Params实例的方法。
  static instance() {
    if (!Params.singleton_) {
      Params.singleton_ = new Params('');
    }
    return Params.singleton_;
  }

  // 使用@Trace装饰器装饰message、bgColor属性，以便跟踪其变化。
  @Trace public message: string = '';
  @Trace public bgColor: Color = Color.Pink;
  public index: number = INDEX_INITIAL_VALUE;

  constructor( message: string) {
    this.message = message;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    BuildNodeChild({ message: params.message });
  }
}

class TextNodeController extends NodeController {
  private textNode: BuilderNode<[Params]> | null = null;
  private message: string = '';
  // 构造函数接收一个message参数。
  constructor(message: string){
    super();
    this.message = message;
  }
  // 创建并返回一个FrameNode。
  makeNode(context: UIContext): FrameNode | null {
    this.textNode = new BuilderNode(context);
    this.textNode.build(wrapBuilder<[Params]>(buildText), new Params(this.message));
    this.textNode.inheritFreezeOptions(true); // BuilderNode开启冻结。
    return this.textNode.getFrameNode();
  }
}

@Entry
@ComponentV2
export struct RepeatVirtualScrollFreeze {
  @Local simpleList: Array<string> = [];
  storage: Params = Params.instance();

  aboutToAppear(): void {
    for (let i = 0; i < 7; i++) {
      this.simpleList.push(`item${i}`);
    }
  }

  build() {
    Column() {
      Button('Reduce length to 5').width('60%').height(40).fontSize(25)
        .onClick(() => {
          this.simpleList = this.simpleList.slice(0, 5);
        })
        .margin(5)
      Button('Change bgColor').width('60%').height(40).fontSize(25)
        .onClick(() => {
          this.storage.bgColor = this.storage.bgColor == Color.Pink ? Color.Yellow : Color.Pink;
        })

      List() {
        Repeat(this.simpleList)
          .each((obj: RepeatItem<string>) => {
          })
          .virtualScroll({ totalCount: this.simpleList.length })
          .templateId(() => 'a')
          .template('a', (ri) => {
            FreezeBuildNode({
              message: ri.item,
              bgColor: this.storage.bgColor
            })
          }, { cachedCount: 2 })
      }
      .cachedCount(0)
      .margin({top: 12, left: 180 })
    }
    .height('80%')
    .justifyContent(FlexAlign.Center)
    .margin({ top: 5 })
  }
}

// 开启组件冻结。
@ComponentV2({ freezeWhenInactive: true })
struct FreezeBuildNode {
  storage: Params = Params.instance();
  @Param @Require message: string ;
  @Param @Require bgColor: Color;
  @Monitor('storage.bgColor')
  onBgColorChange(monitor: IMonitor) {
    // bgColor改变时，缓存池中组件不刷新，不会打印日志。
    hilog.info(0xF811, 'testTag', '%{public}s',`repeat---bgColor change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }
  build() {
    NodeContainer(new TextNodeController(this.message))
  }
}

@ComponentV2({ freezeWhenInactive: true })
struct BuildNodeChild {
  // 使用Params实例作为storage属性。
  storage: Params = Params.instance();
  @Param message: string = '';

  // 使用@Monitor装饰器监听storage.message的变化。
  @Monitor('storage.bgColor')
  onMessageChange(monitor: IMonitor) {
    hilog.info(0xF811, 'testTag', '%{public}s',`FreezeBuildNode buildNodeChild message callback func ${this.message}`);
  }

  build() {
    Text(`[a]: ${this.message}`)
      .fontSize(25)
      .backgroundColor(this.storage.bgColor)
      .margin(2)
  }
}
// [End Main_RepeatPage]