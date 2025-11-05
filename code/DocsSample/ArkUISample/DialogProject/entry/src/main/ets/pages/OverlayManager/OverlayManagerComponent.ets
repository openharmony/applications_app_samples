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
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Sample_dialogproject]';
const DOMAIN: number = 0xFF00;

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

@Entry
@Component
export struct OverlayManagerComponent {
  @State message: string = 'ComponentContent';
  private uiContext: UIContext = this.getUIContext();
  private overlayNode: OverlayManager = this.uiContext.getOverlayManager();
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private manager = this.context.resourceManager;
  @StorageLink('contentArray') contentArray: ComponentContent<Params>[] = [];
  @StorageLink('componentContentIndex') componentContentIndex: number = 0;
  @StorageLink('arrayIndex') arrayIndex: number = 0;
  @StorageLink('componentOffset') componentOffset: Position = { x: 0, y: 30 };

  build() {
    // [StartExclude OverlayManager_Demo]
    NavDestination() {
      // [EndExclude OverlayManager_Demo]
      Column({ space: 10 }) {
        // 'OverlayManager_button_increase'资源文件中的value值为'递增componentContentIndex: '
        Button(this.manager.getStringByNameSync('OverlayManager_button_increase') + this.componentContentIndex)
          .onClick(() => {
            ++this.componentContentIndex;
          })
        // 'OverlayManager_button_decrease'资源文件中的value值为'递减componentContentIndex: '
        Button(this.manager.getStringByNameSync('OverlayManager_button_decrease') + this.componentContentIndex)
          .onClick(() => {
            --this.componentContentIndex;
          })
        // 'OverlayManager_button_add'资源文件中的value值为'增加ComponentContent'
        Button(this.manager.getStringByNameSync('OverlayManager_button_add') + this.contentArray.length)
          .onClick(() => {
            let componentContent = new ComponentContent(
              this.uiContext, wrapBuilder<[Params]>(builderText),
              new Params(this.message + (this.contentArray.length), this.componentOffset)
            )
            this.contentArray.push(componentContent);
            this.overlayNode.addComponentContent(componentContent, this.componentContentIndex);
          })
        // 'OverlayManager_button_increaseIndex'资源文件中的value值为'递增arrayIndex: '
        Button(this.manager.getStringByNameSync('OverlayManager_button_increaseIndex') + this.arrayIndex)
          .onClick(() => {
            ++this.arrayIndex;
          })
        // 'OverlayManager_button_decreaseIndex'资源文件中的value值为'递减arrayIndex: '
        Button(this.manager.getStringByNameSync('OverlayManager_button_decreaseIndex') + this.arrayIndex)
          .onClick(() => {
            --this.arrayIndex;
          })
        // 'OverlayManager_button_delete'资源文件中的value值为'删除ComponentContent'
        Button(this.manager.getStringByNameSync('OverlayManager_button_delete') + this.arrayIndex)
          .onClick(() => {
            if (this.arrayIndex >= 0 && this.arrayIndex < this.contentArray.length) {
              let componentContent = this.contentArray.splice(this.arrayIndex, 1);
              this.overlayNode.removeComponentContent(componentContent.pop());
            } else {
              hilog.info(DOMAIN, TAG, '%{public}s', 'arrayIndex error');
            }
          })
        // 'OverlayManager_button_show'资源文件中的value值为'显示ComponentContent'
        Button(this.manager.getStringByNameSync('OverlayManager_button_show') + this.arrayIndex)
          .onClick(() => {
            if (this.arrayIndex >= 0 && this.arrayIndex < this.contentArray.length) {
              let componentContent = this.contentArray[this.arrayIndex];
              this.overlayNode.showComponentContent(componentContent);
            } else {
              hilog.info(DOMAIN, TAG, '%{public}s', 'arrayIndex error');
            }
          })
        // 'OverlayManager_button_hide'资源文件中的value值为'隐藏ComponentContent'
        Button(this.manager.getStringByNameSync('OverlayManager_button_hide') + this.arrayIndex)
          .onClick(() => {
            if (this.arrayIndex >= 0 && this.arrayIndex < this.contentArray.length) {
              let componentContent = this.contentArray[this.arrayIndex];
              this.overlayNode.hideComponentContent(componentContent);
            } else {
              hilog.info(DOMAIN, TAG, '%{public}s', 'arrayIndex error');
            }
          })
        // 'app.string.OverlayManager_button_showAll'资源文件中的value值为'显示所有ComponentContent'
        Button($r('app.string.OverlayManager_button_showAll'))
          .onClick(() => {
            this.overlayNode.showAllComponentContents();
          })
        // 'app.string.OverlayManager_button_hideAll'资源文件中的value值为'隐藏所有ComponentContent'
        Button($r('app.string.OverlayManager_button_hideAll'))
          .onClick(() => {
            this.overlayNode.hideAllComponentContents();
          })

        // 'app.string.OverlayManager_button_jump'资源文件中的value值为'跳转页面'
        Button($r('app.string.OverlayManager_button_jump'))
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/Second'
            })
          })
      }
      .width('100%')
      .height('100%')
      // [StartExclude OverlayManager_Demo]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.OverlayManager_component_title'))
    // [EndExclude OverlayManager_Demo]
  }
}
// [End OverlayManager_Demo]
