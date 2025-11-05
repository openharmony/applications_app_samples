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

import { PromptAction } from '@kit.ArkUI';

// [Start builder_menu_content]
class Tmp {
  private iconStr2: ResourceStr = $r('app.media.view_list_filled')

  set(val: Resource) {
    this.iconStr2 = val;
  }
}

@Entry
@Component
export struct menuExample  {
  @State select: boolean = true;
  private iconStr: ResourceStr = $r('app.media.view_list_filled');
  private iconStr2: ResourceStr = $r('app.media.view_list_filled');
  private copy: ResourceStr = $r('app.string.copy');
  private paste: ResourceStr = $r('app.string.paste');

  @Builder
  SubMenu() {
    Menu() {
      MenuItem({ content: this.copy, labelInfo: 'Ctrl+C' })
      MenuItem({ content: this.paste, labelInfo: 'Ctrl+V' })
    }
  }

  @Builder
  MyMenu() {
    Menu() {
      MenuItem({ startIcon: $r('app.media.icon'), content: $r('app.string.menu_selection') })
      MenuItem({ startIcon: $r('app.media.icon'), content: $r('app.string.menu_selection') }).enabled(false)
      MenuItem({
        startIcon: this.iconStr,
        content: $r('app.string.menu_selection'),
        endIcon: $r('app.media.arrow_right_filled'),
        // 当builder参数进行配置时，表示与menuItem项绑定了子菜单。鼠标hover在该菜单项时，会显示子菜单。
        builder: this.SubMenu
      })
      MenuItemGroup({ header: $r('app.string.menu_subtitle') }) {
        MenuItem({ content: $r('app.string.menu_selection') })
          .selectIcon(true)
          .selected(this.select)
          .onChange((selected) => {
            console.info('menuItem select' + selected);
            let str: Tmp = new Tmp();
            str.set($r('app.media.icon'));
          })
        MenuItem({
          startIcon: $r('app.media.view_list_filled'),
          content: $r('app.string.menu_selection'),
          endIcon: $r('app.media.arrow_right_filled'),
          builder: this.SubMenu
        })
      }

      MenuItem({
        startIcon: this.iconStr2,
        content: $r('app.string.menu_selection'),
        endIcon: $r('app.media.arrow_right_filled')
      })
    }
  }
  build() {
    // [StartExclude builder_menu_content]
    NavDestination() {
      Column({ space: 12 }) {

        // [Start call_bind_menu]
        Button('click for Menu')
          .bindMenu([
            {
              value: 'Menu1',
              action: () => {
                console.info('handle Menu1 select');
              }
            }
          ])
          // [End call_bind_menu]
          .width(160)
          .height(50)

        // [Start bind_menu_property]
        Button('click for Menu')
          .bindMenu(this.MyMenu)
          // [End bind_menu_property]
          .id('click for Menu One')
          .width(160)
          .height(50)

        // [Start create_right_click_menu]
        Button('click for Menu')
          .bindContextMenu(this.MyMenu, ResponseType.RightClick)
          // [End create_right_click_menu]
          .width(160)
          .height(50)

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.create_menu')需要替换为开发者所需的资源文件。
    .title($r('app.string.create_menu'))
  }
  // [EndExclude builder_menu_content]
}
// [End builder_menu_content]