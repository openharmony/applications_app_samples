/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { NewsItem, NEWS_LIST_DATA } from '../model/NewsItemModel';
import { NewsListDataSource } from '../model/NewsListDataSource';
import { TabBarType } from '../model/TabBarModel';
import { CustomTabBar } from './CustomComponent';
import { XComponentVideo } from './XComponentVideo';
import { promptAction } from '@kit.ArkUI';

const CACHE_COUNT: number = 4; // 列表预加载数量
const BORDER_WIDTH: number = 1.5; // 搜索框线条宽度
const SEARCH_OPACITY: number = 0.6; // 搜索框透明度
const LIST_FRICTION: number = 0.6; // 搜索框的摩擦力
const VIDEO_LIST_LAYOUT_WEIGHT: number = 1; // 视频列表权重

/**
 * 功能描述: 利用onScrollIndex获取List显示区域内中间子组件索引值的能力来判断播放，利用懒加载场景会预加载List显示区域外cachedCount的内容的能力来实现视频连续播放的功能。
 *
 * 推荐场景:视频列表滑动到屏幕中间自动播放场景
 *
 * 核心组件:
 * 1. XComponentVideo
 *
 * 实现步骤：
 * 1.首先加载图片，使用Stack将Image覆盖在XComponent上，并使用visibility来控制图片的显示。
 * 2.使用LoadingProgress来表示视频正在加载中，当AVPlayer走到playing隐藏LoadingProgress。
 * 3.使用onScrollIndex来获取List显示区域内中间子组件索引值，使用该索引值和ListItem的index对比，二者一致播放视频。
 */
@Component
export struct VideoListAutoplayComponent {
  @State currentIndex: TabBarType = TabBarType.DISCOVER; // Tab组件当前选中index值
  private newsList: NewsListDataSource = new NewsListDataSource(); // 视频信息集合
  @Provide isLoading: boolean = true; // 视频是否加载中
  @State centerIndex: number = -1; // List显示区域内中间子组件索引值

  aboutToAppear(): void {
    // 将视频是信息推入空数组
    NEWS_LIST_DATA.forEach((news: NewsItem) => {
      this.newsList.pushData(news);
    })
  }

  build() {
    Column() {
      this.customSearch();
      this.lazyForEachListPage();
      CustomTabBar({ currentIndex: $currentIndex });
    }
    .height($r('app.string.video_list_autoplay_height'))
  }

  /**
   * 搜索视图
   */
  @Builder
  customSearch() {
    Row() {
      Image($r('app.media.video_list_autoplay_drawer_filled'))
        .width($r('app.integer.video_list_autoplay_custom_search_image'))
        .height($r('app.integer.video_list_autoplay_custom_search_image'))
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r('app.string.video_list_autoplay_toast_tips') });
        })
      Row() {
        Image($r('app.media.video_list_autoplay_input_search'))
          .width($r('app.integer.video_list_autoplay_custom_search_image'))
          .height($r('app.integer.video_list_autoplay_custom_search_image'))
        Text($r('app.string.video_list_autoplay_custom_search_text'))
          .width($r('app.integer.video_list_autoplay_custom_search_text_width'))
          .height($r('app.integer.video_list_autoplay_custom_search_text_height'))
          .fontSize($r('app.integer.video_list_autoplay_custom_search_text_font_size'))
          .padding({ left: $r('app.integer.video_list_autoplay_custom_search_text_padding_left') })
      }
      .onClick(() => {
        // 调用Toast显示提示:此样式仅为案例展示
        promptAction.showToast({ message: $r('app.string.video_list_autoplay_toast_tips') });
      })
      .backgroundColor($r('app.color.video_list_autoplay_custom_search_text_background_color'))
      .opacity(SEARCH_OPACITY)
      .padding({
        left: $r('app.integer.video_list_autoplay_custom_search_row_padding_left'),
        right: $r('app.integer.video_list_autoplay_custom_search_row_padding_left'),
        top: $r('app.integer.video_list_autoplay_custom_search_row_padding_top'),
        bottom: $r('app.integer.video_list_autoplay_custom_search_row_padding_top')
      })
      .borderRadius($r('app.integer.video_list_autoplay_custom_search_row_border_radius'))
      .border({ width: BORDER_WIDTH, color: $r('app.color.video_list_autoplay_custom_search_row_border_color') })

      Image($r('app.media.video_list_autoplay_search_things'))
        .width($r('app.integer.video_list_autoplay_custom_search_image'))
        .height($r('app.integer.video_list_autoplay_custom_search_image'))
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r('app.string.video_list_autoplay_toast_tips') });
        })
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .clip(false)
    .width($r('app.string.video_list_autoplay_custom_search_width'))
    .justifyContent(FlexAlign.SpaceAround)
  }

  /**
   * 视频列表视图
   */
  @Builder
  lazyForEachListPage() {
    Column() {
      List() {
        LazyForEach(this.newsList, (news: NewsItem, index: number) => {
          ListItem() {
            XComponentVideo({
              centerIndex: this.centerIndex,
              news: news,
              index: index
            })
          }
          .backgroundColor($r('app.color.video_list_autoplay_lazy_foreach_list_page_list_item_background_color'))
          .borderRadius($r('app.integer.video_list_autoplay_lazy_foreach_list_page_list_item_border_radius'))
          .margin({ bottom: $r('app.integer.video_list_autoplay_lazy_foreach_list_page_list_item_margin_bottom') })
        }, (item: string) => item)
      }
      // TODO：知识点：LazyForEach懒加载可以通过设置cachedCount来指定缓存数量，在设置cachedCount后，除屏幕内显示的ListItem组件外，还会预先将屏幕可视区外指定数量的列表项数据缓存。
      .cachedCount(CACHE_COUNT)
      .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
        this.centerIndex = centerIndex; // 获取List显示区域内中间子组件索引值
      })
      .listDirection(Axis.Vertical) // 排列方向
      .scrollBar(BarState.Off)
      .friction(LIST_FRICTION)
      .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
      .width($r('app.string.video_list_autoplay_lazy_foreach_list_page_list_width'))
    }
    .width($r('app.string.video_list_autoplay_lazy_foreach_list_page_width'))
    .height($r('app.string.video_list_autoplay_lazy_foreach_list_page_width'))
    .padding({ top: $r('app.integer.video_list_autoplay_lazy_foreach_list_page_list_padding_top') })
    .layoutWeight(VIDEO_LIST_LAYOUT_WEIGHT)
  }
}