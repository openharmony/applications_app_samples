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

import Logger from '../utils/Logger';
import { ChatModel, ChatContact } from '../viewmodel/MsgBase';
import router from '@ohos.router';
import PageConstants from '../utils/PageConstants';

const TAG: string = 'ChatList_ChatView';

/**
 * 可复用且优化布局的聊天页面组件
 */
@Reusable
@Component
struct ReusableOptLayoutChatView {
  @State chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0);

  aboutToReuse(params: Record<string, Object>): void {
    this.chatItem = params.chatItem as ChatModel;
    Logger.info(TAG, 'aboutToReuse=' + this.chatItem.toString());
  }

  build() {
    OptLayoutChatView({ chatItem: this.chatItem });
  }
}

/**
 * 优化布局的聊天页面组件
 */
@Preview
@Component
struct OptLayoutChatView {
  @State chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0);
  @StorageLink('image_sync_load') imageSyncLoad: boolean | undefined = AppStorage.get('image_sync_load');

  aboutToReuse(params: Record<string, Object>): void {
    this.chatItem = params.chatItem as ChatModel;
  }

  build() {
    RelativeContainer() {
      Image(this.chatItem.user.userImage)
        .width($r('app.integer.opt_layout_chat_view_profile_picture_width'))
        .height($r('app.integer.opt_layout_chat_view_profile_picture_height'))
        .borderRadius($r('app.integer.opt_layout_chat_view_profile_picture_radius'))
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .syncLoad(this.imageSyncLoad ? true : false)
        .id("figure")

      if (this.chatItem.unreadMsgCount > 0) { // 红点消息大于0条时渲染红点
        Row() {
          Text(`${this.chatItem.unreadMsgCount}`)
            .borderRadius($r('app.integer.layout_8'))
            .constraintSize({minWidth: $r('app.integer.opt_layout_chat_view_red_dot_width')})
            .height($r('app.integer.opt_layout_chat_view_red_dot_height'))
            .backgroundColor($r('app.color.unread_msg_tip'))
            .fontSize($r('app.integer.text_font_10'))
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .borderRadius($r('app.integer.layout_10'))
        .margin({ top: $r('app.integer.layout_minus_8'), left: $r('app.integer.layout_24') })
        .constraintSize({minWidth: $r('app.integer.opt_layout_chat_view_red_dot_container_width')})
        .height($r('app.integer.opt_layout_chat_view_red_dot_container_height'))
        .backgroundColor(Color.White)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .opacity(this.chatItem.unreadMsgCount > 0 ? 1 : 0)
        .id('badge')
      }

      Text(this.chatItem.user.userName)
        .fontColor($r('app.color.top_bar_font_color'))
        .fontSize($r('app.integer.opt_layout_chat_view_user_name_font_size'))
        .lineHeight($r('app.integer.layout_22'))
        .font({ weight: 450 })
        .margin({ top: $r('app.integer.layout_0'), left: $r('app.integer.chat_view_row_height') })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('user')

      Text(this.chatItem.lastTime)
        .fontSize($r('app.integer.opt_layout_chat_view_item_padding_top'))
        .fontColor($r('app.string.search_inline_border_color'))
        .maxLines(1)
        .textAlign(TextAlign.End)
        .margin({ top: $r('app.integer.layout_0'), right: $r('app.integer.layout_0') })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id('time')
      Text(this.chatItem.lastMsg)
        .fontColor($r('app.string.search_inline_border_color'))
        .fontSize($r('app.integer.text_font_14'))
        .lineHeight($r('app.integer.layout_19'))
        .maxLines(1)
        .margin({ top: $r('app.integer.layout_24'), left: $r('app.integer.chat_view_row_height') })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('msg')
    }
    .width($r('app.string.layout_100_percent'))
    .height($r('app.integer.opt_layout_chat_view_item_height'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.integer.opt_layout_chat_view_item_padding_left'),
      right: $r('app.integer.opt_layout_chat_view_item_padding_right'),
      top: $r('app.integer.opt_layout_chat_view_item_padding_top'),
      bottom: $r('app.integer.opt_layout_chat_view_item_padding_bottom')
    })
    .onClick(() => {
      router.pushUrl({
        url: PageConstants.DETAIL_PAGE,
        params: {
          chatName: this.chatItem.user.userName,
          chatId: this.chatItem.user.userId,
          chatImg: this.chatItem.user.userImage,
          lastMsg: this.chatItem.lastMsg
        }
      }, (err) => {
        if (err) {
          Logger.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        Logger.info('pushUrl success');
      })
    })

  }
}

export { OptLayoutChatView, ReusableOptLayoutChatView };