/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
// @ts-nocheck
import { BasicDataSource } from '../common/BasicDataSource';
import { MessageBase, EMContact, MessageBody, TextMessage, ImageMessage } from './MsgBase';
import router from '@ohos.router';
import { ImgTextMessage, FileMessage } from './MsgBase';
import { WantModel, WantFileModel } from './Index'
import prompt from '@ohos.prompt'
import image from '@ohos.multimedia.image';
import fileio from '@ohos.fileio';
import resourceManager from '@ohos.resourceManager'

const TAG = "[Sample_Chat]"

@Entry
@Component
struct ChatDetailPage {
  @State str: string = ""
  @State chatName: string = ''
  @State msgLength: number = 0
  user1 = new EMContact("1", "自己")
  user2 = new EMContact("2", "朋友1")
  msg = new TextMessage("我是好友消息1")
  msg2 = new TextMessage("我是好友消息2")
  tdate = new Date()
  megbody = new MessageBase("1", this.user1, this.user2, this.msg2, 1, this.tdate.getSeconds())
  keyboartStr: string
  private chatDetailData = new ChatDetailData()
  private scroller: Scroller = new Scroller()
  @State wantParams: WantModel = new WantModel() // want的自定义参数
  @State wantFileParams: WantFileModel = new WantFileModel() // want的自定义参数
  @State visibility: Visibility = Visibility.None
  @State imgFile: image.PixelMap = undefined
  @State wantId: number = 0
  @State fdImg: number = undefined
  @State contextCaller: any = undefined
  @State user1Name: string = undefined
  @State user2Name: string = undefined
  @State listHeight: number = 0

  build() {
    Column() {
      Row() {
        Image($r('app.media.left'))
          .key('returnBtn')
          .height(30)
          .width(30)
          .onClick(() => {
            router.back()
          })

        Text(router.getParams().chatName)
          .fontSize(15)
        Stack({ alignContent: Alignment.Center }) {
          Image($r('app.media.icon_more'))
            .height(40)
            .width(40)
        }
        .key('moreBtn')
        .onClick(() => {
          router.push({
            url: "pages/ChatNewsPage",
            params: { NAME: router.getParams().chatName, IMAGEID: router.getParams().chatId }
          })
        })
      }
      .height(50)
      .width("100%")
      .backgroundColor("#f5f5f5")
      .padding({ left: 0, right: 10 })
      .justifyContent(FlexAlign.SpaceBetween)

      List({ scroller: this.scroller, initialIndex: this.msgLength }) {
        LazyForEach(this.chatDetailData, (msg: MessageBase) => {
          ListItem() {
            ChatItemView({ msg: msg, imgFile: $imgFile })
          }
        }, (msg: MessageBase) => msg.msgId)
      }
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: 2, color: "#f3f3f3" })
      .padding({ left: 10, right: 10, bottom: 10 })
      .layoutWeight(1)
      .width('100%')
      //底部输入框
      Row({ space: 5 }) {
        Image($r('app.media.chatting_setmode_voice'))
          .height(20)
          .width(20)
        TextInput({ placeholder: "", text: "" })
          .key('bottomTextInput')
          .height(40)
          .width('80%')
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.keyboartStr = value
          })
          .onSubmit((enterKey) => {
            this.tdate = new Date()
            let msg = new TextMessage(this.keyboartStr)
            let msgBody = new MessageBase(this.chatDetailData.totalCount()
              .toString(), this.user1, this.user2, msg, 1, this.tdate.getSeconds())
            this.chatDetailData.pushData(msgBody)
            this.msgLength = this.chatDetailData.totalCount()
            this.scroller.scrollToIndex(this.msgLength)
          })
        Image($r('app.media.chatting_expression'))
          .key('chatExpression')
          .height(20)
          .width(20)
          .onClick(() => {
            let imagestr = `/resources/images/photo${((router.getParams().chatId) % 50)}.jpg`
            let msg = new ImageMessage(40, 50, imagestr)
            let msgBody = new MessageBase(this.chatDetailData.totalCount().toString(), this.user1, this.user2, msg, 2)
            this.chatDetailData.pushData(msgBody)
            this.msgLength = this.chatDetailData.totalCount()
            this.scroller.scrollToIndex(this.msgLength)
          })
        Image($r('app.media.type_select'))
          .height(20)
          .width(20)
          .margin({ right: 10 })
      }
      .backgroundColor("#e3e3e3")
      .width("100%")
      .padding(10)
    }
    .backgroundColor("#f3f3f3")
    .height("100%")
  }

  async convertResourceToString(resource: Resource) {
    let manager = await resourceManager.getResourceManager()
    return await manager.getString(resource.id)
  }

  async fdTransformPixelMap(): void {
    try {
      let buf = new ArrayBuffer(90960)
      let opt = {
        offset: 0, // 保证下面读取是从头开始读取的。
        position: 0,
        length: 90000
      }
      let readOut = await fileio.readSync(this.wantFileParams.fdImg, buf, opt)
      console.info(TAG + "fdTransformPixelMap: readOut---" + readOut)
      let imgSource: image.ImageSource = undefined
      imgSource = await image.createImageSource(buf)
      let decodingOptions = {
        editable: true, // 是否可编辑
        desiredPixelFormat: 3 // 解码的像素格式
      }
      this.imgFile = await imgSource.createPixelMap(decodingOptions) // 通过图片解码参数创建PixelMap对象
    } catch (errorOut) {
      console.info(TAG + "fdTransformPixelMap: errorOut ---" + errorOut)
    }
  }

  private async aboutToAppear(): void {
    this.makeDataLocal()
    // 把Resource类型转成String
    this.user1Name = this.convertResourceToString($r("app.string.user1Name"))
    this.user2Name = this.convertResourceToString($r("app.string.user2Name"))
    // 接收路由传来的分享参数
    this.wantParams = router.getParams().wantParams;
    console.info(TAG + this.wantParams.textCon)
    console.info(TAG + this.wantParams.srcImg)
    this.wantFileParams = router.getParams().wantFileParams
    this.wantId = this.wantParams.kindId || this.wantFileParams.kindId
    this.fdImg = this.wantFileParams.fdImg
    // >接收AppStorage中的wantParams数据
    console.info(TAG + `aboutToAppear: wantFileParams--- ${JSON.stringify(this.wantFileParams)}`)
    await this.fdTransformPixelMap()
    // 对分享来的数据分类处理
    let user1 = new EMContact("1", this.user1Name)
    let user2 = new EMContact("2", `${this.user2Name}${router.getParams().chatId.toString()}`, `/resources/images/photo${(parseInt(
    router.getParams()
      .chatId) % 50).toString()}.jpg`)
    let content
    let msg
    let tdate = new Date()
    if (this.wantId == 1) {
      content = new ImgTextMessage(200, "100%", this.wantParams.srcImg, this.wantParams.textCon); // 消息内容
      msg = new MessageBase(1000, user1, user2, content, 3, tdate.getSeconds()) // 消息构成
      this.chatDetailData.pushData(msg)
    } else if (this.wantId == 2) {
      content = new FileMessage(180, 200, this.imgFile);
      msg = new MessageBase(1000, user1, user2, content, 4, tdate.getSeconds()) // 消息构成
      this.chatDetailData.pushData(msg)
    }
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    let tdate = new Date()
    let user1 = new EMContact("1", "自己")
    let user2 = new EMContact("2", `朋友${router.getParams().chatId.toString()}`, `/resources/images/photo${(parseInt(
    router.getParams()
      .chatId) % 50).toString()}.jpg`)
    let sum = 0
    for (let i = 0; i < 1000; i++) {
      let msg2
      let msgBody
      if (sum % 2 === 0) {
        msg2 = new TextMessage(`我是第${i.toString()}条消息`)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), user2, user1, msg2, 1, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), user1, user2, msg2, 1, tdate.getSeconds())
        }
      } else {
        let imagestr = `/resources/images/photo${(i % 50).toString()}.jpg`
        msg2 = new ImageMessage(40, 50, imagestr)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), user2, user1, msg2, 2, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), user1, user2, msg2, 2, tdate.getSeconds())
        }
      }
      if (i % 2 === 0) sum++
      this.chatDetailData.pushData(msgBody)
    }
    this.msgLength = this.chatDetailData.totalCount()
  }
}

@Component
struct ChatItemView {
  private msg: MessageBase
  @Link imgFile: image.PixelMap

  build() {
    Column() {
      if (this.msg.fo.userId != '1') {
        // 聊天页面对方的消息
        Row() {
          Image(this.msg.fo.userImage)
            .width(40)
            .height(40)
            .borderRadius(5)
          Column() {
            Text(this.msg.fo.userName)
            if (this.msg.msgType === 1) {
              Text((this.msg.msgBody as TextMessage).msg)
                .fontSize(15)
                .fontColor("#000")
                .backgroundColor(Color.White)
                .padding(10)
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).img)
                .width((this.msg.msgBody as ImageMessage).width)
                .height((this.msg.msgBody as ImageMessage).height)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 5 })
        }
        .width("100%")
        .alignItems(VerticalAlign.Top)
        .margin({ top: 15 })
        .padding({ right: 50 })
      } else {
        // 聊天页面本人消息
        Row() {
          Image(this.msg.fo.userImage)
            .width(40)
            .height(40)
            .borderRadius(5)
          Column() {
            Text(this.msg.fo.userName)
            if (this.msg.msgType === 1) {
              Text((this.msg.msgBody as TextMessage).msg)
                .fontSize(15)
                .fontColor("#000")
                .backgroundColor("#7fec7d")
                .borderRadius(5)
                .padding(10)
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).img)
                .width((this.msg.msgBody as ImageMessage).width)
                .height((this.msg.msgBody as ImageMessage).height)
            } else if (this.msg.msgType === 3) {
              // 接收分享的页面
              Column() {
                // let msgBody = this.msg.msgBody as ImgTextMessage
                Text((this.msg.msgBody as ImgTextMessage).msg)
                  .backgroundColor("#FFFFFF")
                  .width("100%")
                  .fontSize(15)
                  .fontColor("#000")
                  .borderRadius(5)
                  .padding(10)
                // Image($r("app.media.phone"))
                Image((this.msg.msgBody as ImgTextMessage).img)
                  .width((this.msg.msgBody as ImgTextMessage).width)
                  .height((this.msg.msgBody as ImgTextMessage).height)
                  .objectFit(ImageFit.Contain)
              }
              .margin({ left: "40%" })
              .padding({ left: "2%", right: "2%", bottom: "2%" })
              .backgroundColor("#FFFFFF")
            } else if (this.msg.msgType == 4) {
              Image((this.msg.msgBody as FileMessage).img)
                .width((this.msg.msgBody as FileMessage).width)
                .height((this.msg.msgBody as FileMessage).height)
                .objectFit(ImageFit.Contain)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ right: 5 })
        }
        .alignItems(VerticalAlign.Top)
        .width("100%")
        .direction(Direction.Rtl)
        .padding({ left: 50 })
        .margin({ top: 15 })
      }
    }
  }
}

class ChatDetailData extends BasicDataSource {
  msgList: Array<MessageBase> = []

  public totalCount(): number {
    return this.msgList.length
  }

  public getData(index: number): any {
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