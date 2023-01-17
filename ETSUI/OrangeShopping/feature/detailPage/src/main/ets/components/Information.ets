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

import router from '@ohos.router'
import prompt from '@ohos.promptAction'
import workScheduler from '@ohos.resourceschedule.workScheduler'
import { logger } from '../utils/Logger'
import { ButtonDialogBuilder } from '@ohos/sharecomponent'

const SRC_IMG = 'https://res5.vmallres.com/pimages/uomcdn/CN/pms/202207/gbom/6941487270880/428_428_1142FAB7EA4DCBDD8C64BF54486A7D4Bmp.png'
const TAG: string = 'Information'

@Component
export struct Information {
  @State collected: boolean = false
  private data: any[] = router.getParams()['goodItem']
  @State recommend: string = ''
  @State commodity: string = ''

  aboutToAppear() {
    let context: Context = getContext(this)
    this.recommend = context.resourceManager.getStringSync($r('app.string.recommend').id)
    this.commodity = context.resourceManager.getStringSync($r('app.string.commodity').id)
  }

  // 分享弹框
  controller: TabsController = new TabsController()
  shareDialog: CustomDialogController

  build() {
    Column() {
      Text() {
        Span(this.data['price'])
          .fontSize(20)
          .fontColor($r('app.color.pink'))
      }
      .fontWeight(500)

      Text(this.data['title'])
        .fontSize(16)
        .margin({ top: 4 })
      Row() {
        Row({ space: 6 }) {
          Image($r("app.media.share_small"))
            .width(14)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
          Text($r('app.string.share'))
            .fontSize(10)
            .fontColor($r('app.color.blank'))
            .margin({ left: 4 })
        }
        .opacity(0.6)
        .onClick(() => {
          this.shareDialog = new CustomDialogController({
            builder: ButtonDialogBuilder({
              controller: this.shareDialog,
              detail0: this.recommend,
              detail1: '9800',
              title: this.commodity,
              srcImg: SRC_IMG
            }),
            cancel: undefined,
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            customStyle: true,
          })
          this.shareDialog.open()
        })

        Row() {
          Image(this.collected ? $r('app.media.collected') : $r('app.media.collect'))
            .width(14)
            .aspectRatio(1)
          Text($r('app.string.collection'))
            .fontSize(12)
            .fontColor($r('app.color.blank'))
            .margin({ left: 4 })
        }
        .opacity(0.6)
        .onClick(() => {
          this.collected = !this.collected
        })

        Row({ space: 6 }) {
          Image($r('app.media.attention'))
            .width(14)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
          Text($r('app.string.price_reduction_notice'))
            .fontSize(12)
            .fontColor($r('app.color.blank'))
            .margin({ left: 4 })
        }
        .opacity(0.6)
        .onClick(() => {
          let workInfo = {
            workId: 1,
            networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
            bundleName: 'ohos.samples.orangeshopping',
            abilityName: 'WorkAbility',
            parameters: {
              title: getContext(this).resourceManager.getStringSync($r('app.string.reduction_notice')),
              firstButton: getContext(this).resourceManager.getStringSync($r('app.string.close')),
              secondButton: getContext(this).resourceManager.getStringSync($r('app.string.go_to_view'))
            }
          }
          try {
            workScheduler.startWork(workInfo)
            prompt.showToast({ message: $r('app.string.subscribe_notice') })
          } catch (error) {
            logger.info(TAG, `startWork error ${JSON.stringify(error)}`)
          }
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ top: 12 })
    }
    .padding({ top: 16, bottom: 16, right: 12, left: 12 })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
  }
}