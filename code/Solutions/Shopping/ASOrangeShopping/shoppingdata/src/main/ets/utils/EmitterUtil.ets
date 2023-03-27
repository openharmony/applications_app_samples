/*
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import emitter from '@ohos.events.emitter';

import { logger } from './Logger';

export class EmitterUtil {
  static readonly GOODS_CHANGE_ID = 1025;

  // 通过emitter发布当前商品数量更新的事件
  public changeGoods(goodsId:string, count:number): void {
    let addToShoppingCartId = {
      eventId: EmitterUtil.GOODS_CHANGE_ID
    };
    let shoppingCartData = {
      data: {
        goodsId: goodsId,
        count: count
      }
    };
    this.emitEvent(addToShoppingCartId, shoppingCartData);
  }

  private emitEvent(innerEvent:emitter.InnerEvent, eventData:emitter.EventData): void {
    logger.info('emitter emitEvent');
    // 持续发布事件
    emitter.emit(innerEvent, eventData);
  }
}