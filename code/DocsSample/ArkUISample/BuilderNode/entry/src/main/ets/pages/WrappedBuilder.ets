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
// [Start Main_WrappedBuilder]
import { NodeController, BuilderNode, FrameNode, UIContext } from '@kit.ArkUI';

class Params {
  public text: string = '';
  constructor(text: string) {
    this.text = text;
  }
}

// 自定义组件
@Component
struct TextBuilder {
  // 作为自定义组件中需要更新的属性，数据类型为基础属性，定义为@Prop
  @Prop message: string = 'TextBuilder';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })
          .backgroundColor(Color.Gray)
      }
    }
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(40)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 10 })
    TextBuilder({ message: params.text }) // 自定义组件
  }
  .width('100%')
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)

}

class TextNodeController extends NodeController {
  private textNode: BuilderNode<[Params]> | null = null;
  private message: string = '';

  constructor(message: string) {
    super();
    this.message = message;
  }

  makeNode(context: UIContext): FrameNode | null {
    this.textNode = new BuilderNode(context);
    this.textNode.build(wrapBuilder<[Params]>(buildText), new Params(this.message));
    return this.textNode.getFrameNode();
  }

  update(message: string) {
    if (this.textNode !== null) {
      // 调用update进行更新。
      this.textNode.update(new Params(message));
    }
  }
}

@Entry
@Component
struct WrappedBuilderPage {
  @State message: string = 'hello';
  private textNodeController: TextNodeController = new TextNodeController(this.message);
  private count = 0;

  build() {
    Row() {
      Column({ space: 25}) {
        NodeContainer(this.textNodeController)
          .width('100%')
          .height(110)
          .backgroundColor('#FFF0F0F0')
        Button('Update')
          .onClick(() => {
            this.count += 1;
            const message = 'Update' + this.count.toString();
            this.textNodeController.update(message);
          })
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}
// [End Main_WrappedBuilder]