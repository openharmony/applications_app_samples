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
// [Start richEditor_disableMenu]
import { TextMenuController } from '@kit.ArkUI';


@Entry
@Component
export struct DisableMenuItem {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  aboutToAppear(): void {
    // 禁用搜索和翻译菜单
    TextMenuController.disableMenuItems([TextMenuItemId.SEARCH, TextMenuItemId.TRANSLATE]);
  }

  aboutToDisappear(): void {
    // 恢复系统服务菜单
    TextMenuController.disableMenuItems([]);
  }

  build() {
    // [StartExclude richEditor_disableMenu]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard() {
          // [EndExclude richEditor_disableMenu]
          RichEditor(this.options)
            .onReady(() => {
              // $r('app.string.Demo_richEditor')需要替换为开发者所需的资源文件
              this.controller.addTextSpan($r('app.string.Demo_richEditor'), {
                style: {
                  fontSize: 30
                }
              })
            })
            .height(60)
            .editMenuOptions({
              onCreateMenu: (menuItems: Array<TextMenuItem>) => {
                // menuItems不包含搜索和翻译
                return menuItems;
              },
              onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
                return false;
              }
            });
          // [StartExclude richEditor_disableMenu]
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12 });
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Disable_Menu_Item_title'));
    // [EndExclude richEditor_disableMenu]
  }
}
// [End richEditor_disableMenu]