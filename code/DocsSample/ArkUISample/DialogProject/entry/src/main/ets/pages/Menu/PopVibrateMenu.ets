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
import { hilog } from '@kit.PerformanceAnalysisKit';

class Tmp {
  // 请将$r('app.media.app_icon')替换为实际资源文件
  private iconStr2: ResourceStr = $r('app.media.app_icon')

  set(val: Resource) {
    this.iconStr2 = val;
  }
}

@Entry
@Component
export struct PopVibrateMenuExample  {
  @State select: boolean = true;
  // 请将$r('app.media.app_icon')替换为实际资源文件
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
      // 请将$r('app.string.menu_single')替换为实际资源文件，在本示例中该资源文件的value值为"菜单选项单级"
      // 请将$r('app.media.app_icon')替换为实际资源文件
      MenuItem({ startIcon: $r('app.media.app_icon'), content: $r('app.string.menu_single') })
      // 请将$r('app.string.menu_forbid')替换为实际资源文件，在本示例中该资源文件的value值为"菜单不可选择"
      // 请将$r('app.media.app_icon')替换为实际资源文件
      MenuItem({ startIcon: $r('app.media.app_icon'), content: $r('app.string.menu_forbid') }).enabled(false)
      // 请将$r('app.string.menu_more')替换为实际资源文件，在本示例中该资源文件的value值为"菜单选项多级"
      // 请将$r('app.media.app_icon')替换为实际资源文件
      MenuItem({
        startIcon: this.iconStr,
        content: $r('app.string.menu_more'),
        endIcon: $r('app.media.app_icon'),
        // 当builder参数进行配置时，表示与menuItem项绑定了子菜单。鼠标hover在该菜单项时，会显示子菜单。
        builder: this.SubMenu
      })
      // 请将$r('app.string.menu_subtitle')替换为实际资源文件，在本示例中该资源文件的value值为"小标题"
      MenuItemGroup({ header: $r('app.string.menu_subtitle') }) {
        // 请将$r('app.string.menu_selection')替换为实际资源文件，在本示例中该资源文件的value值为"菜单选项"
        MenuItem({ content: $r('app.string.menu_selection') })
          .selectIcon(true)
          .selected(this.select)
          .onChange((selected) => {
            hilog.info(0xFF00, 'DialogProject', 'menuItem select' + selected);
            let str: Tmp = new Tmp();
            // 请将$r('app.media.app_icon')替换为实际资源文件
            str.set($r('app.media.app_icon'));
          })
        // 请将$r('app.string.menu_more')替换为实际资源文件，在本示例中该资源文件的value值为"菜单选项多级"
        // 请将$r('app.media.xxx')替换为实际资源文件
        MenuItem({
          startIcon: $r('app.media.app_icon'),
          content: $r('app.string.menu_more'),
          endIcon: $r('app.media.foreground'),
          builder: this.SubMenu
        })
      }
      // 请将$r('app.string.menu_single')替换为实际资源文件，在本示例中该资源文件的value值为"菜单选项单级"
      // 请将$r('app.media.app_icon')替换为实际资源文件
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

        // [Start popVibrate_menu]
        Button('click for Menu')
          .id('click for Menu')
          .bindMenu(this.MyMenu, { hapticFeedbackMode: HapticFeedbackMode.ENABLED})
          // [End popVibrate_menu]
          .width(160)
          .height(50)

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    // [StartExclude popVibrate_menu]
    .title($r('app.string.PopVibrateMenu_title'))
    // [EndExclude popVibrate_menu]
  }
}