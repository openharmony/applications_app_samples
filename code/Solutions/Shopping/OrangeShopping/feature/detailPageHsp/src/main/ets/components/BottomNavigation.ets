/*
* Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { EmitterClass } from '@ohos/emitter';
import { ProductDataModel } from '../model/DetailMode';
import curves from '@ohos.curves';

@Component
export struct BottomNavigation {
  @StorageProp('curBp') curBp: string = 'md';
  @Consume('pageStack') pageStack: NavPathStack;
  @Link goodItemData: ProductDataModel;
  private emitterClass: EmitterClass = new EmitterClass();
  @Link animateAppear: boolean; // 动画开始标识
  @Link animateScale: boolean; // 开始缩小动画标识
  @Link animatePath: boolean; // 开始路径动画标识
  @State animateSpring: boolean = false; // 开始弹簧动画标识
  @StorageLink('productCount') productCount: number = 0;

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
          AppStorage.SetOrCreate('nowIndex', 0)
          router.pushUrl({
            url: 'pages/Home'
          });
        })

        Column() {
          Stack({ alignContent: Alignment.TopEnd }) {
            Image($r('app.media.cart'))
              .width(22)
              .height(22)
              .rotate(this.animateSpring ? { angle: 10 } : { angle: 0 })

            Text(`${this.productCount}`)
              .borderRadius(10)
              .width(15)
              .height(15)
              .backgroundColor("#ea6055")
              .fontSize(10)
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .margin({ top: -10, right: -10 })
          }

          Text($r('app.string.shopping_cart'))
            .fontColor($r('app.color.blank'))
            .fontSize(10)
            .opacity(0.6)
            .margin({ top: 4 })
        }
        .width(74)
        .onClick(() => {
          AppStorage.setOrCreate('nowIndex', 2)
          router.pushUrl({
            url: 'pages/Home'
          });
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
        .onClick(() => {
          // 添加商品到购物车
          this.emitterClass.addGoods(this.goodItemData.id);
          // this.emitterClass.shoppingCartGoodsList

          // 准备显示动画
          this.animateAppear = !this.animateAppear;

          // 用0.5秒实现动画缩小，曲线使用EaseOut，特点是开始快，结束慢
          animateTo({ duration: 500, curve: Curve.EaseOut,
            onFinish: () => {
              // 用1秒实现动画曲线，曲线使用EaseIn，特点是开始慢，结束快
              animateTo({ duration: 1000, curve: Curve.EaseIn,
                onFinish: () => {
                  // 动画结束，将参数复原，及时移除动画视图
                  this.animateAppear = !this.animateAppear;
                  this.animatePath = !this.animatePath;
                  this.animateScale = !this.animateScale;
                  // 设置弹簧动画，初始速度100，质量1，刚度225，阻尼10，
                  // 建议从初始速度0，质量1，刚度225，阻尼30，开始调参，这是临届阻尼的参数
                  // 如果觉得曲线一开始太慢了，可以把初速度加大
                  this.animateSpring = !this.animateSpring;
                  // interpolatingSpring的参数需要调试，通过调试找到自己想要的效果
                  animateTo({ duration: 1, curve: curves.interpolatingSpring(100, 1, 225, 10), iterations: 1 }, () => {
                    // 开始弹簧动画
                    this.animateSpring = !this.animateSpring;
                    // 更改数字
                    this.productCount = this.productCount + 1;
                  })
                } }, () => {
                // 开始路径动画
                this.animatePath = !this.animatePath;
              })
            } }, () => {
            // 开始缩小动画
            this.animateScale = !this.animateScale;
          })

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

