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
// [Start Disable_MenuItems]
import { TextMenuController } from '@kit.ArkUI';

// xxx.ets
@Entry
@Component
export struct DisableMenuItems {
  aboutToAppear(): void {
    // 禁用搜索菜单
    TextMenuController.disableMenuItems([TextMenuItemId.SEARCH])
  }

  aboutToDisappear(): void {
    // 恢复系统服务菜单
    TextMenuController.disableMenuItems([])
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          // 请将$r('app.string.Service_MenuItems_Text')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，长按弹出文本选择菜单。"
          Text($r('app.string.Service_MenuItems_Text'))
            .height(60)
            .fontStyle(FontStyle.Italic)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .copyOption(CopyOptions.InApp)
            .editMenuOptions({
              onCreateMenu: (menuItems: Array<TextMenuItem>) => {
                // menuItems不包含搜索
                return menuItems;
              },
              onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
                return false
              }
            })
        }.width('100%')
      }
      .height('100%')
    }
    // [StartExclude Disable_MenuItems]
    .backgroundColor('#f1f 2f3')
    .title($r('app.string.Disable_MenuItems'))
    // [EndExclude Disable_MenuItems]
  }
}

// [End Disable_MenuItems]