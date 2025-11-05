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

// [Start dialog_box]
import { LevelOrder } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const INDEX: number = 0;

@Entry
@Component
export struct DialogBoxLayer {
  @StorageLink('dialogIndex') dialogIndex: number = INDEX;

  // [Start normal_custom_dialog]
  @Builder
  normalCustomDialog(index: number) {
    Column() {
      //'open_normal_dialog'资源文件中的value值为'我是普通弹窗'
      Text(this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('open_normal_dialog') as string +
        index).fontSize(30)
    }.height(400).padding(5).justifyContent(FlexAlign.SpaceBetween)
  }

  // [End normal_custom_dialog]

  // [Start top_custom_dialog]
  @Builder
  topCustomDialog() {
    Column() {
      //'app.string.top_dialog'资源文件中的value值为'我是置顶弹窗'
      Text($r('app.string.top_dialog')).fontSize(30)
      Row({ space: 50 }) {
        //'app.string.open_dialog'资源文件中的value值为'点我打开普通弹窗'
        Button($r('app.string.open_dialog'))
          .onClick(() => {
            // [Start open_custom_dialog]
            this.getUIContext().getPromptAction().openCustomDialog({
              builder: () => {
                this.normalCustomDialog(this.dialogIndex);
              },
              levelOrder: LevelOrder.clamp(0),
            })
              .catch((err: BusinessError) => {
                hilog.error(0x0000, 'dialogBoxLayer', 'openCustomDialog error: ' + err.code + '' + err.message);
              });
            // [End open_custom_dialog]
            this.dialogIndex++;
          })
      }
    }.height(200).padding(5).justifyContent(FlexAlign.SpaceBetween)
  }

  // [End top_custom_dialog]

  build() {
    NavDestination() {
      Row() {
        Column({ space: 5 }) {
          //'app.string.click_dialog'资源文件中的value值为'点击弹窗'
          Button($r('app.string.click_dialog'))
            .fontSize(20)
            .onClick(() => {
              // [Start open_top_custom_dialog]
              this.getUIContext().getPromptAction().openCustomDialog({
                builder: () => {
                  this.topCustomDialog();
                },
                levelOrder: LevelOrder.clamp(100000)
              }).catch((err: BusinessError) => {
                hilog.error(0x0000, 'dialogBoxLayer', 'openCustomDialog error: ' + err.code + ' ' + err.message);
              });
              // [End open_top_custom_dialog]
            })
        }.width('100%')
      }
    }
  }
}

// [End dialog_box]