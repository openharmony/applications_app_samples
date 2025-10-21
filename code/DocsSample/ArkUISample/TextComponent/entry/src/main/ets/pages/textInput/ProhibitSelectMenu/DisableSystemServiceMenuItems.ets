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

// [Start DisableSystemServiceMenuItems]
import { TextMenuController } from '@kit.ArkUI';

// xxx.ets
@Entry
@Component
export struct DisableSystemServiceMenuItems {
  aboutToAppear(): void {
    // 禁用所有系统服务菜单项
    TextMenuController.disableSystemServiceMenuItems(true)
  }

  aboutToDisappear(): void {
    // 页面消失时恢复系统服务菜单项
    TextMenuController.disableSystemServiceMenuItems(false)
  }

  build() {
    // [StartExclude DisableSystemServiceMenuItems]
    NavDestination() {
      // [EndExclude DisableSystemServiceMenuItems]
      Row() {
        Column() {
          TextInput({ text: "这是一个TextInput，长按弹出文本选择菜单" })
            .height(60)
            .fontStyle(FontStyle.Italic)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .caretStyle({ width: '4vp' })
            .editMenuOptions({
              onCreateMenu: (menuItems: Array<TextMenuItem>) => {
                // menuItems不包含被屏蔽的系统菜单项
                return menuItems
              },
              onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
                return false
              }
            })
        }.width('100%')
      }
      .height('100%')
      // [StartExclude DisableSystemServiceMenuItems]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ProhibitSelectMenu_title_1'))
    // [EndExclude DisableSystemServiceMenuItems]
  }
}
// [End DisableSystemServiceMenuItems]