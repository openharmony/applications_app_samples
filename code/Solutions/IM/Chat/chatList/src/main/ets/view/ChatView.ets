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

import { ChatContact, ChatModel } from '../viewModel/MsgBase';
import Logger from '../utils/Logger';
import router from '@ohos.router';

const TAG: string = 'ChatList_ChatView';

@Reusable
@Component
struct ReusableChatView {
  @State chatItem: ChatModel = new ChatModel(new ChatContact('', ''), '', '', 0);

  aboutToReuse(params: Record<string, Object>) {
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
  @StorageLink('imageSyncLoad') imageSyncLoad: boolean | undefined = AppStorage.get('imageSyncLoad');

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.TopEnd }) {
          // 用户头像
          Image(this.chatItem.user.userImage)
            .width(48)
            .height(48)
            .margin({ left: 20 })
            .borderRadius(5)
            .autoResize(false)
            // 图片同步加载
            .syncLoad(this.imageSyncLoad ? true : false)

          // 红点消息大于0条时渲染红点
          if (this.chatItem.unreadMsgCount > 0){
            Text(`${this.chatItem.unreadMsgCount}`)
              .borderRadius(10)
              .width(20)
              .height(20)
              .backgroundColor("#ea6055")
              .fontSize(12)
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .margin({ top: -10, right: -10 })
          }
        }
      }
      .layoutWeight(1)
      .padding({ right: 12 })

      Column() {
        Text(this.chatItem.user.userName)
          .fontColor(Color.Black)
          .fontSize(16)
          .margin({ bottom: 3 })
        Text(this.chatItem.lastMsg)
          .fontColor("#999999")
          .maxLines(1)
          .fontSize(14)
          .margin({ top: 5 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(5)

      Column() {
        Text(this.chatItem.lastTime)
          .width(50)
          .fontColor("#999999")
          .textAlign(TextAlign.End)
          .maxLines(1)
          .fontSize(12)
          .margin({ right: 6, bottom: 27 })
      }
      .padding({ left: 15 })
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)
    }
    .width("100%")
    .height(70)
    .padding({ left: 8, right: 10, top: 10, bottom: 10 })
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

export { ChatView, ReusableChatView }