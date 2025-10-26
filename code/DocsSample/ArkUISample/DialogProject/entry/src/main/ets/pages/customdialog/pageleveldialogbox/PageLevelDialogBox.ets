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

// [Start page_level_dialog]
import { LevelMode, ImmersiveMode } from '@kit.ArkUI';

let customDialogId: number = 0;

@Builder
function customDialogBuilder(uiContext: UIContext) {
  Column() {
    Text('Custom dialog Message').fontSize(20).height(100)
    Row() {
      Button('Next').onClick(() => {
        // 在弹窗内部进行路由跳转。
        uiContext.getRouter().pushUrl({ url: 'pages/Next' });
      })
      Blank().width(50)
      Button('Close').onClick(() => {
        uiContext.getPromptAction().closeCustomDialog(customDialogId);
      })
    }
  }.padding(20)
}

@Entry
@Component
export struct PageLevelDialogBox {
  @State message: string = 'Hello World';
  private uiContext: UIContext = this.getUIContext();

  @Builder
  customDialogComponent() {
    customDialogBuilder(this.uiContext);
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          // [Start test_text]
          Text(this.message).id('test_text')
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              const node: FrameNode | null = this.getUIContext().getFrameNodeById('test_text') || null;
              // [Start open_custom_dialog]
              this.uiContext.getPromptAction().openCustomDialog({
                builder: () => {
                  this.customDialogComponent();
                },
                // [StartExclude test_text]
                levelMode: LevelMode.EMBEDDED, // 启用页面级弹出框
                // [EndExclude test_text]
                // [StartExclude open_custom_dialog]
                levelUniqueId: node?.getUniqueId(), // 设置页面级弹出框所在页面的任意节点ID
                immersiveMode: ImmersiveMode.EXTEND, // 设置页面级弹出框蒙层的显示模式
                // [EndExclude open_custom_dialog]
              })
              // [End open_custom_dialog]
                .then((dialogId: number) => {
                  customDialogId = dialogId;
                });
            })
          // [End test_text]

          // [Start dialog_embedded]
          Text(this.message).id('test_text')
            .onClick(() => {
              const node: FrameNode | null = this.getUIContext().getFrameNodeById('test_text') || null;
              this.getUIContext().getPromptAction().openCustomDialog({
                builder: () => {
                  this.customDialogComponent();
                },
                levelMode: LevelMode.EMBEDDED, // 启用页面级弹出框
                levelUniqueId: node?.getUniqueId(), // 设置页面级弹出框所在页面的任意节点ID
                immersiveMode: ImmersiveMode.EXTEND, // 设置页面级弹出框蒙层的显示模式
              });
            })
          // [End dialog_embedded]
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}

// [End page_level_dialog]
