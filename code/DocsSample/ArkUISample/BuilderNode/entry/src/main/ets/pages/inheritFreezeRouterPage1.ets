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

// [Start Main_inheritFreezeRouterPage1]
import { BuilderNode, FrameNode, NodeController } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const BOOK_INITIAL_NAME = '100';

@ObservedV2
export class Book {
  @Trace public name: string = BOOK_INITIAL_NAME;
  constructor(name: string) {
    this.name = name;
  }
}

@Builder
function buildText(book: Book) {
  Column() {
    BuildNodeChild()
  }
}

class TextNodeController extends NodeController {
  public rootNode: FrameNode | null = null;
  public textNode: BuilderNode<[Book]> | null = null;
  public index: number = 0;
  public name: string = BOOK_INITIAL_NAME;

  makeNode(context: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(context);
    this.textNode = new BuilderNode(context, { selfIdealSize: { width: 150, height: 150 } });
    this.textNode.build(wrapBuilder<[Book]>(buildText), new  Book (this.name));
    this.textNode.inheritFreezeOptions(true); // 设置BuilderNode的冻结继承状态为true。
    if (this.rootNode !== null) {
      this.rootNode.appendChild(this.textNode.getFrameNode()); // 将BuilderNode上树。
    }
    return this.rootNode;
  }
}

const textNodeController: TextNodeController = new TextNodeController();

@Entry
@ComponentV2({ freezeWhenInactive: true })
export struct Index3 {
  build() {
    Column() {
      NodeContainer(textNodeController)
    }
  }
}

@ComponentV2({ freezeWhenInactive: true })
struct BuildNodeChild {
  @Local bookTest: Book = new Book('A Midsummer Night’s Dream');

  @Monitor('bookTest.name')
  onMessageChange(monitor: IMonitor) {
    hilog.info(0xF811, 'testTag', '%{public}s',`The book name change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  build() {
    Column() {
      Text(`Book name is  ${this.bookTest.name}`).fontSize(30)
      Button('change').width('60%').height(40).fontSize(30)
        .onClick(() => {
          this.bookTest.name = 'The Old Man and the Sea';
        })
        .margin(5)
      Button('next').width('60%').height(40).fontSize(30)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/inheritFreezeRouterPage2' });
          setTimeout(() => {
            this.bookTest = new Book(`Jane Austen's Pride and Prejudice`);
          }, 1000);
        })
    }
  }
}
// [End Main_inheritFreezeRouterPage1]