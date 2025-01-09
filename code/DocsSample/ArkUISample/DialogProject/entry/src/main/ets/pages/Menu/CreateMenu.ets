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

class Tmp {
  private iconStr2: ResourceStr = $r('app.media.app_icon')

  set(val: Resource) {
    this.iconStr2 = val;
  }
}

@Entry
@Component
export struct menuExample  {
  @State select: boolean = true;
  private iconStr: ResourceStr = $r('app.media.app_icon');
  private iconStr2: ResourceStr = $r('app.media.app_icon');

  @Builder
  SubMenu() {
    Menu() {
      MenuItem({ content: 'copy', labelInfo: 'Ctrl+C' })
      MenuItem({ content: 'paste', labelInfo: 'Ctrl+V' })
    }
  }

  @Builder
  MyMenu() {
    Menu() {
      MenuItem({ startIcon: $r('app.media.app_icon'), content: $r('app.string.menu_single') })
      MenuItem({ startIcon: $r('app.media.app_icon'), content: $r('app.string.menu_forbid') }).enabled(false)
      MenuItem({
        startIcon: this.iconStr,
        content: $r('app.string.menu_more'),
        endIcon: $r('app.media.app_icon'),
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
            str.set($r('app.media.app_icon'));
          })
        MenuItem({
          startIcon: $r('app.media.app_icon'),
          content: $r('app.string.menu_more'),
          endIcon: $r('app.media.foreground'),
          builder: this.SubMenu
        })
      }

      MenuItem({
        startIcon: this.iconStr2,
        content: $r('app.string.menu_single'),
        endIcon: $r('app.media.app_icon')
      })
    }
  }
  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Button($r('app.string.menu_default'))
          .bindMenu([
            {
              value: 'Menu1',
              action: () => {
                console.info('handle Menu1 select');
              }
            }
          ])
          .width(160)
          .height(50)

        Button($r('app.string.menu_bind'))
          .bindMenu(this.MyMenu)
          .width(160)
          .height(50)

        Button($r('app.string.menu_rightClick'))
          .bindContextMenu(this.MyMenu, ResponseType.RightClick)
          .width(160)
          .height(50)

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.create_menu'))
  }
}