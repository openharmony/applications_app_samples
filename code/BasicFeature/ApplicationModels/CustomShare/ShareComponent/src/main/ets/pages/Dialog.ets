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
import { RequestRes, RequestResContent } from '../model/HttpModel'
import { httpRequest } from '../net/HttpRequest'
import { dialogData } from '../mock/ShareData'
import { DialogDataModel } from '../model/ShareModel'
import { ShareUtils } from '../feature/ShareUtils'
import { ShareConst } from '../util/ShareConst'
import Logger from '../util/Logger'


interface EventHub {
  emit(event: string, ...args: Object[]): void
}

interface AbilityContext {
  terminateSelf(): Promise<void>

  eventHub: EventHub
}

let isLand: boolean = true
const TAG: string = 'ShareDialogBuilder'

// 弹窗,后期功能优化
@CustomDialog
struct ShareDialogBuilder {
  private controller?: CustomDialogController
  private contextCaller: any
  private detailTitleText: string = ''
  private detailPriceText: string = ''
  private title: string = ''
  private srcImage: string = ''
  private confirm: () => void
  private shareUtils: ShareUtils = new ShareUtils(getContext(this))
  @State pixelMap: image.PixelMap = undefined

  build() {
    Column() {
      Text(this.detailTitleText)
        .textAlign(TextAlign.Center)
        .width('52%')
        .height("4%")
        .backgroundColor('#dddddd')
        .borderRadius(4)
        .fontSize($r('app.float.fontSize_ten'))
        .margin({ bottom: $r('app.float.margin_bottom_ten') })

      Image($r('app.media.phone'))
        .width("100%")
        .height("66%")
        .objectFit(ImageFit.Contain)
        .margin({ bottom: $r('app.float.margin_bottom_ten') })

      Column() {
        Row() {
          Text($r('app.string.symbol'))
            .fontSize($r('app.float.fontSize_ten'))
          Text(`${this.detailPriceText}`)
            .fontWeight(FontWeight.Regular)
            .fontSize($r('app.float.fontSize_twenty'))
        }
        .margin({
          bottom: $r('app.float.margin_bottom_ten')
        })

        Text(this.title)
          .textAlign(TextAlign.Start)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.fontSize_eighteen'))
          .margin({
            bottom: $r('app.float.margin_bottom_ten')
          })
      }
      .alignItems(HorizontalAlign.Start)
      .width("100%")
      .margin({
        bottom: $r('app.float.margin_bottom_ten')
      })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            this.controller.close()
            Logger.info(TAG, `ShareDialogBuilder onCancel`)
          })
          .backgroundColor($r('app.color.color_0xffffff'))
          .fontColor(Color.Black)
        Button($r('app.string.shot'))
          .onClick(() => {
            this.shareUtils.getScreen(isLand, this.contextCaller)
            Logger.info(TAG, `getScreen success`)
            this.controller.close()
          })
          .backgroundColor($r('app.color.color_0xffffff'))
          .fontColor(Color.Black)
      }
      .margin({
        bottom: $r('app.float.margin_bottom_ten')
      })
    }
    .borderRadius(16)
    .width("60%")
    .height("75%")
    .padding($r('app.float.padding_two_four'))
    .backgroundColor($r('app.color.color_FFFFFF'))
  }
}

// button的弹窗
@CustomDialog
export struct ButtonDialogBuilder {
  private controller?: CustomDialogController
  private shareDialogController?: CustomDialogController
  private detailTitleText: string = ''
  private detailPriceText: string = ''
  private title: string = ''
  private srcImage: string = ''
  private context?: AbilityContext
  private contextCaller?: any
  private shareUtils: ShareUtils = new ShareUtils(getContext(this))
  private isLand = mediaQuery.matchMediaSync('(orientation:landscape)')
  @State dialogData: Array<DialogDataModel> = dialogData

  // 分享图片文件
  shareImage = () => {
    Logger.info(TAG, `Callback when the second button is clicked`)
  }
  onShareFriend = () => {
    // 拉起三方应用操作
    Logger.info(TAG, `onShareChat:  ${JSON.stringify(this)}`)
    this.shareUtils.startAbility(this.contextCaller, this.title, this.srcImage)
  }
  openDialog = () => {
    // 生成画布
    this.shareDialogController = new CustomDialogController({
      builder: ShareDialogBuilder({
        controller: this.shareDialogController,
        contextCaller: this.contextCaller,
        detailTitleText: this.detailTitleText,
        detailPriceText: this.detailPriceText,
        title: this.title,
        srcImage: this.srcImage,
        confirm: this.shareImage,
      }),
      cancel: undefined,
      autoCancel: true, // 是否允许点击弹窗退出
      alignment: DialogAlignment.Center,
      customStyle: true,
    })
    this.shareDialogController.open()
    Logger.info(TAG, `openDialog  this.shareDialogController.open()`)
  }
  shareVideo = () => {
    this.shareUtils.getFileData(this.contextCaller)
  }
  onPortrait = (mediaQueryResult) => {
    isLand = !mediaQueryResult.matches
  }

  async aboutToAppear() {
    Logger.info(TAG, `get Component's aboutToAppear success`)
    this.context = getContext(this) as any
    let data = {
      context: null,
      launchWant: null
    }
    Logger.info(TAG, 'aboutToAppear')
    this.context.eventHub.emit('getAbilityData', data)
    Logger.info(TAG, `aboutToAppear: ${JSON.stringify(data.context)}}, want: ${JSON.stringify(data.launchWant)}`)
    this.contextCaller = this.context // 拿到全局的context
    Logger.info(TAG, JSON.stringify(this.contextCaller))
    httpRequest(ShareConst.REQUEST, ShareConst.METHOD, '', (data) => {
      let requestRes: RequestRes = JSON.parse(data.result)
      let requestResContent: RequestResContent = requestRes.data
      Logger.info(TAG, `requestRes: ${requestRes}, requestResContent: ${requestResContent}`)
      this.title = requestResContent.title
      this.detailPriceText = requestResContent.price
      this.srcImage = requestResContent.urls[1]
    })
    this.isLand.on('change', this.onPortrait)
  }

  aboutToDisappear() {
    this.isLand.off('change')
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Row() {
            Text($r('app.string.toShare'))
              .fontSize($r('app.float.fontSize_twenty'))
              .fontWeight(FontWeight.Medium)
          }
          .margin({ top: $r('app.float.margin_twenty'), bottom: $r('app.float.margin_twenty') })

          DialogLayoutComponent({
            dialogData: $dialogData,
            srcImage: this.srcImage,
            controller: this.controller,
            onShareFriend: this.onShareFriend,
            openDialog: this.openDialog,
            shareVideo: this.shareVideo,
            contextCaller: this.contextCaller
          })

          Row() {
            Text($r('app.string.cancel'))
              .fontSize($r('app.float.fontSize_twenty'))
              .fontWeight(FontWeight.Normal)
          }
          .margin({
            top: $r('app.float.margin_twenty'),
            bottom: $r('app.float.margin_twenty')
          })
          .onClick(() => {
            Logger.info(TAG, `onclick close`)
            this.controller.close()
          })
        }
        .borderRadius(16)
        .height($r('app.float.wh_height'))
        .backgroundColor('#F1F3F5')
      }
      .height("100%")
    }
    .width("100%")
  }
}

@Component
struct DialogLayoutComponent {
  @Link dialogData: Array<DialogDataModel>
  private controller?: CustomDialogController
  private onShareFriend: () => void
  private openDialog: () => void
  private shareVideo: () => void
  private contextCaller?: any
  private srcImage: string = ''

  convertResourceToString(resource: Resource) {
    return this.contextCaller.resourceManager.getStringSync(resource.id)
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        ForEach(this.dialogData.map((dialogDataItem, dialogDataIndex) => {
          return { index: dialogDataIndex + 1, data: dialogDataItem }
        }), (item) => {
          Column() {
            Image(item.data.src)
              .width($r('app.float.width_height_value'))
              .height($r('app.float.width_height_value'))
              .margin({
                bottom: $r('app.float.margin_bottom_ten')
              })
            Text(`${this.convertResourceToString(item.data.text)}`)
              .fontSize($r('app.float.fontSize_eighteen'))
              .fontWeight(FontWeight.Normal)
          }
          .onClick(() => {
            Logger.info(TAG, `click, index: ${item.index}`)
            if (item.index === 1) {
              this.onShareFriend()
              Logger.info(TAG, "onShareFriend")
              this.controller.close()
            } else if (item.index === 2) { // 图库文件分享的入口
              prompt.showToast({
                message: this.convertResourceToString($r('app.string.todo')),
                duration: ShareConst.DURATION_NUMBER
              })
              this.controller.close();
            } else if (item.index === 3) {
              this.controller.close()
              prompt.showToast({
                message: this.convertResourceToString($r('app.string.todo')),
                duration: 3000
              });
            } else if (item.index === 4) { // 应用内文件分享的入口
              this.openDialog()
              this.controller.close()
            }
          })
        }, item => item.data.id)
      }
      .width("100%")
      .height($r('app.float.wh_value_hundred'))
      .margin({
        bottom: $r('app.float.margin_bottom_three_six')
      })
    }.width("100%")
  }
}