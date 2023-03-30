/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import GoodsInfo from '../model/GoodsModel';

import { GOODS_DATA_ROOT} from '../data/GoodsData';

class Want {
  bundleName: string;
  abilityName: string;
  moduleName?: string;
  parameters?: {[key: string]: Object};
}

export default class RouterUtil {
  private static bundleName: string = 'com.samples.asorangeshopping';
  private static context:common.UIAbilityContext = undefined;

  public static gotoProductDetail(goods:GoodsInfo): void {
    let want:Want = {
      bundleName: this.bundleName,
      abilityName: 'ProductDetailAbility',
      moduleName: 'productdetail',
      parameters: {
        goods: goods,
        goodsDataRoot: GOODS_DATA_ROOT,
        context: this.context
      }
    };
    this.startAbility(want);
  }

  public static gotoUserCenter(): void {
    let want:Want = {
      bundleName: this.bundleName,
      abilityName: 'UserCenterAbility',
      moduleName: 'usercenter'
    };
    this.startAbility(want);
  }

  public static setContext(context): void {
    this.context = context as common.UIAbilityContext;
  }

  private static startAbility(want): void {
    this.context.startAbility(want);
  }
}

