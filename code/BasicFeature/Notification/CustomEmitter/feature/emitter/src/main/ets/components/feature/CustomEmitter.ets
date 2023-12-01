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

import emitter from '@ohos.events.emitter';
import { EmitterConst } from '../../common/EmitterConst';
import Base from '@ohos.base';

class GoodsListInner {
  id: number = 0
}

class GoodsList {
  data: GoodsListInner = {
    id: 0
  }
}

export class CustomEmitter {
  shoppingCartGoodsList: GoodsList[] = [];

  // 单次订阅回调
  public showEventsDialog(callback: Base.Callback<emitter.EventData>) {
    let dialogShowEventsId: emitter.InnerEvent = {
      eventId: EmitterConst.DIALOG_EVENT_ID
    };
    let dialogShowEventsData: emitter.EventData = {
      data: {
        id: EmitterConst.DIALOG_EVENT_ID,
      }
    };
    // 单次订阅事件--广告
    emitter.once(dialogShowEventsId, callback);
    // 事件发布
    emitter.emit(dialogShowEventsId, dialogShowEventsData);
  }

  // 单次订阅回调(eventId为string类型)
  public closeEventsDialog(callback: Base.Callback<emitter.EventData>) {
    let dialogCloseEventsData: emitter.EventData = {
      data: {
        id: EmitterConst.CLOSE_DIALOG_EVENT_ID
      }
    };
    // 单次订阅事件--关闭广告
    emitter.once(EmitterConst.CLOSE_DIALOG_EVENT_ID, callback);
    // 事件发布
    emitter.emit(EmitterConst.CLOSE_DIALOG_EVENT_ID, dialogCloseEventsData);
  }

  // 持久化订阅的事件回调
  public setShoppingCartGoodsList(callback: (eventData: emitter.EventData) => void) {
    let addGoodDataId: emitter.InnerEvent = {
      eventId: EmitterConst.ADD_EVENT_ID
    };
    // 以持久化方式订阅购物车添加事件并接收事件回调
    emitter.off(EmitterConst.ADD_EVENT_ID);

    emitter.on(addGoodDataId, (eventData: emitter.EventData) => {
      callback(eventData);
    });
  }

  // 持久化订阅的事件回调(eventId为string类型)
  public deleteShoppingCartGoodsList(callback: (eventData: emitter.EventData) => void) {
    // 以持久化方式订阅购物车删除事件并接收事件回调
    emitter.off(EmitterConst.DELETE_EVENT_ID);
    emitter.on(EmitterConst.DELETE_EVENT_ID, (eventData: emitter.EventData) => {
      callback(eventData);
    });
  }

  public addGoods(goodId: number) {
    let addToShoppingCartId: emitter.InnerEvent = {
      eventId: EmitterConst.ADD_EVENT_ID
    };
    let shoppingCartData: emitter.EventData = {
      data: {
        id: goodId
      }
    };
    // 持续订阅发布事件
    emitter.emit(addToShoppingCartId, shoppingCartData);
  }

  public deleteGoods(listItemId: number) {
    console.info("setShoppingCartGoodsList goodId" + JSON.stringify(listItemId))
    let shoppingCartData: emitter.EventData = {
      data: {
        id: listItemId,
      }
    };
    // 持续订阅发布事件
    emitter.emit(EmitterConst.DELETE_EVENT_ID, shoppingCartData);
  }

  // 以持久化方式订阅购物车购买事件
  public listenerEvents() {
    emitter.on(EmitterConst.BUY_EVENT_ID, (eventData: emitter.EventData) => {
    });
  }

  // 获取购买事件订阅者数量并将结果返回
  public getListenerCounts(callback: (counts: number) => void) {
    callback(emitter.getListenerCount(EmitterConst.BUY_EVENT_ID));
  }

  // 取消订阅购买事件后将购买事件订阅者数量结果返回
  public clearListenerCounts(callback: (counts: number) => void) {
    emitter.off(EmitterConst.BUY_EVENT_ID);
    callback(emitter.getListenerCount(EmitterConst.BUY_EVENT_ID));
  }
}