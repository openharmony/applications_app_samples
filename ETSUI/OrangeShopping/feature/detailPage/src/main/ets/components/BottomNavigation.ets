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
import prompt from '@ohos.prompt'
import { EmitterClass } from '@ohos/emitter'
import { ProductDataModel } from '../model/DetailMode'

@Component
export struct BottomNavigation {
  @StorageProp('curBp') curBp: string = 'md'
  @Link goodItemData: ProductDataModel
  private emitterClass: EmitterClass = new EmitterClass()

  build() {
    Row() {
      Row() {
        Column() {
          Image($r('app.media.home'))
            .width(22)
            .height(22)
          Text($r('app.string.home_page'))
            .fontColor($r('app.color.blank'))
            .fontSize(10)
            .opacity(0.6)
            .margin({ top: 4 })
        }
        .width(74)
        .onClick(() => {
          AppStorage.SetOrCreate('nowIndex',0)
          router.push({
            url: 'pages/Home'
          })
        })

        Column() {
          Image($r('app.media.cart'))
            .width(22)
            .height(22)
          Text($r('app.string.shopping_cart'))
            .fontColor($r('app.color.blank'))
            .fontSize(10)
            .opacity(0.6)
            .margin({ top: 4 })
        }
        .width(74)
        .onClick(() => {
          AppStorage.SetOrCreate('nowIndex',2)
          router.push({
            url: 'pages/Home'
          })
        })
      }
      .justifyContent(this.curBp === 'sm' ? FlexAlign.SpaceEvenly : FlexAlign.Start)
      .layoutWeight(1)

      Row() {
        Row() {
          Text($r('app.string.add_to_cart'))
            .fontColor($r('app.color.white'))
            .fontSize(this.curBp === 'sm' ? 16 : 20)
        }
        .alignItems(VerticalAlign.Center)
        .padding({ left: 20, right: 20 })
        .onClick(()=>{
          this.emitterClass.addGoods(this.goodItemData.id)
        })

        Row() {
          Text($r('app.string.buy_now'))
            .fontColor($r('app.color.white'))
            .fontSize(this.curBp === 'sm' ? 16 : 20)
        }
        .alignItems(VerticalAlign.Center)
        .padding({ left: 20, right: 20 })
      }
      .height('100%')
      .borderRadius(50)
      .clip(true)
      .backgroundImage($r('app.media.carton'))
      .backgroundImagePosition(Alignment.Center)
    }
    .width('100%')
    .padding({ right: 20, top: 10, bottom: 10 })
    .height(56)
    .backgroundColor($r('app.color.divider'))
  }
}