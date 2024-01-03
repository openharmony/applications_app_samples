/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { TrendsData } from '../model/TrendsDataSource';
import { makeDataLocal } from '../model/DataFactory';
import { Trends } from '../model/BaseMsg';
import { TrendsItem } from '../commonComponent/TrendsItem';
import Constants from '../utils/Constants';

@Component
export struct MainView {
  // 初始化tab下标
  @State currentTabIndex: number = 0;
  // 初始化断点值
  @StorageLink('currentBreakpoint') currentBreakpoint: string = 'sm';

  // 设置tabBar样式的位置、未选中图片、选中图片及文字显示的参数
  @Builder
  TabBuilder(text: Resource, index: number) {
    Column() {
      Text(text)
        .fontSize(this.currentTabIndex === index ? $r('app.integer.layout_size_24') : $r('app.integer.layout_size_18'))
        .fontWeight(this.currentTabIndex === index ? 700 : 500)
        .fontColor(this.currentTabIndex === index ? Color.Black : $r('app.color.font_color_datetime'))
    }
    .margin({ right: 21 })
  }

  build() {
    Column() {
      // 标题
      Row() {
        Row() {
          this.TabBuilder($r('app.string.care_title'), Constants.TAB_INDEX_0)
          this.TabBuilder($r('app.string.recommend'), Constants.TAB_INDEX_1)
        }

        Row() {
          Image($r('app.media.search'))
            .width($r('app.integer.layout_size_24'))
            .height($r('app.integer.layout_size_24'))
        }
      }
      .height(56)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ right: $r('app.integer.layout_size_12'), left: $r('app.integer.layout_size_12') })


      // 首页动态列表
      TrensListComp()
      Image($r('app.media.add'))
        .width($r('app.integer.layout_size_48'))
        .height($r('app.integer.layout_size_48'))
        .position({
          x: this.currentBreakpoint === 'sm' ? $r('app.integer.layout_size_354') : $r('app.integer.layout_size_364'),
          y: '90%'
        })
    }
    .width('90%')
  }
}

@Component
struct TrensListComp {
  @State trendsData: TrendsData = new TrendsData();

  async aboutToAppear() {
    await makeDataLocal(this.trendsData);
  }

  build() {
    List() {
      LazyForEach(this.trendsData, (item: Trends, index: number) => {
        ListItem() {
          TrendsItem({ trendsItemData: item })
            .onClick(() => {
              router.pushUrl({ url: 'pages/CommentDetailPage', params: { trendsData: item, isDetailPage: false } })
            })
        }
      })
    }.width('100%')
    .cachedCount(4)
  }
}