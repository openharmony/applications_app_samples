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

import mediaQuery from '@ohos.mediaquery';
import prompt from '@ohos.prompt'
import image from '@ohos.multimedia.image'
import { RequestRes, RequestResContent } from "../model/HttpModel"
import { httpRequest } from "../net/HttpRequest"
import { dialogData } from "../mock/ShareData"
import { DialogDataModel } from "../model/ShareModel"
import Logger from "../model/Logger"
import { ShareUtils } from "../feature/ShareUtils"

interface EventHub {
  emit(event: string, ...args: Object[]): void
}

interface AbilityContext {
  terminateSelf(): Promise<void>

  eventHub: EventHub
}

let isPhone: boolean = true
const TAG: string = "[Sample_ShareComponent]"

// 弹窗,后期功能优化
@CustomDialog
struct ShareDialogBuilder {
  controller: CustomDialogController
  contextCaller: any
  detail0: string
  detail1: string
  title: string
  srcImg: string
  confirm: () => void
  shareUtils: ShareUtils = new ShareUtils(getContext(this))
  @State _pixelMap: image.PixelMap = undefined

  build() {
    Column() {
      Text(this.detail0)
        .textAlign(TextAlign.Center)
        .width("52%")
        .height("4%")
        .backgroundColor("#dddddd")
        .borderRadius(4)
        .fontSize($r("app.float.fontSize_10"))
        .margin({
          bottom: $r("app.float.margin_bottom_10")
        })

      //      Image(this.srcImg)
      Image($r('app.media.phone'))
        .width("100%")
        .height("66%")
        .objectFit(ImageFit.Contain)
        .margin({
          bottom: $r("app.float.margin_bottom_10")
        })

      Column() {
        Row() {
          Text(`￥`)
            .fontSize($r("app.float.fontSize_10"))
          Text(`${this.detail1}`)
            .fontWeight(FontWeight.Regular)
            .fontSize($r("app.float.fontSize_20"))
        }
        .margin({
          bottom: $r("app.float.margin_bottom_10")
        })

        Text(this.title)
          .textAlign(TextAlign.Start)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(FontWeight.Medium)
          .fontSize($r("app.float.fontSize_18"))
          .margin({
            bottom: $r("app.float.margin_bottom_10")
          })
      }
      .alignItems(HorizontalAlign.Start)
      .width("100%")
      .margin({
        bottom: $r("app.float.margin_bottom_10")
      })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r("app.string.cancel"))
          .onClick(() => {
            this.controller.close()
            Logger.info(TAG, "ShareDialogBuilder-------- onCancel")
          })
          .backgroundColor($r("app.color.color_0xffffff"))
          .fontColor(Color.Black)
        Button($r("app.string.shot"))
          .onClick(() => {
            this.shareUtils.getScreen(isPhone, this.contextCaller)
            Logger.info(TAG, "getScreen-------- success")
            this.controller.close()
          })
          .backgroundColor($r("app.color.color_0xffffff"))
          .fontColor(Color.Black)
      }
      .margin({
        bottom: $r("app.float.margin_bottom_10")
      })
    }
    .borderRadius(16)
    .width("60%")
    .height("75%")
    .padding($r("app.float.padding_24"))
    .backgroundColor($r("app.color.color_FFFFFF"))
  }
}

// button的弹窗
@CustomDialog
export struct ButtonDialogBuilder {
  controller: CustomDialogController
  detail0: string
  detail1: string
  title: string
  srcImg: string
  shareDialogController: CustomDialogController
  shareUtils: ShareUtils = new ShareUtils(getContext(this))
  private context: AbilityContext
  contextCaller: any
  @State dialogData: Array<DialogDataModel> = dialogData
  listenerIsPhone = mediaQuery.matchMediaSync('(orientation:landscape)');

  // 分享图片文件
  shareImage = () => {
    // Todo
    //  ShareUtils.shareImageStartAbility(this.contextCaller);
    Logger.info(TAG, 'Callback when the second button is clicked')
  }

  onShareFriend() {
    // 拉起三方应用操作
    Logger.info(TAG, `onShareChat:  ${JSON.stringify(this)}`)
    this.shareUtils.startAbility(this.contextCaller, this.title, this.srcImg)
  }

  openDialog = () => {
    // 生成画布
    this.shareDialogController = new CustomDialogController({
      builder: ShareDialogBuilder({
        controller: this.shareDialogController,
        contextCaller: this.contextCaller,
        detail0: this.detail0,
        detail1: this.detail1,
        title: this.title,
        srcImg: this.srcImg,
        confirm: this.shareImage,
      }),
      cancel: undefined,
      autoCancel: true, // 是否允许点击弹窗退出
      alignment: DialogAlignment.Center,
      customStyle: true,
    })
    this.shareDialogController.open()

    Logger.info(TAG, "openDialog  this.shareDialogController.open();")
    Logger.info(TAG, `openDialog: ${JSON.stringify(this)}`)
  }
  shareVideo = () => {
    this.shareUtils.getFileData(this.contextCaller)
  }
  onPortrait = (mediaQueryResult) => {
    isPhone = !mediaQueryResult.matches
  }

  async aboutToAppear() {
    Logger.info(TAG, "get Component's aboutToAppear success")
    this.context = getContext(this) as AbilityContext
    let data = {
      context: null,
      launchWant: null
    }
    Logger.info(TAG, 'aboutToAppear');
    this.context.eventHub.emit("getAbilityData", data)
    Logger.info(TAG, 'aboutToAppear  ' + JSON.stringify(data.context) + ' want:' + JSON.stringify(data.launchWant))
    this.contextCaller = this.context // 拿到全局的context
    Logger.info(TAG, JSON.stringify(this.contextCaller))
    httpRequest("http://123.60.114.86:8090/goods/detail?id=1", "get", "", (data) => {
      let requestRes: RequestRes = JSON.parse(data.result)
      let requestResContent: RequestResContent = requestRes.data
      Logger.info(TAG, "requestRes" + requestRes)
      Logger.info(TAG, "requestResContent" + requestResContent)
      this.title = requestResContent.title
      this.detail1 = requestResContent.price
      this.srcImg = requestResContent.urls[1]
    })
    this.listenerIsPhone.on("change", this.onPortrait)
  }

  aboutToDisappear() {
    this.listenerIsPhone.off('change')
  }

  teminate() {
    Logger.info(TAG, 'teminate')
    this.context.terminateSelf()
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Row() {
            Text($r("app.string.toShare"))
              .fontSize($r("app.float.fontSize_20"))
              .fontWeight(FontWeight.Medium)
          }
          .margin({
            top: $r("app.float.margin_20"),
            bottom: $r("app.float.margin_20")
          })

          DialogLayoutComponent({
            dialogData: $dialogData,
            srcImg: this.srcImg,
            controller: this.controller,
            onShareFriend: this.onShareFriend.bind(this),
            openDialog: this.openDialog,
            shareVideo: this.shareVideo,
            contextCaller: this.contextCaller
          })

          Row() {
            Text($r("app.string.cancel"))
              .fontSize($r("app.float.fontSize_20"))
              .fontWeight(FontWeight.Normal)
          }
          .margin({
            top: $r("app.float.margin_20"),
            bottom: $r("app.float.margin_20")
          })
          .onClick(() => {
            Logger.info(TAG, "onclick close")
            this.controller.close()
          })
        }
        .borderRadius(16)
        .height($r("app.float.wh_value_260"))
        .backgroundColor("#F1F3F5")
      }
      .height("100%")
    }
    .width("100%")
  }
}

@Component
struct DialogLayoutComponent {
  @Link dialogData: Array<DialogDataModel>
  onShareFriend: any
  controller: CustomDialogController
  openDialog: any
  shareVideo: any
  srcImg: string
  contextCaller: any

  convertResourceToString(resource: Resource) {
    return this.contextCaller.resourceManager.getStringSync(resource.id)
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        ForEach(this.dialogData.map((item1, index1) => {
          return { index: index1 + 1, data: item1 }
        }), (item) => {
          Column() {
            Image(item.data.src)
              .width($r("app.float.wh_value_66"))
              .height($r("app.float.wh_value_66"))
              .margin({
                bottom: $r("app.float.margin_bottom_10")
              })
            Text(`${item.data.text}`)
              .fontSize($r("app.float.fontSize_18"))
              .fontWeight(FontWeight.Normal)
          }
          .onClick(() => {
            Logger.info(TAG, `click, index---- ${item.index}`)
            if (item.index == 1) {
              this.onShareFriend()
              Logger.info(TAG, "onShareFriend")
              this.controller.close();
            } else if (item.index == 2) { // 图库文件分享的入口
              // Todo
              // this.shareUtils.getFileData(this.contextCalle
              prompt.showToast({
                message: this.convertResourceToString($r("app.string.toDO")),
                duration: 3000,
              });
              this.controller.close();
            } else if (item.index == 3) {
              this.controller.close()
              prompt.showToast({
                message: this.convertResourceToString($r("app.string.toDO")),
                duration: 3000,
              });
            } else if (item.index == 4) { // 应用内文件分享的入口
              this.openDialog()
              this.controller.close()
            }
          })
        }, item => item.toString())
      }
      .width("100%")
      .height($r("app.float.wh_value_100"))
      .margin({
        bottom: $r("app.float.margin_bottom_36")
      })
    }.width("100%")
  }
}