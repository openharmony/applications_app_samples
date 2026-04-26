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
 

import { commonEventManager } from '@kit.BasicServicesKit';
import { CommonEventData } from 'commonEvent/commonEventData';
import EventManager from '../event/EventManager';
import Log from '../Log';
import { SCREEN_CHANGE_EVENT } from '../ScreenLockManager';

export interface CommonEventManager {
  subscriberCommonEvent: () => Promise<void>;
  unSubscriberCommonEvent: () => void;
  applyPolicy: (policys: Array<POLICY>) => void;
  release: () => void;
}

export enum POLICY {
  SCREEN_POLICY = 'screenOnOffPolicy',
}

type ClearPolicy = () => void;
export interface SubscribeInfos {
  events: string[];
}
interface InnerManager {
  subscriberCommonEvent: () => Promise<void>;
  unSubscriberCommonEvent: () => void;
}

// getCommonEventManager 工厂函数而非单例，允许每个业务模块持有独立的订阅器实例，
// 这样各模块可以独立控制订阅/取消订阅的生命周期，避免一个模块的注销误伤其他模块的监听器。
export function getCommonEventManager(
  tag: string,
  subscribeInfos: SubscribeInfos,
  commonEventCallback: (data: CommonEventData) => void,
  subscribeStateChange?: (isSubscribe: boolean) => void
): CommonEventManager {
  return new CommonEventManagerImpl(tag, subscribeInfos, commonEventCallback, subscribeStateChange);
}

function screenPolicy(manager: InnerManager): ClearPolicy {
  return EventManager.subscribe(SCREEN_CHANGE_EVENT, (isScreenOn: string | number | boolean | Object | undefined) => {
    const screenOn: boolean = Boolean(isScreenOn);
    screenOn ? manager.subscriberCommonEvent() : manager.unSubscriberCommonEvent();
  });
}

class CommonEventManagerImpl implements CommonEventManager {
  private tag: string;
  private subscribeInfos: SubscribeInfos;
  private callback: (data: CommonEventData) => void;
  private stateChange?: (isSubscribe: boolean) => void;
  private unSubscribers: Array<() => void> = [];
  private policyClearCb: Map<POLICY, ClearPolicy> = new Map();

  constructor(
    tag: string,
    subscribeInfos: SubscribeInfos,
    callback: (data: CommonEventData) => void,
    stateChange?: (isSubscribe: boolean) => void
  ) {
    this.tag = `CommonEvent_${tag}`;
    this.subscribeInfos = subscribeInfos;
    this.callback = callback;
    this.stateChange = stateChange;
  }

  async subscriberCommonEvent(): Promise<void> {
    Log.showDebug(this.tag, 'registerSubscriber start');
    let subscriber = await commonEventManager.createSubscriber(this.subscribeInfos);
    commonEventManager.subscribe(subscriber, (err, data) => {
      if (err.code != 0) {
        Log.showError(this.tag, `Can't handle common event, err: ${JSON.stringify(err)}`);
        return;
      }
      Log.showDebug(this.tag, `handle common event: ${data.event}`);
      this.callback(data);
    });
    this.unSubscribers.push(() => commonEventManager.unsubscribe(subscriber));
    if (this.stateChange) {
      this.stateChange(true);
    }
    Log.showDebug(this.tag, `registerSubscriber success, size: ${this.unSubscribers.length}`);
  }

  unSubscriberCommonEvent(): void {
    Log.showDebug(this.tag, `UnSubcribers size: ${this.unSubscribers.length}`);
    this.unSubscribers.forEach((unsubscribe) => unsubscribe());
    this.unSubscribers = [];
    if (this.stateChange) {
      this.stateChange(false);
    }
  }

  applyPolicy(policys: Array<POLICY>): void {
    policys.forEach((policy) => {
      if (!this.policyClearCb.has(policy)) {
        if (policy === POLICY.SCREEN_POLICY) {
          this.policyClearCb.set(policy, screenPolicy(this));
        }
        Log.showDebug(this.tag, `apply policy: ${policy}`);
      }
    });
  }

  release(): void {
    this.policyClearCb.forEach((cb) => cb());
    this.policyClearCb.clear();
    this.unSubscriberCommonEvent();
  }
}
