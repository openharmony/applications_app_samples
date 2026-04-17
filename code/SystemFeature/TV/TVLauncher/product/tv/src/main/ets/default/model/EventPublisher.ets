/**
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { AppItemInfo } from '../../common/bean/AppItemInfo';

type EventData = AppItemInfo
type Handler = (data: EventData) => void

class EventHandlerGroup {
  public type: string = ''
  public handlers: Handler[] = []
}

class IEventPusher {
  private handlers: EventHandlerGroup[] = [];
  public static EVENT_PUBLISHER: IEventPusher;

  constructor() {
    this.handlers = [];
  }

  public static getEventPublisher(): IEventPusher {
    if (IEventPusher.EVENT_PUBLISHER == null) {
      IEventPusher.EVENT_PUBLISHER = new IEventPusher();
    }
    return IEventPusher.EVENT_PUBLISHER;
  }

  private findGroupIndex(type: string): number {
    return this.handlers.findIndex((item: EventHandlerGroup): boolean => item.type === type)
  }

  on(type: string, handler: Handler): IEventPusher {
    const index = this.findGroupIndex(type)
    if (index < 0) {
      const group = new EventHandlerGroup()
      group.type = type
      group.handlers.push(handler)
      this.handlers.push(group)
      return this
    }
    this.handlers[index].handlers.push(handler)
    return this
  }

  off(type: string, handler: Handler): IEventPusher {
    const index = this.findGroupIndex(type)
    if (index < 0) {
      console.warn(`${type} not exist`)
      return this
    }
    this.handlers[index].handlers = this.handlers[index].handlers.filter((item: Handler): boolean => item !== handler)
    return this
  }

  emit(type: string, data: EventData): void {
    const index = this.findGroupIndex(type)
    if (index < 0) {
      console.warn(`event type:${type} not exist`)
      return
    }
    this.handlers[index].handlers.forEach((handler: Handler): void => {
      handler(data)
    })
  }
}


let iEventPublisher: IEventPusher = IEventPusher.getEventPublisher();

export default iEventPublisher;