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
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
export struct SelectMenu {
  // [Start set_selection_menu_with_bindselectionmenu]
  controller: TextController = new TextController();
  options: TextOptions = { controller: this.controller };
  // [End set_selection_menu_with_bindselectionmenu]
  // [Start Right_Click_Text_CustomMenu]
  // 定义菜单项
  @Builder
  RightClickTextCustomMenu() {
    Column() {
      Menu() {
        MenuItemGroup() {
          // 请将$r('app.media.app_icon')替换为实际资源文件
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
  // [End Right_Click_Text_CustomMenu]
  // [Start onCreate_Menu]
  // 定义onCreateMenu，onMenuItemClick
  // 请将$r('app.media.app_icon')替换为实际资源文件
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
      // 请将$r('app.string.SelectMenu_Text_customMenu')替换为实际资源文件，在本示例中该资源文件的value值为"拦截 id: customMenu2 start:"
      hilog.info(0x0000, 'Sample_TextComponent',
        resource.resourceToString($r('app.string.SelectMenu_Text_customMenu')) + textRange.start + '; end:' +
        textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.COPY)) {
      // 请将$r('app.string.SelectMenu_Text_copy')替换为实际资源文件，在本示例中该资源文件的value值为"拦截 COPY start:"
      hilog.info(0x0000, 'Sample_TextComponent',
        resource.resourceToString($r('app.string.SelectMenu_Text_copy')) + textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.SELECT_ALL)) {
      // 请将$r('app.string.SelectMenu_Text_SelectionAll')替换为实际资源文件，在本示例中该资源文件的value值为"不拦截 SELECT_ALL start:"
      hilog.info(0x0000, 'Sample_TextComponent',
        resource.resourceToString($r('app.string.SelectMenu_Text_SelectionAll')) + textRange.start + '; end:' +
        textRange.end);
      return false;
    }
    return false;
  };
  // [End onCreate_Menu]
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SetSelectionMenu_textContent_1') }) {
          // [Start set_selection_menu_with_copyoption]
          // 请将$r('app.string.show_selected_menu')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，用来展示选中菜单"
          Text($r('app.string.show_selected_menu'))
            .fontSize(30)
            .copyOption(CopyOptions.InApp)
          // [End set_selection_menu_with_copyoption]
        }

        ComponentCard({ title: $r('app.string.SetSelectionMenu_textContent_2') }) {
          // [Start set_selection_menu_with_bindselectionmenu_sec]
          // 请将$r('app.string.show_selected_menu')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，用来展示选中菜单"
          Text($r('app.string.show_selected_menu'), this.options)
            .fontSize(30)
            .copyOption(CopyOptions.InApp)
            .bindSelectionMenu(TextSpanType.TEXT, this.RightClickTextCustomMenu, TextResponseType.RIGHT_CLICK, {
              onAppear: () => {
                // 请将$r('app.string.SelectMenu_Text_Ejected')替换为实际资源文件，在本示例中该资源文件的value值为"自定义选择菜单弹出时触发该回调"
                hilog.info(0x0000, 'Sample_TextComponent',
                  resource.resourceToString($r('app.string.SelectMenu_Text_Ejected')));
              },
              onDisappear: () => {
                // 'SelectMenu_Text_Close'资源文件中的value值为'自定义选择菜单关闭时触发该回调'
                hilog.info(0x0000, 'Sample_TextComponent',
                  resource.resourceToString($r('app.string.SelectMenu_Text_Close')));
              }
            })
          // [End set_selection_menu_with_bindselectionmenu_sec]
        }

        ComponentCard({ title: $r('app.string.SetSelectionMenu_textContent_3') }) {
          // [Start set_selection_menu_with_editmenuoptions]
          // 请将$r('app.string.show_selected_menu')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，用来展示选中菜单"
          Text($r('app.string.show_selected_menu'))
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