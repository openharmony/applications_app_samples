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
// [Start Main_PostTouchEvent]
import { NodeController, BuilderNode, FrameNode, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

class Params {
  public text: string = 'this is a text';
}

@Builder
function buttonBuilder(params: Params) {
  Column() {
    Button(`button ` + params.text)
      .borderWidth(2)
      .backgroundColor(Color.Orange)
      .width('100%')
      .height('100%')
      .gesture(
        TapGesture()
          .onAction((event: GestureEvent) => {
            hilog.info(0xF811,'testTag','%{public}s','TapGesture');
          })
      )
  }
  .width(500)
  .height(300)
  .backgroundColor(Color.Gray)
}

class MyNodeController extends NodeController {
  private rootNode: BuilderNode<[Params]> | null = null;
  private wrapBuilder: WrappedBuilder<[Params]> = wrapBuilder(buttonBuilder);

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.build(this.wrapBuilder, { text: 'this is a string' })
    return this.rootNode.getFrameNode();
  }

  postTouchEvent(touchEvent: TouchEvent): void {
    if (this.rootNode == null) {
      return;
    }
    let result = this.rootNode.postTouchEvent(touchEvent);
    hilog.info(0xF811,'testTag','%{public}s','result' + result);
  }
}

@Entry
@Component
struct postTouchEventPage {
  private nodeController: MyNodeController = new MyNodeController();
  @State bgColor: Color = Color.Pink;

  build() {
    Column() {
      NodeContainer(this.nodeController)
        .height(300)
        .width(500)
      Column()
        .id('onTouch')
        .width(500)
        .height(300)
        .backgroundColor(this.bgColor)
        .onTouch((event) => {
          if (event != undefined) {
            this.nodeController.postTouchEvent(event);
            this.bgColor = Color.Blue;
          }
        })
    }
  }
}
// [End Main_PostTouchEvent]