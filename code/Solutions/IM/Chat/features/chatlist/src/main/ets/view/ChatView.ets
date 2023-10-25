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

import { ChatContact, ChatModel } from '../viewmodel/MsgBase';
import Logger from '../utils/Logger';
import router from '@ohos.router';

const TAG: string = 'ChatList_ChatView';

@Reusable
@Component
struct ReusableChatView {
  // 聊天列表单个项
  @State chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0);

  aboutToReuse(params: Record<string, Object>): void {
    this.chatItem = params.chatItem as ChatModel;
    Logger.info(TAG, 'aboutToReuse=' + this.chatItem.toString());
  }

  build() {
    ChatView({ chatItem: this.chatItem })
  }
}

@Component
struct ChatView {
  private chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0);
  @StorageLink('image_sync_load') imageSyncLoad: boolean | undefined = AppStorage.get('image_sync_load');

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.TopEnd }) {
          // 用户头像
          Image(this.chatItem.user.userImage)
            .width($r('app.integer.chat_view_image_width'))
            .height($r('app.integer.chat_view_image_height'))
            .margin({ left: $r('app.integer.chat_view_image_margin_left') })
            .borderRadius($r('app.integer.chat_view_image_border_radius'))
            .autoResize(false)
            // 图片同步加载
            .syncLoad(this.imageSyncLoad ? true : false)

          // 红点消息大于0条时渲染红点
          if (this.chatItem.unreadMsgCount > 0){
            Text(`${this.chatItem.unreadMsgCount}`)
              .borderRadius($r('app.integer.chat_view_unread_border_radius'))
              .width($r('app.integer.chat_view_unread_width'))
              .height($r('app.integer.chat_view_unread_height'))
              .backgroundColor($r('app.color.unread_msg'))
              .fontSize($r('app.integer.chat_view_unread_font_size'))
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .margin({ top: $r('app.integer.chat_view_unread_margin_top'), right: $r('app.integer.chat_view_unread_margin_right') })
          }
        }
      }
      .layoutWeight(1)
      .padding({ right: $r('app.integer.chat_view_col_padding_right') })

      // 对方用户名
      Column() {
        Text(this.chatItem.user.userName)
          .fontColor(Color.Black)
          .fontSize($r('app.integer.chat_view_user_name_font_size'))
          .margin({ bottom: $r('app.integer.chat_view_user_name_margin_bottom') })
        Text(this.chatItem.lastMsg)
          .fontColor($r('app.color.last_msg'))
          .maxLines(1)
          .fontSize($r('app.integer.chat_view_user_msg_font_size'))
          .margin({ top: $r('app.integer.chat_view_user_msg_margin_top') })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(5)

      // 最后一条消息时间
      Column() {
        Text(this.chatItem.lastTime)
          .width($r('app.integer.chat_view_time_width'))
          .fontColor($r('app.color.last_msg'))
          .textAlign(TextAlign.End)
          .maxLines(1)
          .fontSize($r('app.integer.chat_view_time_font_size'))
          .margin({ right: $r('app.integer.chat_view_time_margin_right'), bottom: $r('app.integer.chat_view_time_margin_bottom') })
      }
      .padding({ left: $r('app.integer.chat_view_time_col_padding_left') })
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)
    }
    .width($r('app.string.layout_100'))
    .height($r('app.integer.chat_view_row_height'))
    .padding({ left: $r('app.integer.chat_view_row_padding_left'), right: $r('app.integer.chat_view_row_padding_right'), top: $r('app.integer.chat_view_row_padding_top'), bottom: $r('app.integer.chat_view_row_padding_bottom') })
    .onClick(() => {
      // 进入聊天详情页
      router.pushUrl({
        url: 'pages/Detail',
        params: {
          chatName: this.chatItem.user.userName,
          chatId: this.chatItem.user.userId,
          chatImg: this.chatItem.user.userImage,
          lastMsg: this.chatItem.lastMsg
        }
      }, (err) => {
        if (err) {
          console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        console.info('pushUrl success');
      })
    })
  }
}

export { ChatView, ReusableChatView }