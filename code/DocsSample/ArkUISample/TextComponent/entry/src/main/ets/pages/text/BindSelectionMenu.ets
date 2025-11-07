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
@Entry
@Component
export struct BindSelectionMenu {
  // [Start Bind_SelectionMenu]
  controller: TextController = new TextController()
  // 定义菜单项
  build() {
    NavDestination() {
      Column() {
        // 'app.string.display_the_selected_menu'资源文件中的value值为'这是一段文本，用来展示选中菜单'
        Text($r('app.string.display_the_selected_menu'), { controller: this.controller })
          .fontSize(30)
          .copyOption(CopyOptions.InApp)
          .bindSelectionMenu(TextSpanType.TEXT, this.RightClickTextCustomMenu, TextResponseType.RIGHT_CLICK, {
            onAppear: () => {
              console.info($r('app.string.custom_selection_menu_pops_up').toString());
            },
            onDisappear: () => {
              console.info($r('app.string.custom_selection_menu_is_closed').toString());
            }
          })
      }
    }
    // [StartExclude Bind_SelectionMenu]
    .backgroundColor('#f1f 2f3')
    .title($r('app.string.Bind_SelectionMenu'))
    // [EndExclude Bind_SelectionMenu]
  }
  // [End Bind_SelectionMenu]
  // [Start Right_ClickTextCustomMenu]
  // $r('app.media.xxx')需要替换为开发者所需的图像资源文件
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
  // [End Right_ClickTextCustomMenu]
}
