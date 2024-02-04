/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Entry
@Component
struct NavigationBasic {
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  @State currentIndex: number = 0;
  @State Build: Array<BuildType> = [
    {
      text: 'add',
      num: 0
    },
    {
      text: 'app',
      num: 1
    },
    {
      text: 'collect',
      num: 2
    }
  ];

  @Builder NavigationTitle() {
    Column() {
      Text('Title')
        .fontColor('#182431')
        .fontSize(30)
        .lineHeight(41)
        .fontWeight(700)
      Text('subtitle')
        .fontColor('#182431')
        .fontSize(14)
        .lineHeight(19)
        .opacity(0.4)
        .margin({ top: 2, bottom: 20 })
    }.alignItems(HorizontalAlign.Start)
  }

  @Builder NavigationMenus() {
    Row() {
      Image($r('app.media.icon'))
        .width(24)
        .height(24)
      Image($r('app.media.icon'))
        .width(24)
        .height(24)
        .margin({ left: 24 })
      Image($r('app.media.icon'))
        .width(24)
        .height(24)
        .margin({ left: 24 })
    }
  }

  @Builder NavigationToolbar() {
    Row() {
      ForEach(this.Build, (item: BuildType) => {
        Column() {
          Image(this.currentIndex === item.num ? $r('app.media.icon') : $r('app.media.ic_pen'))
            .width(24)
            .height(24)
          Text(item.text)
            .fontColor(this.currentIndex === item.num ? '#007DFF' : '#182431')
            .fontSize(10)
            .lineHeight(14)
            .fontWeight(500)
            .margin({ top: 3 })
        }.width(104).height(56)
        .onClick(() => {
          this.currentIndex = item.num
        })
      })
    }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_basic_title') })
      Column() {
        Navigation() {
          TextInput({ placeholder: 'search...' })
            .width('90%')
            .height(40)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
            .enableKeyboardOnFocus(false)

          List({ space: 12, initialIndex: 0 }) {
            ForEach(this.arr, (item: number) => {
              ListItem() {
                Text('' + item)
                  .width('90%')
                  .height(72)
                  .backgroundColor('#FFFFFF')
                  .borderRadius(24)
                  .fontSize(16)
                  .fontWeight(500)
                  .textAlign(TextAlign.Center)
              }.editable(true)
            }, (item: number) => item.toString())
          }
          .height(324)
          .width('100%')
          .margin({ top: 12, left: '10%' })
        }
        .title(this.NavigationTitle)
        .menus(this.NavigationMenus)
        .titleMode(NavigationTitleMode.Full)
        .toolbarConfiguration(this.NavigationToolbar)
        .hideTitleBar(false)
        .hideToolBar(false)
        .mode(NavigationMode.Stack)
        .onTitleModeChange((titleModel: NavigationTitleMode) => {
          console.info('titleMode' + titleModel)
        })
        .width('100%')
        .height('90%')
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}

class BuildType {
  text: string = '';
  num: number = 0;
}