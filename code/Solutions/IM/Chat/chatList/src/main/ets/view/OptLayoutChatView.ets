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
import Logger from '../utils/Logger';
import { ChatModel } from '../viewModel/MsgBase';
import PageConstants from '../utils/PageConstants';

const TAG: string = 'ChatList_ChatView';

/**
 * 可复用且优化布局的聊天页面组件
 */
@Reusable
@Component
struct ReusableOptLayoutChatView {
  @State chatItem: ChatModel = undefined;

  aboutToReuse(params) {
    this.chatItem = params.chatItem;
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
  private chatItem: ChatModel;
  @StorageLink('img_syncLoad') img_syncLoad: boolean = AppStorage.get('img_syncLoad');

  build() {
    RelativeContainer() {
      Image(this.chatItem.user.userImage)
        .width($r('app.integer.layout_48'))
        .height($r('app.integer.layout_48'))
        .borderRadius($r('app.integer.layout_5'))
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .syncLoad(this.img_syncLoad ? true : false)
        .id('figure')

      if (this.chatItem.unreadMsgCount > 0) { // 红点消息大于0条时渲染红点
        Text(`${this.chatItem.unreadMsgCount}`)
          .borderRadius($r('app.integer.layout_10'))
          .width($r('app.integer.layout_20'))
          .height($r('app.integer.layout_20'))
          .backgroundColor($r('app.color.unread_msg_tip'))
          .fontSize($r('app.integer.text_font_12'))
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          .margin({ top: $r('app.integer.layout_minus_8'), left: $r('app.integer.layout_minus_38') })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .opacity(this.chatItem.unreadMsgCount > 0 ? 1 : 0)
          .id('badge')
      }

      Text(this.chatItem.user.userName)
        .fontColor(Color.Black)
        .fontSize($r('app.integer.text_font_16'))
        .font({ weight: 450 })
        .margin({ top: $r('app.integer.layout_5'), left: $r('app.integer.layout_58') })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('user')

      Text(this.chatItem.lastTime)
        .fontSize($r('app.integer.text_font_12'))
        .fontColor($r('app.color.chat_view_text_color'))
        .maxLines(1)
        .textAlign(TextAlign.End)
        .margin({ top: $r('app.integer.layout_5'), right: $r('app.integer.layout_5') })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id('time')
      Text(this.chatItem.lastMsg)
        .fontColor($r('app.color.chat_view_text_color'))
        .fontSize($r('app.integer.text_font_14'))
        .maxLines(1)
        .margin({ top: $r('app.integer.layout_30'), left: $r('app.integer.layout_58') })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('msg')
    }
    .width($r('app.string.layout_100_percent'))
    .height($r('app.integer.layout_70'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.integer.layout_15'),
      right: $r('app.integer.layout_10'),
      top: $r('app.integer.layout_10'),
      bottom: $r('app.integer.layout_10')
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