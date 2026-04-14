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
 

import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit'
import { Want } from '@kit.AbilityKit';
import Log from '../Log';

const TAG = 'AbilityManager';

export interface displayAttribute {
  width: number
  height: number
}

export interface rectAttribute {
  width: number
  height: number
  left: number
  top: number
}

// AbilityManager 以静态类充当全局上下文注册表，将各 Ability 的 Context 存入 globalThis，
// 解决 HarmonyOS 多 Ability 架构下跨模块无法直接持有对方 Context 引用的问题，
// 避免在各业务模块间传递 Context 参数链，降低模块间耦合度。
export default class AbilityManager {
  public static readonly ABILITY_NAME_ENTRY = 'SystemUi_Entry';
  public static readonly ABILITY_NAME_STATUS_BAR = 'SystemUi_StatusBar';
  public static readonly ABILITY_NAME_NAVIGATION_BAR = 'SystemUi_NavigationBar';
  public static readonly ABILITY_NAME_VOLUME_PANEL = 'SystemUi_VolumePanel';
  public static readonly ABILITY_NAME_NOTIFICATION_MANAGEMENT = 'SystemUi_NotificationManagement';
  public static readonly ABILITY_NAME_DROPDOWN_PANEL = 'SystemUi_DropdownPanel';
  public static readonly ABILITY_NAME_NOTIFICATION_PANEL = 'SystemUi_NotificationPanel';
  public static readonly ABILITY_NAME_CONTROL_PANEL = 'SystemUi_ControlPanel';
  public static readonly ABILITY_NAME_BANNER_NOTICE = 'SystemUi_BannerNotice';
  public static readonly ABILITY_NAME_APP_LIST = 'SystemUi_AppList';
  public static readonly ABILITY_NAME_OWNER_WANT = 'Owner_Want';
  private static contextMap: Map<string, common.ServiceExtensionContext | common.UIAbilityContext> = new Map();
  private static abilityDataMap: Map<string, AbilityData> = new Map();
  private static contextNameMap: Map<string, string> = new Map();

  static setContext(abilityName: string, context: common.ServiceExtensionContext | common.UIAbilityContext): void {
    Log.showDebug(TAG, `setContext, abilityName: ${abilityName}`);
    AbilityManager.contextMap.set(abilityName, context);
  }

  static getContext(abilityName?: string): common.ServiceExtensionContext | common.UIAbilityContext | undefined {
    Log.showDebug(TAG, `getContext, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return AbilityManager.contextMap.get(abilityName);
  }

  static setAbilityContext(abilityName: string,
    context: common.ServiceExtensionContext | common.UIAbilityContext): void {
    Log.showDebug(TAG, `setContext, abilityName: ${abilityName}`);
    AbilityManager.contextMap.set(abilityName, context);
  }

  static getAbilityContext(abilityName?: string): common.ServiceExtensionContext | common.UIAbilityContext | undefined {
    Log.showDebug(TAG, `getContext, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return AbilityManager.contextMap.get(abilityName);
  }

  static setAbilityData(abilityName: string, key: string, data: AbilityData): void {
    Log.showDebug(TAG, `setAbilityData, abilityName: ${abilityName} key: ${key} data: ${JSON.stringify(data)}`);
    AbilityManager.abilityDataMap.set(`${abilityName}_data_${key}`, data);
  }

  static getAbilityData(abilityName: string, key: string): AbilityData | undefined {
    Log.showDebug(TAG, `getAbilityData, abilityName: ${abilityName} key: ${key} `);
    return AbilityManager.abilityDataMap.get(`${abilityName}_data_${key}`);
  }

  static setContextName(abilityName: string, contextName: string): void {
    Log.showDebug(TAG, `setContextName, abilityName: ${abilityName}`);
    AbilityManager.contextNameMap.set(abilityName, contextName);
  }

  static getContextName(abilityName?: string): string {
    Log.showDebug(TAG, `setContextName, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return AbilityManager.contextNameMap.get(abilityName) ?? '';
  }

  // startAbility 允许 context 传 null，此时自动降级使用 Entry 的 Context，
  // 是因为部分功能模块（如插件数据源）在初始化阶段还未持有自己的 Context，
  // 统一兜底保证跳转不会因 Context 缺失而崩溃。
  static startAbility(
    context: common.ServiceExtensionContext | common.UIAbilityContext | null | undefined,
    want: Want,
    callback?: (error?: BusinessError) => void
  ): void {
    Log.showDebug(TAG, `startAbility, want: ${JSON.stringify(want)}`);
    if (context == null) {
      context = AbilityManager.getContext();
    }
    if (!context) {
      Log.showError(TAG, 'startAbility, context is undefined');
      return;
    }
    context.startAbility(want).then(() => {
      Log.showInfo(TAG, 'startAbility, then');
      if (callback) {
        callback();
      }
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `startAbility, error: ${JSON.stringify(error)}`);
      if (callback) {
        callback(error);
      }
    });
  }

  static startServiceExtensionAbility(
    context: common.ServiceExtensionContext | common.UIAbilityContext | null | undefined,
    want: Want,
    callback?: (error?: BusinessError) => void
  ): void {
    Log.showDebug(TAG, `startServiceExtensionAbility, want: ${JSON.stringify(want)}`);
    if (context == null) {
      context = AbilityManager.getContext();
    }
    if (!context) {
      Log.showError(TAG, 'startServiceExtensionAbility, context is undefined');
      return;
    }
    context.startServiceExtensionAbility(want).then(() => {
      Log.showInfo(TAG, 'startServiceExtensionAbility, then');
      if (callback) {
        callback();
      }
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `startServiceExtensionAbility, error: ${JSON.stringify(error)}`);
      if (callback) {
        callback(error);
      }
    });
  }
}

export type AbilityData = Object | string | number | boolean | null;
