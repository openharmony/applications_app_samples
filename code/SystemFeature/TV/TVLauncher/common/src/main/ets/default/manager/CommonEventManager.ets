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

import { commonEventManager as kitCommonEvent, AsyncCallback } from '@kit.BasicServicesKit';

/**
 * Wrapper class for CommonEvent.
 */
class CommonEventManager {
  public RECENT_FULL_SCREEN = 'CREATE_RECENT_WINDOW_EVENT';
  public RECENT_SPLIT_SCREEN = 'common.event.SPLIT_SCREEN';

  private callbackList: AsyncCallback<kitCommonEvent.CommonEventData>[] = [];
  private subscriberList: kitCommonEvent.CommonEventSubscriber[] = [];

  /**
   * get CommonEventManager instance
   *
   * @return CommonEventManager singleton
   */
  static getInstance(): CommonEventManager {
    if (globalThis.CommonEventManager == null) {
      globalThis.CommonEventManager = new CommonEventManager();
    }
    return globalThis.CommonEventManager;
  }

  private constructor() {
  }

  /**
   * Register common event listener.
   */
  public registerCommonEvent(
    subscriber: kitCommonEvent.CommonEventSubscriber,
    eventCallback: AsyncCallback<kitCommonEvent.CommonEventData>
  ): void {
    if (this.subscriberList.indexOf(subscriber) != -1) {
      return;
    }
    kitCommonEvent.subscribe(subscriber, eventCallback);
    this.subscriberList.push(subscriber);
    this.callbackList.push(eventCallback);
  }

  /**
   * Unregister common event listener.
   */
  public unregisterCommonEvent(
    subscriber: kitCommonEvent.CommonEventSubscriber,
    eventCallback: AsyncCallback<kitCommonEvent.CommonEventData>
  ): void {
    const subscriberIndex: number = this.subscriberList.indexOf(subscriber);
    const callbackIndex: number = this.callbackList.indexOf(eventCallback);
    if (subscriberIndex != -1) {
      kitCommonEvent.unsubscribe(subscriber);
      this.subscriberList.splice(subscriberIndex, 1);
    }
    callbackIndex != -1 && this.callbackList.splice(callbackIndex, 1);
  }
}

const commonEventManager = CommonEventManager.getInstance();
export default commonEventManager;
