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

import Logger from '../utils/Logger'
import { ChatModel, ChatContact } from '../viewModel/MsgBase'
import router from '@ohos.router'

const TAG: string = 'ChatList_ChatView'

@Reusable
@Component
struct ReusableOptLayoutChatView {
  @State chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0)

  aboutToReuse(params: Record<string, Object>) {
    this.chatItem = params.chatItem as ChatModel
    Logger.info(TAG, 'aboutToReuse=' + this.chatItem.toString())
  }

  build() {
    OptLayoutChatView({ chatItem: this.chatItem })
  }
}

@Preview
@Component
struct OptLayoutChatView {
  private chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0)
  @StorageLink('img_syncLoad') img_syncLoad: boolean | undefined = AppStorage.get('img_syncLoad')

  build() {
    RelativeContainer() {
      Image(this.chatItem.user.userImage)
        .width(48)
        .height(48)
        .borderRadius(5)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .syncLoad(this.img_syncLoad ? true : false)
        .id("figure")

      if (this.chatItem.unreadMsgCount > 0) { // 红点消息大于0条时渲染红点
        Text(`${this.chatItem.unreadMsgCount}`)
          .borderRadius(10)
          .width(20)
          .height(20)
          .backgroundColor("#ea6055")
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          .margin({ top: -8, left: 38 })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .opacity(this.chatItem.unreadMsgCount > 0 ? 1 : 0)
          .id("badge")
      }

      Text(this.chatItem.user.userName)
        .fontColor(Color.Black)
        .fontSize(16)
        .font({ weight: 450 })
        .margin({ top: 5, left: 58 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id("user")

      Text(this.chatItem.lastTime)
        .fontSize(12)
        .fontColor("#999999")
        .maxLines(1)
        .textAlign(TextAlign.End)
        .margin({ top: 5, right: 5 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id("time")
      Text(this.chatItem.lastMsg)
        .fontColor("#999999")
        .fontSize(14)
        .maxLines(1)
        .margin({ top: 30, left: 58 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id("msg")
    }
    .width("100%")
    .height(70)
    .backgroundColor(Color.White)
    .padding({ left: 15, right: 10, top: 10, bottom: 10 })
    .onClick((event?: ClickEvent) => {
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

export { OptLayoutChatView, ReusableOptLayoutChatView }