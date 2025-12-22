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

import { ComponentCard } from '../../common/Card';
// [Start richEditor_disableSystemMenu]
import { TextMenuController } from '@kit.ArkUI';

@Entry
@Component
export struct DisableSystemServiceMenu {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  aboutToAppear(): void {
    // 禁用所有系统服务菜单
    TextMenuController.disableSystemServiceMenuItems(true);
  }

  aboutToDisappear(): void {
    // 页面消失恢复系统服务菜单
    TextMenuController.disableSystemServiceMenuItems(false);
  }

  build() {
    // [StartExclude richEditor_disableSystemMenu]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard() {
          // [EndExclude richEditor_disableSystemMenu]
          RichEditor(this.options).onReady(() => {
            // 请将$r('app.string.Demo_richEditor')替换为实际资源文件，在本示例中该资源文件的value值为"这是一个RichEditor"
            this.controller.addTextSpan($r('app.string.Demo_richEditor'),
              {
                style:
                {
                  fontSize: 30
                }
              })
          })
            .height(60)
            .editMenuOptions({
              onCreateMenu: (menuItems: Array<TextMenuItem>) => {
                // menuItems不包含被屏蔽的系统菜单项
                return menuItems;
              },
              onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
                return false;
              }
            })
          // [StartExclude richEditor_disableSystemMenu]
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12 });
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Disable_SystemService_Menu_title')替换为实际资源文件，在本示例中该资源文件的value值为"禁用系统服务菜单"
    .title($r('app.string.Disable_SystemService_Menu_title'));
    // [EndExclude richEditor_disableSystemMenu]
  }
}
// [End richEditor_disableSystemMenu]