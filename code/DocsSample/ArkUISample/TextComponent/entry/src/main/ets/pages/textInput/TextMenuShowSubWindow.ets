/*
 * Copyright (c) 2026-2026 Huawei Device Co., Ltd.
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

@Entry
@Component
struct TextMenuShowSubWindow {
  aboutToAppear(): void {
    // [Start set_menu_options_with_textmenushowmode]
    this.getUIContext()
      .getTextMenuController()
      .setMenuOptions(
        {
          showMode: TextMenuShowMode.PREFER_WINDOW
        }
      );
    // [End set_menu_options_with_textmenushowmode]
  }

  build() {
    NavDestination() {
      ComponentCard({ description: $r('app.string.TextMenuShow_description') }) {
        Column({ space: 5 }) {
          // [Start textmenushowmode_create_textinput]
          // 请将$r('app.string.Service_MenuItems_Text')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，长按弹出文本选择菜单"
          TextInput({ text: $r('app.string.Service_MenuItems_Text') })
            .fontSize(20)
            .copyOption(CopyOptions.InApp)
            .textAlign(TextAlign.Center)
          // [End textmenushowmode_create_textinput]
        }
        .height('100%')
        .width('100%')   
      }
    }
    // 请将$r('app.string.TextMenuShow_title')替换为实际资源文件，在本示例中该资源文件的value值为"子窗口显示文本"
    .title($r('app.string.TextMenuShow_title'))
  }
}

export { TextMenuShowSubWindow };