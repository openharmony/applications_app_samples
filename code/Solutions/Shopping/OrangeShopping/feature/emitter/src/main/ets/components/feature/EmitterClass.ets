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

class EventsId {
  eventId: number;

  constructor(eventId: number) {
    this.eventId = eventId;
  }
}

export class EventsData {
  data: Data;

  constructor(data: Data) {
    this.data = data;
  }
}

class Data {
  id: number

  constructor(id: number) {
    this.id = id;
  }
}

export class EmitterClass {
  shoppingCartGoodsList: EventsData[] = [];

  // 单次订阅回调
  public showEventsDialog(callback: () => void): void {
    let dialogShowEventsId: EventsId = new EventsId(EmitterConst.DIALOG_EVENT_ID);
    let dialogShowEventsData: EventsData = new EventsData(new Data(EmitterConst.DIALOG_EVENT_ID));
    // 单次订阅事件--广告
    emitter.once(dialogShowEventsId, callback);
    // 事件发布
    emitter.emit(dialogShowEventsId, dialogShowEventsData);
  }

  // 持久化订阅的事件回调
  public setShoppingCartGoodsList(callback: Function): void {
    let addGoodDataId: EventsId = new EventsId(EmitterConst.ADD_EVENT_ID);
    // 以持久化方式订阅购物车添加事件并接收事件回调
    emitter.off(EmitterConst.ADD_EVENT_ID);
    emitter.on(addGoodDataId, (eventData: EventsData) => {
      callback(eventData);
    });
  }

  public addGoods(goodId: number): void {
    let addToShoppingCartId: EventsId = new EventsId(EmitterConst.ADD_EVENT_ID);
    let shoppingCartData: EventsData = new EventsData(new Data(goodId));
    // 持续订阅发布事件
    emitter.emit(addToShoppingCartId, shoppingCartData);
  }
}