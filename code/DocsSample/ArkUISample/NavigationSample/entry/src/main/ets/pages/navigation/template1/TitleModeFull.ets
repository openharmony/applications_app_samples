/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Entry
@Component
struct TitleModeFull {
  private arr: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  @State currentIndex: number = 0;

  @Builder
  NavigationTitle() {
    Column() {
      // $r('app.string.mainTitle')需要替换为开发者所需的字符串资源文件
      Text($r('app.string.mainTitle'))
        .fontColor('#182431')
        .fontSize(30)
        .lineHeight(41)
        .margin({ top: 24, left: 18 })
    }.alignItems(HorizontalAlign.Start)
  }

  @Builder
  NavigationMenus() {
    Row() {
      Image('resources/base/media/ic_public_search.svg')
        .width(24)
        .height(24)
      Image('resources/base/media/ic_public_add.svg')
        .width(24)
        .height(24)
        .margin({ left: 24 })
      Image('resources/base/media/ic_public_more.svg')
        .width(24)
        .height(24)
        .margin({ left: 24 })
    }
    .margin({ top: 12, right: 24})
  }

  build() {
    Column() {
      // [Start NavigationTitleModeFUll]
      Navigation() {
        // [StartExclude NavigationTitleModeFUll]
        TextInput({ placeholder: 'search...' })
          .width('90%')
          .height(40)
          .backgroundColor('#FFFFFF')
        // [EndExclude NavigationTitleModeFUll]
      }
      .titleMode(NavigationTitleMode.Full)
      // [End NavigationTitleModeFUll]
      .title(this.NavigationTitle)
      .menus(this.NavigationMenus)
      .toolbarConfiguration([
        {
          value: $r('app.string.navigation_toolbar_add'),
          icon: $r('app.media.ic_public_highlightsed')
        },
        {
          value: $r('app.string.navigation_toolbar_app'),
          icon: $r('app.media.ic_public_highlights')
        },
        {
          value: $r('app.string.navigation_toolbar_collect'),
          icon: $r('app.media.ic_public_highlights')
        }
      ])
      .hideTitleBar(false)
      .hideToolBar(false)
      .onTitleModeChange((titleModel: NavigationTitleMode) => {
      })
    }.width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}