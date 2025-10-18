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

// [Start OverlayManager_Demo]
import { ComponentContent, OverlayManager } from '@kit.ArkUI';

class Params {
  public text: string = '';
  public offset: Position;

  constructor(text: string, offset: Position) {
    this.text = text;
    this.offset = offset;
  }
}

@Builder
function builderText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
  }.offset(params.offset)
}

function initOverlayNode(uiContext: UIContext): OverlayManager {
  uiContext.setOverlayManagerOptions({
    enableBackPressedEvent: true
  });
  return uiContext.getOverlayManager();
}

@Entry
@Component
export struct OverlayManagerDemo1 {
  @State message: string = 'ComponentContent';
  private uiContext: UIContext = this.getUIContext();
  private overlayNode: OverlayManager = this.uiContext.getOverlayManager();
  @StorageLink('contentArray') contentArray: ComponentContent<Params>[] = [];
  @StorageLink('componentContentIndex') componentContentIndex: number = 0;
  @StorageLink('arrayIndex') arrayIndex: number = 0;
  @StorageLink('componentOffset') componentOffset: Position = { x: 0, y: 30 };

  build() {
    // [StartExclude OverlayManager_Demo]
    NavDestination() {
      // [EndExclude OverlayManager_Demo]
      Column({ space: 10 }) {
        Button('递增componentContentIndex: ' + this.componentContentIndex).onClick(() => {
          ++this.componentContentIndex;
        })
        Button('递减componentContentIndex: ' + this.componentContentIndex).onClick(() => {
          --this.componentContentIndex;
        })
        Button('增加ComponentContent' + this.contentArray.length).onClick(() => {
          let componentContent = new ComponentContent(
            this.uiContext, wrapBuilder<[Params]>(builderText),
            new Params(this.message + (this.contentArray.length), this.componentOffset)
          );
          this.contentArray.push(componentContent);
          this.overlayNode.addComponentContent(componentContent, this.componentContentIndex);
        })
        Button('递增arrayIndex: ' + this.arrayIndex).onClick(() => {
          ++this.arrayIndex;
        })
        Button('递减arrayIndex: ' + this.arrayIndex).onClick(() => {
          --this.arrayIndex;
        })
        Button('删除ComponentContent' + this.arrayIndex).onClick(() => {
          if (this.arrayIndex >= 0 && this.arrayIndex < this.contentArray.length) {
            let componentContent = this.contentArray.splice(this.arrayIndex, 1);
            this.overlayNode.removeComponentContent(componentContent.pop());
          } else {
            console.info('arrayIndex有误');
          }
        })
        Button('显示ComponentContent' + this.arrayIndex).onClick(() => {
          if (this.arrayIndex >= 0 && this.arrayIndex < this.contentArray.length) {
            let componentContent = this.contentArray[this.arrayIndex];
            this.overlayNode.showComponentContent(componentContent);
          } else {
            console.info('arrayIndex有误');
          }
        })
        Button('隐藏ComponentContent' + this.arrayIndex).onClick(() => {
          if (this.arrayIndex >= 0 && this.arrayIndex < this.contentArray.length) {
            let componentContent = this.contentArray[this.arrayIndex];
            this.overlayNode.hideComponentContent(componentContent);
          } else {
            console.info('arrayIndex有误');
          }
        })
        Button('显示所有ComponentContent').onClick(() => {
          this.overlayNode.showAllComponentContents();
        })
        Button('隐藏所有ComponentContent').onClick(() => {
          this.overlayNode.hideAllComponentContents();
        })

        Button('跳转页面').onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/OverlayManager_ROUTE_PREFIX'
          })
        })
      }
      .width('100%')
      .height('100%')
    // [StartExclude OverlayManager_Demo]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.OverlayManager_demo1_title'))
    // [EndExclude OverlayManager_Demo]
  }
}
// [End OverlayManager_Demo]
