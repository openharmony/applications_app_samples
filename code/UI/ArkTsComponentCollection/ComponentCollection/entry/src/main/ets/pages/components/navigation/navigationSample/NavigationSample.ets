/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import router from '@ohos.router';

@Entry
@Component
struct NavigationSample {
  private pages: PageInfo[] = [
    { name: 'navigation_basic_title', url: 'pages/components/navigation/navigationSample/NavigationBasic' },
    { name: 'navigation_list_expand_title', url: 'pages/components/navigation/navigationSample/ListExpandSafeArea' },
    { name: 'navigation_router_title', url: 'pages/components/navigation/navigationSample/NavigationRouter' },
    { name: 'navigation_split_title', url: 'pages/components/navigation/navigationSample/NavigationSplit' },
    { name: 'navigation_bindsheet_title', url: 'pages/components/navigation/navigationSample/BindSheetSafeArea' },
    { name: 'navigation_sidebar_title', url: 'pages/components/navigation/navigationSample/NavigationSideBar' },
    { name: 'navigation_replace_title', url: 'pages/components/navigation/navigationSample/NavigationReplace' },
    { name: 'navigation_hidebar_title', url: 'pages/components/navigation/navigationSample/NavigationHideBar' },
    { name: 'navigation_safearea_title', url: 'pages/components/navigation/navigationSample/NavigationFullSafeArea' },
    { name: 'navigation_expand_title', url: 'pages/components/navigation/navigationSample/NavigationExpandSafeArea' }
  ];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_title') });
      Column() {
        ForEach(this.pages, (item: PageInfo) => {
          Button($r(`app.string.${item.name}`))
            .width('90%')
            .height(40)
            .backgroundColor('#007DFF')
            .borderRadius(20)
            .fontSize(16)
            .fontWeight(500)
            .fontColor($r('app.color.white'))
            .margin({ top: 12 })
            .onClick(() => {
              router.pushUrl({ url: item.url })
            })
        });
      }
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}

class PageInfo {
  name: string = '';
  url: string = '';
}