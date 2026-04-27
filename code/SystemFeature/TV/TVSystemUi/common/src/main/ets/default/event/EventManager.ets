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
 

import { common } from '@kit.AbilityKit';
import Log from '../Log';
import createOrGet from '../SingleInstanceHelper';
import { START_ABILITY_EVENT, Event, LocalEvent, EventData } from './EventUtil';
import { Callback, createEventBus, EventBus, EventArg } from './EventBus';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { PluginType } from '../../plugindatasource/common/Constants';
import { writeFaultLog, FaultID } from '../SysFaultLogger';

export type unsubscribe = () => void;

export type Events = string | string[];

interface StartAbilityEventData {
  abilityName: string;
}

interface FaultLogData {
  CORE_SYSTEM: string;
  TARGET_API: string;
  FAULT_ID: FaultID;
  MSG: string;
}

const TAG = 'EventManager';

// EventManager 作为全局单例事件调度中枢，屏蔽了"进程内本地事件"、"跨应用 Ability 跳转"
// 以及"未来远程设备事件"三种截然不同的分发机制，上层业务只需调用统一的 publish 接口。
class EventManager {
  public mEventBus: EventBus<string>;
  private mContext: common.ServiceExtensionContext | undefined;

  constructor() {
    this.mEventBus = createEventBus();
  }

  setContext(ctx: common.ServiceExtensionContext) {
    this.mContext = ctx;
  }

  publish(event: Event, pluginType?: PluginType): boolean {
    Log.showInfo(TAG, `PUBLISH : event: ${JSON.stringify(event)}`)
    switch (event.target) {
      case 'local':
        return this.publishLocalEvent(event.data as LocalEvent);
      case 'ability':
        return this.startAbility(event.data, pluginType);
      case 'commonEvent':
        return this.publishCommonEvent(event.data);
      case 'remote':
        return this.publishRemoteEvent(event.data);
      default:
        return false;
    }
  }

  subscribe(eventType: Events, callback: Callback): unsubscribe {
    return this.mEventBus.on(eventType, callback);
  }

  subscribeOnce(eventType: string, callback: Callback): unsubscribe {
    return this.mEventBus.once(eventType, callback);
  }

  private publishLocalEvent(data: LocalEvent): boolean {
    Log.showDebug(TAG, `publish localEvent type: ${data.eventName}`);
    if (data.eventName) {
      this.mEventBus.emit(data.eventName, data.args);
      return true;
    }
    return false;
  }

  // startAbility 在 TV SystemUI 中承担跨模块页面跳转职责（如从控制面板打开设置应用），
  // 同时向总线广播 START_ABILITY_EVENT 供导航栏等观察者更新焦点高亮状态。
  // 当插件类型为 META 时记录故障日志，用于大屏场景下的运维可观测性追踪。
  private startAbility(data: EventData, pluginType?: PluginType): boolean {
    Log.showInfo(TAG, `start : data: ${JSON.stringify(data)}`)
    Log.showDebug(TAG, `start Ability: ${data.abilityName ?? ''}`);
    if (data.bundleName && data.abilityName && this.mContext) {
      const eventData: StartAbilityEventData = { abilityName: data.abilityName };
      const faultData: FaultLogData = {
        CORE_SYSTEM: 'com.ohos.systemui',
        TARGET_API: data.bundleName,
        FAULT_ID: FaultID.META_DIAGRAM_JUMP,
        MSG: 'jump ability failure'
      };
      this.mEventBus.emit(START_ABILITY_EVENT, eventData as EventArg);
      let params: Record<string, Object> | undefined = undefined;
      if (typeof data.args === 'object' && data.args !== null) {
        params = data.args as Record<string, Object>;
      }
      const want: Want = {
        bundleName: data.bundleName,
        abilityName: data.abilityName,
        parameters: params
      };
      this.mContext.startAbility(want).then(() => {
        Log.showInfo(TAG, 'startAbility, then');
      }).catch((error: BusinessError) => {
        Log.showError(TAG, `startAbility, error: ${JSON.stringify(error)}`);
        if (pluginType == PluginType.META) {
          writeFaultLog(faultData);
        }
      });
      return true;
    }
    return false;
  }

  private publishRemoteEvent(data: EventData): boolean {
    // todo publish to remote device
    return false;
  }

  private publishCommonEvent(data: EventData): boolean {
    // todo publish commonEvent to other app
    return false;
  }
}

let sEventManager = createOrGet(() => new EventManager(), TAG);

export default sEventManager as EventManager;
