/*
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
import { emitter } from '@kit.BasicServicesKit';

export abstract class EventBusPayloadLike {
}

export type EventBusData = string | number | boolean | EventBusPayloadLike | Array<number> | Array<Array<number>>;

type EventBusCallback = (data?: string) => void;

/// 事件通知工具类
export abstract class EventBus {
  private static listeners: Map<string, Array<EventBusCallback>> = new Map();

  static send(
    eventID: string,
    eventData?: EventBusData | null,
  ) {
    let data: string | undefined
    if (eventData !== null && eventData !== undefined) {
      if (typeof eventData === 'string') {
        data = eventData
      } else if (typeof eventData === 'number' || typeof eventData === 'boolean') {
        data = String(eventData)
      } else {
        data = JSON.stringify(eventData)
      }
    }

    emitter.emit(
      eventID,
      {
        priority: emitter.EventPriority.HIGH
      },
    );

    const callbacks = EventBus.listeners.get(eventID) ?? [];
    for (let i = 0; i < callbacks.length; i++) {
      callbacks[i](data);
    }
  }

  static listen<T>(
    eventID: string,
    callback: (data?: T) => void,
  ) {
    const wrapped: EventBusCallback = (data?: string) => {
      if (data == undefined) {
        callback(undefined)
      } else {
        if ((data.startsWith('{') && data.endsWith('}')) || (data.startsWith('[') && data.endsWith(']'))) {
          callback(JSON.parse(data) as T)
        } else {
          callback(data as T)
        }
      }
    };
    const callbacks = EventBus.listeners.get(eventID) ?? [];
    callbacks.push(wrapped);
    EventBus.listeners.set(eventID, callbacks);

    emitter.on(
      eventID,
      (_eventData: emitter.EventData) => {
      },
    );
  }

  static cancel(eventID: string) {
    EventBus.listeners.delete(eventID);
    emitter.off(eventID);
  }
}
