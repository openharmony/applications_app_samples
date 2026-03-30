/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

import { avMusicTemplate } from '@kit.AVSessionKit';
import { ControllerManager } from '../manager/ControllerManager';

@Component
export struct MainLeftComponent {
  private scroller: Scroller = new Scroller();
  @State tabs: avMusicTemplate.MediaTab[] = []
  @Link currentIndex: number;

  build() {
    Column() {
      // 搜索。
      Search({ placeholder: '搜索' })
        .enabled(true)
        .height('24vp')
        .searchIcon({
          size: '24vp',
          src: $r('sys.symbol.search_things')
        })
        .margin({ left: '17vp', right: '17vp' })
        .onClick(() => {

        });

      List({ scroller: this.scroller }) {
        ForEach(this.tabs, (item: avMusicTemplate.MediaTab, index?: number) => {
          ListItem() {
            Row() {
              Image(!item.tabIcon ? item.tabIcon : $r('app.media.house_fill'))
                .width('24vp')
                .height('24vp')
                .fillColor(this.currentIndex === index ? '#FF1949' : $r('sys.color.icon_secondary'))

              Text(item.tabName)
                .margin({
                  left: '12vp'
                })
                .fontSize($r('sys.float.Body_L'))
                .fontColor(this.currentIndex === index ? '#FF1949' : $r('sys.color.font_secondary'))
                .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
            }
            .borderRadius('16vp')
            .padding({
              left: '12vp',
              right: '12vp'
            })
            .height('56vp')
            .width('168vp')
            .backgroundColor(this.currentIndex === index ? '#FFFFFF' : '')
            .onClick(() => {
              this.currentIndex = index ?? 0;
              ControllerManager.getInstance().queryMediaTabContent(item.tabId);
            })
          }
        }, (item: avMusicTemplate.MediaTab, index: number) => JSON.stringify(item) + index)
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .margin({
        top: '12vp',
        left: '12vp',
        right: '12vp'
      });

    }
    .alignItems(HorizontalAlign.Start)
    .width('200vp')
    .height('100%');
  }
}