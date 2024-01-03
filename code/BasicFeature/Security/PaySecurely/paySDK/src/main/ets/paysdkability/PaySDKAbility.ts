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

import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import type window from '@ohos.window';

const INDEX_ZERO = 0;
const INDEX_ONE = 1;
const INDEX_TWO = 2;
const INDEX_THREE = 3;
const INDEX_FOUR = 4;
const INDEX_FIVE = 5;
const PARAM_LENGTH = 6;
const MIN_LENGTH = 2;

export default class PaySdkAbility extends UIAbility {
  onCreate(want, launchParam): void {
    this.verifyParameters(want);
  }

  onNewWant(want): void {
    this.verifyParameters(want);
  }

  private verifyParameters(want): void {
    AppStorage.setOrCreate("orderString", "");
    if (want.hasOwnProperty('parameters') && want.parameters.hasOwnProperty('orderString')) {
      let orderString: string = want.parameters.orderString;
      AppStorage.setOrCreate("orderString", orderString);
      let temArr = orderString.split('&');
      if (temArr.length < PARAM_LENGTH) {
        return;
      }
      let platformNameArr = temArr[INDEX_ZERO].split('=');
      let totalPriceArr = temArr[INDEX_ONE].split('=');
      let productNameArr = temArr[INDEX_TWO].split('=');
      let productIdArr = temArr[INDEX_THREE].split('=');
      let orderIdArr = temArr[INDEX_FOUR].split('=');
      let signerArr = temArr[INDEX_FIVE].split('=');
      if (platformNameArr.length < MIN_LENGTH || totalPriceArr.length < MIN_LENGTH ||
      productNameArr.length < MIN_LENGTH || productIdArr.length < MIN_LENGTH ||
      orderIdArr.length < MIN_LENGTH || signerArr.length < MIN_LENGTH) {
        return;
      }
      if (platformNameArr[INDEX_ZERO] !== 'platformName' || totalPriceArr[INDEX_ZERO] !== 'totalPrice' ||
      productNameArr[INDEX_ZERO] !== 'productName' || productIdArr[INDEX_ZERO] !== 'productId' ||
      orderIdArr[INDEX_ZERO] !== 'orderId' || signerArr[INDEX_ZERO] !== 'signer') {
        return;
      }
      AppStorage.SetOrCreate<string>('platformName', platformNameArr[INDEX_ONE]);
      AppStorage.SetOrCreate<string>('totalPrice', totalPriceArr[INDEX_ONE]);
      AppStorage.SetOrCreate<string>('orderId', orderIdArr[INDEX_ONE]);
    } else {
      return;
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }
}
