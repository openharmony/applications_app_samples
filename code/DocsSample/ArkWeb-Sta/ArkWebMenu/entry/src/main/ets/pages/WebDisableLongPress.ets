'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start web_Disable_long_press]
import { Entry, Column, Component } from '@ohos.arkui.component'
import { State } from '@ohos.arkui.stateManagement'
import { $rawfile, Web, EditMenuOptions, TextRange, TextMenuItem } from '@ohos.arkui.component'
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController(undefined);

  @State editMenuOptions: EditMenuOptions = {
    onCreateMenu: (menuItems: Array<TextMenuItem>): Array<TextMenuItem> => {
      return menuItems.filter(() => false)
    },
    onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange): boolean => {
      return false;
    }
  } as EditMenuOptions

  build() {
    Column() {
      Web({ src: $rawfile('index7.html'), controller: this.controller })
        .editMenuOptions(this.editMenuOptions)
    }
  }
}
// [End web_Disable_long_press]