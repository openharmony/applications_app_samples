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

import emitter from '@ohos.events.emitter';
import Logger from './Logger';

const TAG: string = 'LooperUtil';

export class LooperUtil {
  public static readonly IMMEDIATE: number = emitter.EventPriority.IMMEDIATE;
  public static readonly HIGH_PRIORITY: number = emitter.EventPriority.HIGH;
  public static readonly LOW_PRIORITY: number = emitter.EventPriority.LOW;
  public static readonly IDLE_PRIORITY: number = emitter.EventPriority.IDLE;

  public static on(event: number, callBack: (eventData?: emitter.EventData) => void,
    priority: number = LooperUtil.LOW_PRIORITY): void {
    Logger.info(TAG, `event ${event} with property ${priority}`);
    emitter.on({
      eventId: event,
      priority: priority
    }, callBack);
  }

  public static off(event: number, callBack?: (eventData?: emitter.EventData) => void): void {
    if (callBack) {
      emitter.off(event, callBack);
      return;
    }
    emitter.off(event);
  }

  public static emit(event: number, data?: emitter.EventData, priority: number = LooperUtil.LOW_PRIORITY): void {
    Logger.info(TAG, `emit data for event ${event}`);
    emitter.emit({
      eventId: event,
      priority: priority
    }, data ?? {});
  }
}
