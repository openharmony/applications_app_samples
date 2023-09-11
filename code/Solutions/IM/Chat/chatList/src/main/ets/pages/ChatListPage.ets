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

import { makeDataLocal, makeDataList } from '../utils/DataFactory';
import Constants from '../utils/Constants';
import { ChatModel } from '../viewModel/MsgBase';
import { ChatListData } from '../viewModel/ChatListDataSource';
import { ChatView, ReusableChatView } from '../view/ChatView';
import { OptLayoutChatView, ReusableOptLayoutChatView } from '../view/OptLayoutChatView';
import Logger from '../utils/Logger';

const TAG: string = 'ChatListDisplayView';
// 搜索框中搜索栏的ID
const ID_SEARCH: string = "search";
// 删除item后，下方的item顶上来的动画的播放时间
const DELETE_ANIMATION_DURATION: number = 500;

class Message {
  chatItem: ChatModel;

  constructor(chatItem: ChatModel) {
    this.chatItem = chatItem;
  }
}

@Preview
@Component
export struct ChatListDisplayView {
  // 懒加载的数据列表
  private chatListLazy = new ChatListData();
  // 普通加载的数据列表
  @State chatListArray: Array<ChatModel> = new Array<ChatModel>();
  // 是否使用懒加载
  @StorageLink('lazy_for_each') lazyForEach: boolean | undefined = AppStorage.get('lazy_for_each');
  // 是否复用列表中的子组件
  @StorageLink('reusable') reusable: boolean | undefined = AppStorage.get('reusable');
  // 列表数据是否缓存
  @StorageLink('list_cached_count') listCachedCount: boolean | undefined = AppStorage.get('list_cached_count');
  // 是否使用布局优化
  @StorageLink('page_layout') pageLayout: boolean | undefined = AppStorage.get('page_layout');

  // 非布局优化的列表item加载数据
  @Builder
  chatViewBuilder(msg: ChatModel) {
    // reusable component
    if (this.reusable) {
      ReusableChatView(new Message(msg))
        .reuseId(msg.user.userId)
    } else {
      ChatView(new Message(msg))
    }
  }

  // 布局优化的列表item加载数据
  @Builder
  OptChatViewBuilder(msg: ChatModel) {
    // reusable component
    if (this.reusable) {
      ReusableOptLayoutChatView(new Message(msg))
        .reuseId(msg.user.userId)
    } else {
      OptLayoutChatView(new Message(msg))
    }
  }

  // List的item左划时显示的删除按钮
  @Builder
  deleteAction(msg: ChatModel) {
    Row() {
      Text($r('app.string.delete'))
        .onClick(() => {
          animateTo({ duration: DELETE_ANIMATION_DURATION }, () => {
            if (this.lazyForEach) {
              this.chatListLazy.deleteData(msg);
            } else {
              let index = this.chatListArray.indexOf(msg);
              this.chatListArray.splice(index, 1);
            }
          })
        })
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .fontSize($r('app.integer.chat_list_delete_font_size'))
        .width($r('app.integer.chat_list_delete_width'))
        .height($r('app.integer.chat_list_delete_height'))
        .textAlign(TextAlign.Center)
    }.justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    List() {
      ListItem() {
        // 搜索栏
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Text($r("app.string.search"))
              .fontSize($r('app.integer.search_font_size'))
              .fontColor($r('app.color.search_font_color'))
          }
          .id(ID_SEARCH)
          .backgroundColor(Color.White)
          .height($r('app.string.layout_100'))
          .width($r('app.string.layout_100'))
          .borderRadius($r('app.integer.search_border_radius'))
        }
        .height($r('app.integer.search_outline_height'))
        .width($r('app.string.layout_100'))
        .backgroundColor($r('app.color.search_outline_background_color'))
        .padding({
          top: $r('app.integer.search_outline_padding_top'),
          left: $r('app.integer.search_outline_padding_left'),
          right: $r('app.integer.search_outline_padding_right'),
          bottom: $r('app.integer.search_outline_padding_bottom')
        })
      }

      if (this.lazyForEach) {
        // 懒加载加载数据
        LazyForEach(this.chatListLazy, (msg: ChatModel) => {
          ListItem() {
            if (this.pageLayout) {
              // 使用布局优化时加载的item
              this.OptChatViewBuilder(msg);
            } else {
              // 不使用布局优化时加载的item
              this.chatViewBuilder(msg);
            }
          }
          .transition(TransitionEffect.OPACITY) // 删除item后，List显示的最后一个item顶上来的动画
          .swipeAction({ // 用于设置ListItem的划出组件，end是ListItem向左划动时item右边的组件（List垂直布局时）或ListItem向上划动时item下方的组件（List水平布局时）
            end: this.deleteAction(msg),
          })
        }, (msg: ChatModel) => msg.user.userId)
      } else {
        ForEach(this.chatListArray, (msg: ChatModel) => {
          ListItem() {
            if (this.pageLayout) {
              // 使用布局优化时加载的item
              this.OptChatViewBuilder(msg);
            } else {
              // 不使用布局优化时加载的item
              this.chatViewBuilder(msg);
            }
          }
          .transition(TransitionEffect.OPACITY) // 删除item后，List显示的最后一个item顶上来的动画
          .swipeAction({ // 用于设置ListItem的划出组件，end是ListItem向左划动时item右边的组件（List垂直布局时）或ListItem向上划动时item下方的组件（List水平布局时）
            end: this.deleteAction(msg),
          })
        }, (msg: ChatModel) => msg.user.userId)
      }
    }
    .backgroundColor(Color.White)
    .listDirection(Axis.Vertical)
    .divider({
      strokeWidth: $r('app.integer.chat_list_divider_stroke_width'),
      color: $r('app.color.chat_list_divider_color'),
      startMargin: $r('app.integer.chat_list_divider_start_margin'),
      endMargin: $r('app.integer.chat_list_divider_end_margin')
    })
    .height($r('app.string.layout_92'))
    .width($r('app.string.layout_100'))
    .cachedCount(this.listCachedCount ? Constants.CACHED_COUNT : Constants.CACHED_COUNT_0) // 缓存列表数量
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, "ChatListPage aboutToAppear");
    await makeDataLocal(this.chatListLazy);
    await makeDataList(this.chatListArray);
  }
}
