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
import resource from '../../common/resource';

@Entry
@Component
export struct SelectMenu {
  controller: TextController = new TextController();
  options: TextOptions = { controller: this.controller };

  // 定义菜单项
  @Builder
  RightClickTextCustomMenu() {
    Column() {
      Menu() {
        MenuItemGroup() {
          MenuItem({ startIcon: $r('app.media.app_icon'), content: 'CustomMenu One', labelInfo: '' })
            .onClick(() => {
              // 使用closeSelectionMenu接口关闭菜单
              this.controller.closeSelectionMenu();
            })
          MenuItem({ startIcon: $r('app.media.app_icon'), content: 'CustomMenu Two', labelInfo: '' })
          MenuItem({ startIcon: $r('app.media.app_icon'), content: 'CustomMenu Three', labelInfo: '' })
        }
      }.backgroundColor('#F0F0F0')
    }
  }

  // 定义onCreateMenu，onMenuItemClick
  onCreateMenu = (menuItems: Array<TextMenuItem>) => {
    let item1: TextMenuItem = {
      content: 'customMenu1',
      icon: $r('app.media.app_icon'),
      id: TextMenuItemId.of('customMenu1'),
    };
    let item2: TextMenuItem = {
      content: 'customMenu2',
      id: TextMenuItemId.of('customMenu2'),
      icon: $r('app.media.app_icon'),
    };
    menuItems.push(item1);
    menuItems.unshift(item2);
    return menuItems;
  }
  onMenuItemClick = (menuItem: TextMenuItem, textRange: TextRange) => {
    if (menuItem.id.equals(TextMenuItemId.of('customMenu2'))) {
      console.log(resource.resourceToString($r('app.string.SelectMenu_Text_1')) +
      textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.COPY)) {
      console.log(resource.resourceToString($r('app.string.SelectMenu_Text_2')) +
      textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.SELECT_ALL)) {
      console.log(resource.resourceToString($r('app.string.SelectMenu_Text_3')) +
      textRange.start + '; end:' + textRange.end);
      return false;
    }
    return false;
  };

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SetSelectionMenu_textContent_1') }) {
          // [Start set_selection_menu_with_copyoption]
          Text($r('app.string.SelectMenu_textContent_1'))
            .fontSize(30)
            .copyOption(CopyOptions.InApp)
          // [End set_selection_menu_with_copyoption]
        }

        ComponentCard({ title: $r('app.string.SetSelectionMenu_textContent_2') }) {
          // [Start set_selection_menu_with_bindselectionmenu]
          Text($r('app.string.SelectMenu_textContent_1'), this.options)
            .fontSize(30)
            .copyOption(CopyOptions.InApp)
            .bindSelectionMenu(TextSpanType.TEXT, this.RightClickTextCustomMenu, TextResponseType.RIGHT_CLICK, {
              onAppear: () => {
                console.info(resource.resourceToString($r('app.string.SelectMenu_Text_4')));
              },
              onDisappear: () => {
                console.info(resource.resourceToString($r('app.string.SelectMenu_Text_5')));
              }
            })
          // [Start set_selection_menu_with_bindselectionmenu]
        }

        ComponentCard({ title: $r('app.string.SetSelectionMenu_textContent_3') }) {
          // [Start set_selection_menu_with_editmenuoptions]
          Text($r('app.string.SelectMenu_textContent_1'))
            .fontSize(20)
            .copyOption(CopyOptions.LocalDevice)
            .editMenuOptions({
              onCreateMenu: this.onCreateMenu, onMenuItemClick: this.onMenuItemClick
            })
          // [End set_selection_menu_with_editmenuoptions]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SetSelectionMenu_title'))
  }
}