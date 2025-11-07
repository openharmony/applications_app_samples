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
// [Start Service_MenuItems]
import { TextMenuController } from '@kit.ArkUI';
// xxx.ets
@Entry
@Component
export struct ServiceMenuItems {
  aboutToAppear(): void {
    // 禁用所有系统服务菜单
    TextMenuController.disableSystemServiceMenuItems(true);
  }

  aboutToDisappear(): void {
    // 页面消失恢复系统服务菜单
    TextMenuController.disableSystemServiceMenuItems(false);
  }
  build() {
    NavDestination() {
      Row() {
        Column() {
          // 'app.string.Service_MenuItems_Text'资源文件中的value值为'这是一段文本，长按弹出文本选择菜单。'
          Text($r('app.string.Service_MenuItems_Text'))
            .height(60)
            .fontStyle(FontStyle.Italic)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .copyOption(CopyOptions.InApp)
            .editMenuOptions({
              onCreateMenu: (menuItems: Array<TextMenuItem>) => {
                // menuItems不包含被屏蔽的系统菜单项
                return menuItems;
              },
              onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
                return false;
              }
            })
        }.width('100%')
      }
      .height('100%')
    }
    // [StartExclude Service_MenuItems]
    .backgroundColor('#f1f 2f3')
    .title($r('app.string.Service_MenuItems'))
    // [EndExclude Service_MenuItems]
  }
}

// [End Service_MenuItems]