/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import displaySetting from '@ohos.tvservice.displaySetting';
import { SourcePlugState } from '../manager/SourceManager';

/**
 * 多个页面监听输入源状态管理类
 */

export class MultiPageListenerManager {
  private readonly listenerMap: Map<string, MultiPageListenerType> = new Map();
  private static instance: MultiPageListenerManager;

  //获取管理单例
  public static getInStance(): MultiPageListenerManager {
    if (!MultiPageListenerManager.instance) {
      MultiPageListenerManager.instance = new MultiPageListenerManager();
    }
    return MultiPageListenerManager.instance;
  }

  //注册监听
  public register(listener: MultiPageListenerType): void {
    if (listener) {
      console.log('listener register', listener.id);
      if (this.listenerMap.has(listener.id)) {
        console.log('listener register repate', listener.id);
      }
    }

    this.listenerMap.set(listener.id, listener);
  }

  //取消注册监听
  public unregister(listener: MultiPageListenerType): void {
    if (listener) {
      console.log('listener unregister', listener.id);
      let event = this.listenerMap.get(listener.id);
      if (event && event === listener) {
        this.listenerMap.delete(listener.id);
      }
    }
  }

  public onPlugChange(plugState: SourcePlugState) {
    this.listenerMap.forEach((listener) => {
      listener.onPlugChange?.(plugState);
    });
  }
}

export class MultiPageListenerType {
  public id: string = '';
  /**
   * 多个页面输入源状态变化回调
   */
  public onPlugChange?: (plugState: SourcePlugState) => void;
}
