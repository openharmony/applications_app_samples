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

import { BasicDataSource } from '../viewModel/BasicDataSource';
import { MessageBase, ChatContact, TextMessage, ImageMessage, MessageBody } from '../viewModel/MsgBase';
import { getMessageListFromJSON } from '../utils/DataFactory';
import router from '@ohos.router';
import { ImgTextMessage, FileMessage } from '../viewModel/MsgBase';
import image from '@ohos.multimedia.image';
import Constants from '../utils/Constants';

@Preview
@Component
struct ChatDetailPage {
  @State msgLength: number = 0
  userMyself = new ChatContact('1', $r('app.string.myself'))
  userFriend = new ChatContact('2', $r('app.string.friend'))
  msg = new TextMessage($r('app.string.message1'))
  msg2 = new TextMessage($r('app.string.message2'))
  tdate = new Date()
  msgbody = new MessageBase('1', this.userMyself, this.userFriend, this.msg2, 1, this.tdate.getSeconds())
  @State keyboardStr: string = ''
  private chatDetailData = new ChatDetailData()
  private scroller: Scroller = new Scroller()
  @State imgFile: PixelMap | null = null
  @State wantId: number = 0
  @State fdImg: number = 0
  @State userMyselfName: string = ''
  @State userFriendName: string = ''
  @State listHeight: number = 0
  private params = router.getParams() as Record<string, Object>
  chatId: number = this.params.chatId as number
  chatName: string | Resource = this.params.chatName as string | Resource
  chatImg: string | Resource = this.params.chatImg as string | Resource
  lastMsg: string | Resource = this.params.lastMsg as string | Resource

  build() {
    Column() {
      Row() {
        Image($r('app.media.left'))
          .id('returnBtn')
          .height(23)
          .width(23)
          .margin({ top: 8 })
          .onClick(() => {
            router.back()
          })

        Text(this.chatName)
          .fontSize(19)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .margin({ top: 8, left: 40 })
        Stack({ alignContent: Alignment.Center }) {
          Text('···')
            .height(23)
            .width(50)
            .fontColor(Color.Black)
            .fontSize(30)
            .fontWeight(10)
        }
        .id('moreBtn')
      }
      .height(50)
      .width('100%')
      .backgroundColor($r('app.color.detail_return_background'))
      .padding({ left: 0, right: 10 })
      .justifyContent(FlexAlign.SpaceBetween)

      List({ scroller: this.scroller, initialIndex: this.msgLength - 1 }) {
        LazyForEach(this.chatDetailData, (msg: MessageBase) => {
          ListItem() {
            ChatItemView({ msg: msg, imgFile: $imgFile })
          }
        }, (msg: MessageBase) => msg.msgId)
      }
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: 2, color: $r('app.color.detail_divider') })
      .padding({ left: 10, right: 10, bottom: 10 })
      .layoutWeight(1)
      .width('100%')

      //底部输入框
      Row({ space: 5 }) {
        Image($r('app.media.chatting_setmode_voice'))
          .height(20)
          .width(20)
        TextInput({ placeholder: '', text: this.keyboardStr })
          .id('bottomTextInput')
          .height(40)
          .width('80%')
          .backgroundColor($r('app.color.detail_bottom_text_input_background'))
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.keyboardStr = value
          })
          .onSubmit((enterKey) => {
            this.tdate = new Date()
            let msg = new TextMessage(this.keyboardStr)
            let msgBody = new MessageBase(this.chatDetailData.totalCount()
              .toString(), this.userMyself, this.userFriend, msg, 1, this.tdate.getSeconds())
            this.chatDetailData.pushData(msgBody)
            this.msgLength = this.chatDetailData.totalCount()
            this.scroller.scrollToIndex(this.msgLength - 1)
            this.keyboardStr = ''
          })
        Image($r('app.media.chatting_expression'))
          .id('chatExpression')
          .height(20)
          .width(20)
          .onClick(() => {
            let imagestr = `/resources/images/photo${((this.chatId) % 50)}.jpg`
            let msg = new ImageMessage(40, 50, imagestr)
            let msgBody = new MessageBase(this.chatDetailData.totalCount()
              .toString(), this.userMyself, this.userFriend, msg, 2)
            this.chatDetailData.pushData(msgBody)
            this.msgLength = this.chatDetailData.totalCount()
            this.scroller.scrollToIndex(this.msgLength - 1)
          })
        Image($r('app.media.type_select'))
          .height(20)
          .width(20)
          .margin({ right: 10 })
      }
      .backgroundColor($r('app.color.detail_bottom_input_background'))
      .width('100%')
      .padding(10)
    }
    .backgroundColor($r('app.color.detail_body_background'))
    .height('100%')
  }

  async convertResourceToString(resource: Resource) {
    let context = getContext(this)
    let manager = context.resourceManager
    return await manager.getStringValue(resource.id)
  }

  async makeDataLocal() {
    let chatDetailMsgList = await getMessageListFromJSON()
    let tdate = new Date()
    let userMyself = new ChatContact('1', $r('app.string.myself'))
    let userFriend = new ChatContact('2', this.chatName, this.chatImg)
    let sum = 0
    for (let i = 0; i < 1000; i++) {
      let msg: TextMessage | ImageMessage
      let msgBody: MessageBase
      if (sum % 2 === 0) {
        msg = new TextMessage(chatDetailMsgList[i % Constants.MOCK_ELEMENT_COUNT])
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), userFriend, userMyself, msg, 1, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), userMyself, userFriend, msg, 1, tdate.getSeconds())
        }
      } else {
        let imageStr = `/resources/images/photo${(i % 50).toString()}.jpg`
        msg = new ImageMessage(40, 50, imageStr)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), userFriend, userMyself, msg, 2, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), userMyself, userFriend, msg, 2, tdate.getSeconds())
        }
      }
      if (i % 2 === 0) {
        sum++
      }
      this.chatDetailData.pushData(msgBody)
    }
    let msg1 = new TextMessage(this.lastMsg)
    this.chatDetailData.pushData(new MessageBase('1000', userFriend, userMyself, msg1, 1, tdate.getSeconds()))
    this.msgLength = this.chatDetailData.totalCount()
  }

  async aboutToAppear() {
    this.makeDataLocal()
  }
}

@Component
struct ChatItemView {
  private msg: MessageBase = new MessageBase('', new ChatContact('', ''), new ChatContact('', ''), new MessageBody(), 0)
  @Link imgFile: image.PixelMap
  @State image: image.PixelMap | null = null

  build() {
    Column() {
      if (this.msg.from.userId != '1') {
        // 聊天页面对方的消息
        Row() {
          Image(this.msg.from.userImage)
            .width(40)
            .height(40)
            .borderRadius(5)
          Column() {
            if (this.msg.msgType === 1) {
              Row() {
                Polygon({ width: 10, height: 10 })
                  .points([[5, 5], [10, 10], [10, 0]])
                  .fill(Color.White)
                Text((this.msg.msgBody as TextMessage).msg)
                  .fontSize(15)
                  .fontColor($r('app.color.detail_item_message_font'))
                  .backgroundColor(Color.White)
                  .padding(10)
                  .borderRadius(5)
              }.margin({ left: -10 })
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).image)
                .width((this.msg.msgBody as ImageMessage).width)
                .height((this.msg.msgBody as ImageMessage).height)
            }
          }
          .margin({ left: 15 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .margin({ top: 15 })
        .padding({ right: 50 })
      } else {
        // 聊天页面本人消息
        Row() {
          Image(this.msg.from.userImage)
            .width(40)
            .height(40)
            .borderRadius(5)
          Column() {
            if (this.msg.msgType === 1) {
              Row() {
                Text((this.msg.msgBody as TextMessage).msg)
                  .fontSize(15)
                  .fontColor($r('app.color.detail_item_message_font'))
                  .backgroundColor($r('app.color.detail_item_message_background'))
                  .borderRadius(5)
                  .padding(10)
                Polygon({ width: 10, height: 10 })
                  .points([[0, 0], [0, 10], [5, 5]])
                  .fill($r('app.color.detail_item_message_fill'))
              }.margin({ right: -10 })
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).image)
                .width((this.msg.msgBody as ImageMessage).width)
                .height((this.msg.msgBody as ImageMessage).height)
            } else if (this.msg.msgType === 3) {
              // 接收分享的页面
              Column() {
                Text((this.msg.msgBody as ImgTextMessage).msg)
                  .backgroundColor($r('app.color.detail_item_message_image_background'))
                  .width('100%')
                  .fontSize(15)
                  .fontColor($r('app.color.detail_item_message_image_font'))
                  .borderRadius(5)
                  .padding(10)
                Image((this.msg.msgBody as ImgTextMessage).image)
                  .width((this.msg.msgBody as ImgTextMessage).width)
                  .height((this.msg.msgBody as ImgTextMessage).height)
                  .objectFit(ImageFit.Contain)
              }
              .margin({ left: '40%' })
              .padding({ left: '2%', right: '2%', bottom: '2%' })
              .backgroundColor($r('app.color.detail_item_background'))
            } else if (this.msg.msgType == 4) {
              Image((this.msg.msgBody as FileMessage).image)
                .width((this.msg.msgBody as FileMessage).width)
                .height((this.msg.msgBody as FileMessage).height)
                .objectFit(ImageFit.Contain)
            }
          }
          .margin({ right: 15 })
          .alignItems(HorizontalAlign.End)
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .direction(Direction.Rtl)
        .padding({ left: 50 })
        .margin({ top: 15 })
      }
    }
  }
}

class ChatDetailData extends BasicDataSource<MessageBase> {
  msgList: Array<MessageBase> = []

  public totalCount(): number {
    return this.msgList.length
  }

  public getData(index: number): MessageBase {
    return this.msgList[index]
  }

  public addData(index: number, data: MessageBase): void {
    this.msgList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: MessageBase): void {
    this.msgList.push(data)
    this.notifyDataAdd(this.msgList.length - 1)
  }
}

export { ChatDetailPage, ChatItemView }