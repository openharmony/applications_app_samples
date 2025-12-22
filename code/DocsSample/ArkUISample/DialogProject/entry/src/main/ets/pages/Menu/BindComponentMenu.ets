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
// [Start bindComponent_menu]
@Entry
@Component
export struct BindComponentMenuExample {
  @Builder
  MenuBuilder() {
    Column() {
      Menu() {
        MenuItemGroup() {
          // 请将$r('app.media.app_icon')替换为实际资源文件
          MenuItem({ startIcon: $r('app.media.app_icon'), content: 'Select Mixed Menu 1', labelInfo: '' })
          MenuItem({ startIcon: $r('app.media.app_icon'), content: 'Select Mixed Menu 2', labelInfo: '' })
          MenuItem({ startIcon: $r('app.media.app_icon'), content: 'Select Mixed Menu 3', labelInfo: '' })
        }
      }
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text()
          .borderRadius(10)
          .width(200)
          .height(150)
          .borderWidth(1)
          .backgroundColor(Color.White)
          .borderColor(Color.Red)
          .margin({ top: 200, left: 125 })
          .bindContextMenu(this.MenuBuilder, ResponseType.RightClick, {
            anchorPosition: { x: 45, y: 50 },
          })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    // [StartExclude bindComponent_menu]
    // 请将$r('app.string.BindComponentMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"基于绑定组件指定位置弹出菜单"
    .title($r('app.string.BindComponentMenu_title'))
    // [EndExclude bindComponent_menu]
  }
}
// [End bindComponent_menu]