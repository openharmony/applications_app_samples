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

import hiTraceMeter from '@ohos.hiTraceMeter';
import { makeDataLocal, makeDataList } from '../utils/DataFactory';
import Constants from '../utils/Constants';
import { ChatModel } from '../viewmodel/MsgBase';
import { ChatListData } from '../viewmodel/ChatListDataSource';
import { ChatView, ReusableChatView } from '../view/ChatView';
import { OptLayoutChatView, ReusableOptLayoutChatView } from '../view/OptLayoutChatView';
import Logger from '../utils/Logger';
import ChatListJsonData from '../utils/ChatListJsonData';

const TAG: string = 'ChatListDisplayView';
// 搜索框中搜索栏的ID
const ID_SEARCH: string = 'search';
// 删除item后，下方的item顶上来的动画的播放时间
const DELETE_ANIMATION_DURATION: number = 500;
const ABOUT_TO_APPEAR_TRACE: string = 'ChatListPage_AboutToAppear_HiTrace';
const ABOUT_TO_APPEAR_TRACE_ID: number = 3; // aboutToAppear 中使用的 taskId
const REUSE_ID: string = 'ChatListPage_ReuseId';

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
  controller: SearchController = new SearchController();

  // 非布局优化的列表item加载数据
  @Builder
  chatViewBuilder(msg: ChatModel) {
    // reusable component
    if (this.reusable) {
      ReusableChatView(new Message(msg))
        .reuseId(REUSE_ID)
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
        .reuseId(REUSE_ID)
    } else {
      OptLayoutChatView(new Message(msg))
    }
  }

  // List的item左划时显示的删除按钮
  @Builder
  deleteAction(msg: ChatModel) {
    Row() {
      Image(($r('app.media.icon_delete')))
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
        .width($r('app.integer.chat_list_delete_width'))
        .height($r('app.integer.chat_list_delete_height'))
    }
    .width($r('app.integer.chat_list_page_delete_row_width'))
    .height($r('app.string.layout_100'))
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Column() {
      // 搜索栏
      Row() {
        Search({ placeholder: $r("app.string.search_place_holder") })
          .enableKeyboardOnFocus(false)
          .placeholderFont({ size: $r('app.integer.search_font_size') })
          .searchIcon({ src: $r('app.media.search_svg'), size: $r('app.integer.search_svg_height') })
          .placeholderColor($r('app.string.search_inline_border_color'))
          .backgroundColor(Color.White)
          .height($r('app.integer.search_inline_height'))
          .margin({ left: $r('app.integer.search_inline_margin'), right: $r('app.integer.search_inline_margin') })
          .textFont({ size: $r('app.integer.search_font_size') })
          .border({
            width: $r('app.integer.search_inline_border_width'),
            color: $r('app.string.search_inline_border_color')
          })
          .borderRadius($r('app.integer.search_border_radius'))
          .id(ID_SEARCH)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height($r('app.integer.search_outline_height'))
      .width($r('app.string.layout_100'))
      .backgroundColor($r('app.color.search_outline_background_color'))

      List() {
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
        startMargin: $r('app.integer.chat_list_page_start_margin'),
        endMargin: $r('app.integer.opt_layout_chat_view_item_padding_right')
      })
      .height($r('app.string.layout_92'))
      .width($r('app.string.layout_100'))
      .cachedCount(this.listCachedCount ? Constants.CACHED_COUNT : Constants.CACHED_COUNT_0) // 缓存列表数量
    }
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, "ChatListPage aboutToAppear");
    hiTraceMeter.startTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
    this.controller.stopEditing();
    // 循环获取两个json文件，如若单个文件可能导致过大无法读取
    for (let i = 0; i < ChatListJsonData.CHAT_LIST_JSON_DATA.length; i++) {
      await makeDataLocal(this.chatListLazy, ChatListJsonData.CHAT_LIST_JSON_DATA[i]);
      await makeDataList(this.chatListArray, ChatListJsonData.CHAT_LIST_JSON_DATA[i]);
    }
    hiTraceMeter.finishTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
  }
}
