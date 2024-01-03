/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import PayView from '../component/payView';
import TitleBar from '../component/TitleBar';
import { PayResult } from '@ohos/cloud';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Index {
  @State isPaying: boolean = false;
  @StorageLink('totalPrice') totalPrice: string = '';
  @StorageLink('orderId') orderId: string = '';
  @State isPaySuccess: boolean = false;
  @State countdownNum: number = 3;
  private timeOut: number = 0;
  private context = getContext(this) as common.UIAbilityContext;
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: PayView({ payComplete: (result: PayResult) => {
      switch (result) {
        case PayResult.SUCCESS:
          this.isPaySuccess = true;
          this.dialogController.close();
          this.timeOut = setInterval(() => {
            this.countdownNum--;
            if (this.countdownNum === 0) {
              this.timeOut = 0;
              this.context.terminateSelf();
            }
          }, 1000);
          break;
        case PayResult.FAIL:
          promptAction.showToast({ message: $r('app.string.pay_fail') });
          break;
        case PayResult.ERROR:
          this.dialogController.close();
          promptAction.showToast({ message: $r('app.string.pay_exception') });
          break;
        default:
          this.dialogController.close();
          promptAction.showToast({ message: $r('app.string.pay_exception') });
          break;
      }
    } }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false
  })

  aboutToDisappear() {
    if (this.timeOut) {
      this.timeOut = 0;
    }
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.pay') })
      Column() {
        if (this.isPaySuccess) {
          Column() {
            Row() {
              Image($r('app.media.ic_public_confirm'))
                .height(48)
                .width(48)
            }
            .height(72)
            .width(72)
            .borderRadius(36)
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.icon_background'))

            Text($r('app.string.pay_success'))
              .fontSize(20)
              .margin({ top: 24 })
              .fontWeight(500)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontColor($r('app.color.normal_font_color'))

            Button() {
              Text() {
                Span($r('app.string.return_to_merchant'))
                  .fontColor(Color.White)
                  .fontSize(16)
                  .fontWeight(500)
                Span(`（${this.countdownNum}）`)
                  .fontColor(Color.White)
                  .fontSize(16)
                  .fontWeight(500)
              }
              .id('to_merchant')
              .textAlign(TextAlign.Center)
              .width('100%')
              .height('100%')
            }
            .height(39)
            .width(180)
            .margin({ top: 101 })
            .onClick(() => {
              this.timeOut = 0;
              this.context.terminateSelf();
            })
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
        } else {
          Text($r('app.string.merchant_tracking_number'))
            .textAlign(TextAlign.Center)
            .width('100%')
            .fontColor(Color.Black)
            .opacity(0.9)
            .fontSize(16)
            .fontWeight(500)
            .margin({ top: 48 })
          Text(`${this.orderId}`)
            .fontColor(Color.Black)
            .opacity(0.9)
            .fontSize(14)
            .margin({ top: 8 })
          Text($r('app.string.please_pay'))
            .fontColor(Color.Black)
            .fontWeight(500)
            .opacity(0.9)
            .fontSize(20)
            .margin({ top: 32 })
          Text(`${this.totalPrice}`)
            .fontColor(Color.Black)
            .opacity(0.9)
            .fontSize(38)
            .fontWeight(500)
            .margin({ top: 52 })
          Button($r('app.string.pay_now'))
            .width(180)
            .height(39)
            .margin({ top: 135 })
            .onClick(() => {
              this.dialogController.open()
            })
        }
      }
      .backgroundColor(Color.White)
      .margin({ left: 12, right: 12, bottom: 24 })
      .border({ radius: 16 })
      .layoutWeight(1)
    }
    .height('100%')
    .backgroundColor($r('app.color.normal_background'))
  }
}