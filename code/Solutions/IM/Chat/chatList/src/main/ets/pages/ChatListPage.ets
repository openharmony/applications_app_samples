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

const TAG: string = 'ChatList_ChatListDisplayView';

@Preview
@Component
export struct ChatListDisplayView {
  private chatList_Lazy = new ChatListData()
  private chatList_Array: Array<ChatModel> = new Array<ChatModel>()
  @StorageLink('lazy_for_each') lazy_for_each: boolean | undefined = AppStorage.get('lazy_for_each')
  @StorageLink('reusable') reusable: boolean | undefined = AppStorage.get('reusable')
  @StorageLink('list_cachedCount') list_cachedCount: boolean | undefined = AppStorage.get('list_cachedCount')
  @StorageLink('page_layout') page_layout: boolean | undefined = AppStorage.get('page_layout')

  @Builder
  chatViewBuilder(msg: ChatModel) {
    // reusable component
    if (this.reusable) {
      ReusableChatView({ chatItem: msg })
        .reuseId(msg.user.userId)
    } else {
      ChatView({ chatItem: msg })
    }
  }

  @Builder
  OptChatViewBuilder(msg: ChatModel) {
    // reusable component
    if (this.reusable) {
      ReusableOptLayoutChatView({ chatItem: msg })
        .reuseId(msg.user.userId)
    } else {
      OptLayoutChatView({ chatItem: msg })
    }
  }

  build() {
    List() {
      ListItem() {
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Text($r("app.string.search"))
              .fontSize(18)
              .fontColor("#999999")
          }
          .id('search')
          .backgroundColor(Color.White)
          .height("100%")
          .width("100%")
          .borderRadius(4)
        }
        .height(50)
        .width("100%")
        .backgroundColor("#eeeeee")
        .padding({ top: 2, left: 10, right: 10, bottom: 13 })
      }

      // lazy for each
      if (this.lazy_for_each) {
        LazyForEach(this.chatList_Lazy, (msg: ChatModel) => {
          ListItem() {
            // 页面布局优化
            if (this.page_layout) {
              this.OptChatViewBuilder(msg)
            }
            else {
              this.chatViewBuilder(msg)
            }
          }
        }, (msg: ChatModel) => msg.user.userId)
      }
      else {
        ForEach(this.chatList_Array, (msg: ChatModel) => {
          ListItem() {
            // 页面布局优化
            if (this.page_layout) {
              this.OptChatViewBuilder(msg)
            }
            else {
              this.chatViewBuilder(msg)
            }
          }
        }, (msg: ChatModel) => msg.user.userId)
      }
    }
    .backgroundColor(Color.White)
    .listDirection(Axis.Vertical)
    .divider({ strokeWidth: 1, color: "#f3f3f3", startMargin: 80, endMargin: 0 })
    .height('92%')
    .width('100%')
    .onScrollIndex((firstIndex: number) => {

    })
    .onTouch((event?: TouchEvent) => {
    })
    .cachedCount(this.list_cachedCount ? Constants.CACHED_COUNT : 0) // 缓存列表数量
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToAppear');
    await makeDataLocal(this.chatList_Lazy);
    await makeDataList(this.chatList_Array);
  }
}
