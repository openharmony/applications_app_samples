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
import { Location } from '../components/Location'
import { Information } from '../components/Information'
import { Choice } from '../components/Choice'
import { AddressService } from '../components/AddressService'
import { Valuation } from '../components/Valuation'
import { BottomNavigation } from '../components/BottomNavigation'
import { VideoPage, SmallVideo } from '@ohos/video-component'
import { SWIPER_PICTURE_DATA } from '../mock/DetailData'
import { ButtonDialogBuilder } from '@ohos/sharecomponent'

const SRC_IMG = 'https://res5.vmallres.com/pimages/uomcdn/CN/pms/202207/gbom/6941487270880/428_428_1142FAB7EA4DCBDD8C64BF54486A7D4Bmp.png'

@Component
export struct DetailPage {
  @State sOpacity: number = 1
  @State isPanel: boolean = false
  @State goodDetailData: any[] = router.getParams()['goodItem']
  @State currentLocation: string = ''
  @State recommend: string = ''
  @State commodity: string = ''
  @State swiperIndex: number = 0
  // Video组件
  @State isHidden: boolean = false
  @State isState: boolean = true
  @State isCancel: boolean = true
  @State activeVideo: number = 0
  @State openFirst: boolean = false
  @Provide('playTime') playNum: number = 20
  @StorageProp('curBp') curBp: string = 'md'
  private shareDialog: CustomDialogController
  private scroller: Scroller = new Scroller()

  build() {
    Stack() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          Stack({ alignContent: Alignment.BottomEnd }) {
            Swiper() {
              VideoPage({ isStart: $openFirst })
              ForEach(SWIPER_PICTURE_DATA, item => {
                Column() {
                  Image(this.goodDetailData['uri'])
                    .width('100%')
                    .aspectRatio(1)
                }
                .width('100%')
              })
            }
            .height(300)
            .index(this.swiperIndex)
            .indicator(false)
            .onChange((index: number) => {
              this.swiperIndex = index
            })

            Row() {
              Text(`${this.swiperIndex + 1}/${SWIPER_PICTURE_DATA.length + 1}`)
                .fontSize(12)
                .fontColor($r('app.color.white'))
            }
            .width(46)
            .height(24)
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.bg3'))
            .margin({ right: 16, bottom: 16 })
          }
          .width('100%')
          .height(300)
          .backgroundColor($r('app.color.white'))

          Column() {
            Information()
              .margin({ top: 12 })
            Choice()
              .margin({ top: 12 })
            AddressService({ currentLocation: $currentLocation, isPanel: $isPanel })
              .margin({ top: 12 })
            Valuation()
              .margin({ top: 12 })
          }
          .padding({ left: 12, right: 12 })
        }
        .width('100%')
      }
      .width('100%')
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .padding({ bottom: this.curBp === 'sm' ? 86 : 106 })
      .onScroll(() => {
        if (this.activeVideo === 0 && this.openFirst) {
          if (this.scroller.currentOffset().yOffset > 450) {
            if (this.isState) {
              this.isHidden = true
              this.isState = false
            }
          } else {
            this.isHidden = false
            this.isState = true
          }
        }
      })

      BottomNavigation({ goodItemData: $goodDetailData })
        .position({ x: 0, y: '100%' })
        .translate({ x: 0, y: '-100%' })
      SmallVideo({ isHidden: $isHidden, isCancel: $isCancel })
        .position({ x: '100%', y: '60%' })
        .translate({ x: -180, y: 0 })
      Panel(this.isPanel) {
        Location({ isPanel: $isPanel, currentLocation: $currentLocation })
      }
      .mode(PanelMode.Half)
      .dragBar(false)
      .halfHeight(this.curBp === 'sm' ? 650 : 530)
      .miniHeight(0)
      .onChange(() => {
        this.isPanel = false
      })

      Image($r('app.media.back'))
        .width(32)
        .aspectRatio(1)
        .position({ x: 20, y: 20 })
        .onClick(() => {
          router.back()
        })
      Image($r("app.media.share"))
        .width(32)
        .aspectRatio(1)
        .position({ x: '100%', y: 20 })
        .translate({ x: -62, y: 0 })
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
            customStyle: true
          })
          this.shareDialog.open()
        })
      Column({ space: 12 }) {
        Image($r('app.media.broadcast'))
          .width(32)
          .height(32)
        Text($r('app.string.broadcast'))
          .fontSize(14)
          .fontColor($r('app.color.blank'))
      }
      .width(62)
      .height(78)
      .borderWidth(0.5)
      .borderColor($r('app.color.border'))
      .borderRadius(16)
      .padding(6)
      .backgroundColor($r('app.color.light_white'))
      .position({ x: '100%', y: 160 })
      .translate({ x: -82, y: 0 })
      .onClick(() => {
        router.push({ url: 'pages/LivePage' })
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.divider'))
  }

  aboutToAppear() {
    let context: Context = getContext(this)
    this.currentLocation = context.resourceManager.getStringSync($r('app.string.address').id)
    this.recommend = context.resourceManager.getStringSync($r('app.string.recommend').id)
    this.commodity = context.resourceManager.getStringSync($r('app.string.commodity').id)
  }
}