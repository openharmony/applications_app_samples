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

import cryptoFramework from '@ohos.security.cryptoFramework';
import util from '@ohos.util';
import { PayServer, PayResult } from '@ohos/cloud';

const USER_NAME = 'test';
const TEXT_ENCODER = new util.TextEncoder();
const BASE64 = new util.Base64Helper();
const DEFAULT_PASSWORD_COUNT = 6;
const PASSWORD_KEYBOARD = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'X'];
const PAY_CLIENT_PUB_KEY = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD78dAOHsfOuBA4gPMA8GO/5KlQ4877KAvaTkpJIDAkaAblhAAx4mKGa4K4PTS7TxzjXdEg/CZOAdnqspuMpQf25POycuG2yHWo3jPOrb7ktkf0aj5TnRW3kaBhZ5TyE6MxnUCJh+HkX8EQp6WGaqKCBw5D1Fg9oA0rgZigi6nD/wIDAQAB';


@CustomDialog
export default struct PayView {
  @State passwordBoxArr: Array<boolean> = new Array(DEFAULT_PASSWORD_COUNT).fill(false);
  @State passWord: string = '';
  @StorageLink('platformName') platformName: string = '';
  @StorageLink('totalPrice') totalPrice: string = '';
  private controller: CustomDialogController;
  private payComplete: (result: PayResult) => void = () => {
  };
  private payClientKey: cryptoFramework.KeyPair | null = null;

  private async pay() {
    if (!this.payClientKey) {
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
      this.payClientKey = await rsaGenerator.convertKey({ data: BASE64.decodeSync(PAY_CLIENT_PUB_KEY) }, null);
    }
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, this.payClientKey.pubKey, null);
    let userNameBlob = await cipher.doFinal({ data: TEXT_ENCODER.encodeInto(USER_NAME) });
    let passwordBlob = await cipher.doFinal({ data: TEXT_ENCODER.encodeInto(this.passWord) });
    let payServer: PayServer | undefined = AppStorage.get("PayServer");
    if (!payServer) {
      this.payComplete(PayResult.ERROR);
      return;
    }
    let result: PayResult = await payServer.pay(AppStorage.get("orderString"), BASE64.encodeToStringSync(userNameBlob.data), BASE64.encodeToStringSync(passwordBlob.data));
    if (PayResult.FAIL === result) {
      this.passWord = '';
      this.passwordBoxArr.fill(false);
    }
    this.payComplete(result);
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text($r('app.string.enter_password'))
          .fontColor($r('app.color.normal_font_color'))
          .fontWeight(500)
          .fontSize(14)
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ top: 14 })
        Row() {
          Image($r('app.media.ic_public_back'))
            .id('btnBack')
            .width(24)
            .height(24)
            .margin({ left: 24, top: 14 })
        }
        .height('100%')
        .width(100)
        .onClick(() => {
          this.controller.close();
        })
      }
      .height(38)
      .width('100%')

      Text() {
        Span($r('app.string.pay_to'))
          .fontColor($r('app.color.normal_font_color'))
          .fontSize(16)
        Span(`${this.platformName}`)
          .fontColor($r('app.color.normal_font_color'))
          .fontSize(16)
        Span($r('app.string.platform_merchants'))
          .fontColor($r('app.color.normal_font_color'))
          .fontSize(16)
      }
      .margin({ top: 26 })

      Text(`${this.totalPrice}`)
        .margin({ top: 8 })
        .fontWeight(500)
        .fontColor($r('app.color.normal_font_color'))
        .fontSize(30)
      Row() {
        ForEach(this.passwordBoxArr,
          (item: boolean, index: number) => {
            Column() {
              Row() {
                Row()
                  .height(8)
                  .width(8)
                  .borderRadius(8)
                  .backgroundColor(item ? Color.Black : '')
              }
              .height(32)
              .width(32)
              .padding(12)
              .backgroundColor($r('app.color.normal_background'))
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)
          })
      }
      .margin({ top: 82 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(PASSWORD_KEYBOARD, (item: string, index: number) => {
          Text(item)
            .height(48)
            .textAlign(TextAlign.Center)
            .width('33.33%')
            .fontColor($r('app.color.normal_font_color'))
            .fontSize(20)
            .border({
              color: $r('app.color.normal_border_color'),
              width: { top: 0.5, right: (index % 3 === 2) ? 0 : 0.5 }
            })
            .onClick(async () => {
              if (!item) {
                return;
              }
              if (item === 'X') {
                if (!this.passWord) {
                  return;
                }
                this.passwordBoxArr[this.passWord.length - 1] = false;
                this.passWord = this.passWord.slice(0, -1);
                return;
              }
              if (this.passWord.length >= DEFAULT_PASSWORD_COUNT) {
                return;
              }
              this.passwordBoxArr[this.passWord.length] = true;
              this.passWord += item;
              if (this.passWord.length === DEFAULT_PASSWORD_COUNT) {
                await this.pay();
              }
            })
        })
      }
      .margin({ top: 24 })
    }
    .border({ radius: { topLeft: 32, topRight: 32 } })
    .backgroundColor(Color.White)
    .width('100%')
    .height(468)
  }
}