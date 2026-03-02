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

import avMusicTemplate from '@ohos.multimedia.avMusicTemplate';
import { MainLeftComponent } from '../components/MainLeftComponent';
import { MineContentComponent } from '../components/MineContentComponent';
import { TabContentComponent } from '../components/TabContentComponent';
import { ControllerManager } from '../manager/ControllerManager';

const TAG: string = 'Index';
export const TAB_ID_MINE: string = 'mine';

@Entry
@Component
struct Index {
  @State tabs: avMusicTemplate.MediaTab[] = []
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  build() {
    Row() {
      // 左侧
      MainLeftComponent({
        currentIndex: $currentIndex,
        tabs: this.tabs
      });

      // 右侧
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        ForEach(this.tabs, (item: avMusicTemplate.MediaTab) => {
          TabContent() {
            if (this.tabs && this.tabs.length > 0) {
              if (item.tabId === TAB_ID_MINE) {
                MineContentComponent()
              } else {
                TabContentComponent({ tabId: item.tabId });
              }
            }
          }
        });
      }
      .barHeight('0vp')
      .layoutWeight(1)
      .vertical(true)
      .scrollable(false)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .height('100%')
    .width('100%')
  }

  aboutToAppear(): void {
    this.loadData()
  }

  private async loadData() {
    try {
      let tabs: avMusicTemplate.MediaTab[] | undefined = await ControllerManager.getInstance().queryMainTabs();

      // 模拟tab数据
      tabs = this.createMainTabs();
      if (!tabs) {
        console.warn(TAG, 'loadData tabs is undefined')
        return;
      }
      this.tabs = tabs;
    } catch (e) {
      console.error(TAG, `updateData, queryMainTabs fail, errCode: ${e?.message}`)
    }
  }

  private createMainTabs(): avMusicTemplate.MediaTab[] {
    let homeTab: avMusicTemplate.MediaTab = {
      tabId: 'home',
      tabName: '首页'
    };
    let mineTab: avMusicTemplate.MediaTab = {
      tabId: TAB_ID_MINE,
      tabName: '我的'
    };
    let mainTabs: avMusicTemplate.MediaTab[] = [homeTab, mineTab];
    return mainTabs;
  }
}