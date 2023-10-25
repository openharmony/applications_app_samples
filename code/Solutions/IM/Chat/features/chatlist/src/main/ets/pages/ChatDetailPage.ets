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

import { BasicDataSource } from '../viewmodel/BasicDataSource';
import { MessageBase, ChatContact, TextMessage, ImageMessage, MessageBody } from '../viewmodel/MsgBase';
import { getMessageListFromJSON } from '../utils/DataFactory';
import router from '@ohos.router';
import { ImageTextMessage, FileMessage } from '../viewmodel/MsgBase';
import image from '@ohos.multimedia.image';
import Constants from '../utils/Constants';
import hiTraceMeter from '@ohos.hiTraceMeter';
import Want from '@ohos.app.ability.Want';
import Logger from '../utils/Logger';
import fs from '@ohos.file.fs';

const ABOUT_TO_APPEAR_TRACE: string = 'ChatDetailPage_AboutToAppear_HiTrace';
const ABOUT_TO_APPEAR_TRACE_ID: number = 1; // aboutToAppear 中使用的 taskId
const MAKE_DATA_LOCAL_TRACE: string = 'ChatDetailPage_MakeDataLocal_HiTrace';
const MAKE_DATA_LOCAL_TRACE_ID: number = 2; // makeDataLocal 中使用的 taskId
const STROKE_WIDTH: number = 2; // strokeWidth的宽度
const LAYOUT_WEIGHT: number = 1; // layoutWeight参数

export class WantModel {
  srcImage: string = '';
  textContent: string = '';
  senderId: number = 0;

  constructor(srcImage?: string, text?: string, senderId?: number) {
    if (srcImage !== undefined) {
      this.srcImage = srcImage;
    }
    if (text !== undefined) {
      this.textContent = text;
    }
    if (senderId !== undefined) {
      this.senderId = senderId;
    }
  }

  toString(): string {
    return this.srcImage + "  " + this.textContent + "  " + this.senderId;
  }
}

export class WantFileModel {
  fdImage: number = 0;
  kindId: number = 0;

  constructor(fdImage?: number, kindId?: number) {
    if (fdImage !== undefined) {
      this.fdImage = fdImage;
    }

    if (kindId !== undefined) {
      this.kindId = kindId;
    }
  }
}

class ShareDate {
  type: string = '';
  value: number = 0;
}

@Preview
@Component
  // 聊天页面
export struct ChatDetailPage {
  @StorageLink('keyboardHeight') keyboardHeight: number = 0;
  @State msgLength: number = 0;
  userMyself = new ChatContact('1', $r('app.string.myself'));
  userFriend = new ChatContact('2', $r('app.string.friend'));
  msg = new TextMessage($r('app.string.message1'));
  msgAnother = new TextMessage($r('app.string.message2'));
  todayDate = new Date();
  msgBody = new MessageBase('1', this.userMyself, this.userFriend, this.msgAnother, 1, this.todayDate.getSeconds());
  @State keyboardStr: string = '';
  private chatDetailData = new ChatDetailData();
  private scroller: Scroller = new Scroller();
  @State wantId: number = 0;
  @State userMyselfName: string = '';
  @State userFriendName: string = '';
  @State listHeight: number = 0;
  @State want: Want | undefined = undefined;
  wantParams: WantModel = new WantModel("./resources/images/photo0.jpg", "111", 0);
  wantFileParams: WantFileModel = new WantFileModel();
  @State imageFile: image.PixelMap | undefined = undefined;
  @State imageSize: number = 90960;
  private params = router.getParams() as Record<string, Object>;
  chatId: number = this.params.chatId as number;
  chatName: string | Resource = this.params.chatName as string | Resource;
  chatImg: string | Resource = this.params.chatImg as string | Resource;
  lastMsg: string | Resource = this.params.lastMsg as string | Resource;

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Row() {
          Image($r('app.media.chat_detail_back'))
            .id('returnBtn')
            .height($r('app.integer.opt_layout_chat_view_item_padding_right'))
            .width($r('app.integer.opt_layout_chat_view_item_padding_right'))
            .onClick(() => {
              router.back();
            })

          Text(this.chatName)
            .fontSize($r('app.integer.opt_layout_chat_view_profile_picture_radius'))
            .lineHeight($r('app.integer.layout_28'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({ left: $r('app.integer.search_font_size') })
        }
        .margin({ left: $r('app.integer.opt_layout_chat_view_item_padding_right') })

        Stack({ alignContent: Alignment.End }) {
          Image($r('app.media.chat_detail_more'))
            .height($r('app.integer.opt_layout_chat_view_item_padding_right'))
            .width($r('app.integer.opt_layout_chat_view_item_padding_right'))
            .margin({ right: $r('app.integer.opt_layout_chat_view_item_padding_right') })
        }
        .id('moreBtn')
      }
      .height($r('app.integer.search_outline_height'))
      .width($r('app.string.layout_100'))
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)

      List({ scroller: this.scroller, initialIndex: this.msgLength - 1 }) {
        LazyForEach(this.chatDetailData, (msg: MessageBase) => {
          ListItem() {
            ChatItemView({ msg: msg });
          }
        }, (msg: MessageBase) => msg.msgId)
      }
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: STROKE_WIDTH, color: $r('app.color.detail_divider') })
      .padding({
        left: $r('app.integer.layout_10'),
        right: $r('app.integer.layout_10'),
        bottom: $r('app.integer.layout_10')
      })
      .width($r('app.string.layout_100'))
      .layoutWeight(LAYOUT_WEIGHT)

      // 底部输入框
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Image($r('app.media.chatting_mode_voice'))
          .height($r('app.integer.opt_layout_chat_view_voice_image_width'))
          .margin({
            left: $r('app.integer.search_font_size'),
            right: $r('app.integer.search_font_size')
          })
        TextInput({ placeholder: '', text: this.keyboardStr })
          .id('bottomTextInput')
          .height($r('app.integer.search_inline_height'))
          .layoutWeight(LAYOUT_WEIGHT)
          .borderRadius($r('app.integer.search_border_radius'))
          .backgroundColor($r('app.string.chat_detail_input_background'))
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.keyboardStr = value;
          })
          .onSubmit(() => {
            this.todayDate = new Date();
            let msg = new TextMessage(this.keyboardStr);
            let msgBody = new MessageBase(this.chatDetailData.totalCount()
              .toString(), this.userMyself, this.userFriend, msg, 1, this.todayDate.getSeconds());
            this.chatDetailData.pushData(msgBody);
            this.msgLength = this.chatDetailData.totalCount();
            this.scroller.scrollToIndex(this.msgLength - 1);
            this.keyboardStr = '';
          })
        Image($r('app.media.input_emoji'))
          .id('chatExpression')
          .height($r('app.integer.opt_layout_chat_view_item_padding_right'))
          .width($r('app.integer.opt_layout_chat_view_item_padding_right'))
          .margin({ left: $r('app.integer.search_font_size'), right: $r('app.integer.search_font_size') })
          .onClick(() => {
            let imageStr = `/resources/images/photo${((this.chatId) % 50)}.jpg`;
            let msg = new ImageMessage(40, 50, imageStr);
            let msgBody = new MessageBase(this.chatDetailData.totalCount()
              .toString(), this.userMyself, this.userFriend, msg, 2);
            this.chatDetailData.pushData(msgBody);
            this.msgLength = this.chatDetailData.totalCount();
            this.scroller.scrollToIndex(this.msgLength - 1);
          })
        Image($r('app.media.input_add'))
          .height($r('app.integer.opt_layout_chat_view_item_padding_right'))
          .width($r('app.integer.opt_layout_chat_view_item_padding_right'))
          .margin({ right: $r('app.integer.search_font_size') })
      }
      .borderRadius({
        topLeft: $r('app.integer.search_border_radius'),
        topRight: $r('app.integer.search_border_radius')
      })
      .backgroundColor(Color.White)
      .width($r('app.string.layout_100'))
      .height($r('app.integer.search_outline_height'))
    }
    .padding({ bottom: px2vp((this.keyboardHeight)) })
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .backgroundColor($r('app.color.detail_body_background'))
    .height($r('app.string.layout_100'))
  }

  async getWant() {
    // 文本、链接的参数处理
    this.want = AppStorage.get('want');
    if (this.want?.parameters) {
      this.wantParams.srcImage = this.want.parameters.srcImg as string;
      this.wantParams.textContent = this.want.parameters.text as string;
      this.wantParams.senderId = this.want.parameters.kindId as number;
      this.wantId = this.wantParams.senderId;
    }
  }

  async fdTransformPixelMap(): Promise<void> {
    try {
      if (this.want?.parameters === undefined) {
        return
      }

      let shareDate = this.want.parameters["keyFd"] as ShareDate;
      this.wantFileParams.fdImage = shareDate.value;
      let buffer = new ArrayBuffer(this.imageSize);
      let readOut = fs.readSync(this.wantFileParams.fdImage, buffer);
      Logger.info('fdTransformPixelMap: readOut---' + readOut);
      let imageSource: image.ImageSource | undefined = undefined;
      imageSource = image.createImageSource(buffer);
      let decodingOptions: image.DecodingOptions = {
        editable: true, // 是否可编辑
        desiredPixelFormat: 3 // 解码的像素格式
      };
      this.imageFile = await imageSource.createPixelMap(decodingOptions); // 通过图片解码参数创建PixelMap对象
    } catch (errorOut) {
      Logger.info('fdTransformPixelMap: errorOut ---' + errorOut);
    }
  }

  async convertResourceToString(resource: Resource) {
    let context = getContext(this);
    let manager = context.resourceManager;
    return await manager.getStringValue(resource.id);
  }

  // 设定本地聊天内容
  async makeDataLocal() {
    hiTraceMeter.startTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
    let chatDetailMsgList = await getMessageListFromJSON();
    let todayDate = new Date();
    let userMyself = new ChatContact('1', $r('app.string.myself'));
    let userFriend = new ChatContact('2', this.chatName, this.chatImg);
    let sum = 0;
    // 循环遍历本地数据，通过取模的方式选择文本数据或者图片数据
    for (let i = 0; i < 1000; i++) {
      let msg: TextMessage | ImageMessage;
      let msgBody: MessageBase;
      if (sum % 2 === 0) {
        msg = new TextMessage(chatDetailMsgList[i % Constants.MOCK_ELEMENT_COUNT]);
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), userFriend, userMyself, msg, 1, todayDate.getSeconds());
        } else {
          msgBody = new MessageBase(i.toString(), userMyself, userFriend, msg, 1, todayDate.getSeconds());
        }
      } else {
        let imageStr = `/resources/images/photo${(i % 50).toString()}.jpg`;
        msg = new ImageMessage(40, 50, imageStr);
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), userFriend, userMyself, msg, 2, todayDate.getSeconds());
        } else {
          msgBody = new MessageBase(i.toString(), userMyself, userFriend, msg, 2, todayDate.getSeconds());
        }
      }
      if (i % 2 === 0) {
        sum++;
      }
      this.chatDetailData.pushData(msgBody);
    }
    if (this.wantId === 1) {
      let lastMsg = new ImageTextMessage(200, 100, this.wantParams.srcImage, this.wantParams.textContent);
      this.chatDetailData.pushData(new MessageBase('1000', userMyself, userFriend, lastMsg, 3, todayDate.getSeconds()));
    } else if (this.wantId === 2) {
      await this.fdTransformPixelMap();
      if (this.imageFile !== undefined) {
        let lastMsg = new FileMessage(180, 200, this.imageFile);
        this.chatDetailData.pushData(new MessageBase('1000', userMyself, userFriend, lastMsg, 3, todayDate.getSeconds()));
      }
    }
    this.msgLength = this.chatDetailData.totalCount();
    hiTraceMeter.finishTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
  }

  async aboutToAppear() {
    await this.getWant();
    hiTraceMeter.startTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
    this.makeDataLocal();
    hiTraceMeter.finishTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
  }
}

@Component
  // 聊天对话框
export struct ChatItemView {
  private msg: MessageBase = new MessageBase('', new ChatContact('', ''), new ChatContact('', ''), new MessageBody(), 0);

  build() {
    Column() {
      if (this.msg.from.userId != '1') {
        // 聊天页面对方的消息
        Row() {
          Image(this.msg.from.userImage)
            .width($r('app.integer.opt_layout_chat_view_profile_picture_height'))
            .height($r('app.integer.opt_layout_chat_view_profile_picture_height'))
            .borderRadius($r('app.integer.opt_layout_chat_view_profile_picture_radius'))
          Column() {
            if (this.msg.msgType === 1) {
              Row() {
                Text((this.msg.msgBody as TextMessage).msg)
                  .lineHeight($r('app.integer.search_text_height'))
                  .constraintSize({ minHeight: $r('app.integer.search_inline_height') })
                  .fontSize($r('app.integer.search_font_size'))
                  .fontColor($r('app.color.top_bar_font_color'))
                  .backgroundColor(Color.White)
                  .padding({
                    top: $r('app.integer.layout_8'),
                    left: $r('app.integer.text_font_13'),
                    bottom: $r('app.integer.layout_8'),
                    right: $r('app.integer.text_font_13')
                  })
                  .borderRadius({ topLeft: $r('app.integer.layout_4'),
                    topRight: $r('app.integer.opt_layout_chat_view_item_padding_right'),
                    bottomLeft: $r('app.integer.opt_layout_chat_view_item_padding_right'),
                    bottomRight: $r('app.integer.opt_layout_chat_view_item_padding_right')
                  })
              }
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).image)
                .width($r('app.integer.layout_184'))
                .height($r('app.integer.layout_111'))
                .borderRadius($r('app.integer.search_border_radius'))
            }
          }
          .margin({ left: $r('app.integer.layout_8') })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .margin({ top: $r('app.integer.layout_12') })
        .padding({ right: $r('app.integer.chat_view_time_width') })
      } else {
        // 聊天页面本人消息
        Row() {
          Image(this.msg.from.userImage)
            .width($r('app.integer.opt_layout_chat_view_profile_picture_height'))
            .height($r('app.integer.opt_layout_chat_view_profile_picture_height'))
            .borderRadius($r('app.integer.opt_layout_chat_view_profile_picture_radius'))
          Column() {
            if (this.msg.msgType === 1) {
              Row() {
                Text((this.msg.msgBody as TextMessage).msg)
                  .lineHeight($r('app.integer.search_text_height'))
                  .constraintSize({ minHeight: $r('app.integer.opt_layout_chat_view_profile_picture_height') })
                  .fontSize($r('app.integer.search_font_size'))
                  .backgroundColor($r('app.color.detail_item_message_background'))
                  .fontColor($r('app.color.top_bar_font_color'))
                  .padding({
                    top: $r('app.integer.layout_8'),
                    left: $r('app.integer.text_font_13'),
                    bottom: $r('app.integer.layout_8'),
                    right: $r('app.integer.text_font_13')
                  })
                  .borderRadius({
                    topLeft: $r('app.integer.opt_layout_chat_view_item_padding_right'),
                    topRight: $r('app.integer.layout_4'),
                    bottomLeft: $r('app.integer.opt_layout_chat_view_item_padding_right'),
                    bottomRight: $r('app.integer.opt_layout_chat_view_item_padding_right')
                  })
              }
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).image)
                .width($r('app.integer.layout_184'))
                .height($r('app.integer.layout_111'))
                .borderRadius($r('app.integer.search_border_radius'))
            } else if (this.msg.msgType === 3) {
              // 接收分享的页面
              Column() {
                Text((this.msg.msgBody as ImageTextMessage).msg)
                  .backgroundColor($r('app.color.detail_item_message_image_background'))
                  .width('100%')
                  .fontSize(15)
                  .fontColor($r('app.color.detail_item_message_image_font'))
                  .borderRadius(5)
                  .padding(10)
                Image((this.msg.msgBody as ImageTextMessage).image)
                  .width((this.msg.msgBody as ImageTextMessage).width)
                  .height((this.msg.msgBody as ImageTextMessage).height)
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
          .margin({ right: $r('app.integer.layout_8') })
          .alignItems(HorizontalAlign.End)
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .direction(Direction.Rtl)
        .padding({ left: $r('app.integer.chat_view_time_width') })
        .margin({ top: $r('app.integer.layout_12') })
      }
    }
  }
}

class ChatDetailData extends BasicDataSource<MessageBase> {
  msgList: Array<MessageBase> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): MessageBase {
    return this.msgList[index];
  }

  public addData(index: number, data: MessageBase): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: MessageBase): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }
}