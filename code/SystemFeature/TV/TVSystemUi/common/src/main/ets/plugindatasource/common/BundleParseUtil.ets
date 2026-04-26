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
 

import { bundleManager } from '@kit.AbilityKit';
import { commonEventManager } from '@kit.BasicServicesKit';
import { AbilityInfo } from 'bundleManager/AbilityInfo';
import { ExtensionAbilityInfo } from 'bundleManager/ExtensionAbilityInfo';
import { CustomizeData } from 'bundle/customizeData';
import { Metadata } from 'bundleManager/Metadata';
import Log from '../../default/Log';
import switchUserManager from '../../default/SwitchUserManager';

export type AbilityInfoWithId = (AbilityInfo | ExtensionAbilityInfo) & { itemId: string };

export type BundleListener = {
  onBundleNotify: (bundleName: string, event: BundleEventType) => void;
};

export type ListenerHandle = {
  unRegister: () => void;
};

export type PluginData = {
  [key: string | number]: any;
};

export enum BundleEventType {
  BUNDLE_ADD,
  BUNDLE_CHANGE,
  BUNDLE_REMOVE,
  UNKNOWN_EVENT,
}

const TAG = 'SourceLoader-BundleParseUtil';
const DEFAULT_BUNDLE_FLAG =
  bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_METADATA | bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_PERMISSION;

const BUNDLE_SUBSCRIBE_INFO = {
  events: [
    commonEventManager.Support.COMMON_EVENT_PACKAGE_ADDED,
    commonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED,
    commonEventManager.Support.COMMON_EVENT_PACKAGE_CHANGED,
  ],
};

export async function queryAbility(
  action: string, userId: number, bundleName?: string
): Promise<(AbilityInfo | ExtensionAbilityInfo)[]> {
  Log.showDebug(TAG, `queryAbility, action: ${action} , userId: ${userId}`);
  if (bundleName) {
    Log.showDebug(TAG, `queryAbility, bundleName: ${bundleName}`);
    return await queryAbilityWithBundleName(action, userId, bundleName);
  }
  return await queryAbilityWithoutBundleName(action, userId);
}

async function queryAbilityWithBundleName(
  action: string, userId: number, bundleName: string
): Promise<(AbilityInfo | ExtensionAbilityInfo)[]> {
  Log.showInfo(TAG, `queryAbilityWithBundleName, action: ${action} bundleName: ${bundleName}`);
  let abilitys: AbilityInfo[] = [];
  try {
    abilitys = await bundleManager.queryAbilityInfo(
      {
        action: action,
        bundleName: bundleName,
      },
      DEFAULT_BUNDLE_FLAG,
      userId
    );
  } catch (error) {
    Log.showError(TAG, `queryAbilityWithBundleName, queryAbilityByWant error: ${JSON.stringify(error)}`);
  }
  let extensionAbilitys: ExtensionAbilityInfo[] = [];
  try {
    extensionAbilitys = await bundleManager.queryExtensionAbilityInfo(
      {
        action: action,
        bundleName: bundleName,
      },
      bundleManager.ExtensionAbilityType.UNSPECIFIED,
      DEFAULT_BUNDLE_FLAG,
      userId
    );
  } catch (error) {
    Log.showError(TAG, `queryAbilityWithBundleName, queryExtensionAbilityInfo error: ${JSON.stringify(error)}`);
  }
  Log.showDebug(TAG, 'queryAbilityWithBundleName, end');
  let rets = [...abilitys, ...extensionAbilitys];
  Log.showDebug(TAG, `queryAbilityWithBundleName, rets: ${JSON.stringify(rets)}`);
  return rets;
}

async function queryAbilityWithoutBundleName(action: string,
  userId: number): Promise<(AbilityInfo | ExtensionAbilityInfo)[]> {
  Log.showInfo(TAG, `queryAbilityWithoutBundleName, action: ${action}`);
  let abilitys: AbilityInfo[] = [];
  try {
    abilitys = await bundleManager.queryAbilityInfo({ action: action }, DEFAULT_BUNDLE_FLAG, userId);
  } catch (error) {
    Log.showError(TAG, `queryAbilityWithoutBundleName, queryAbilityByWant error: ${JSON.stringify(error)}`);
  }
  let extensionAbilitys: ExtensionAbilityInfo[] = [];
  try {
    extensionAbilitys = await bundleManager.queryExtensionAbilityInfo({
      action: action
    }, bundleManager.ExtensionAbilityType.UNSPECIFIED, DEFAULT_BUNDLE_FLAG, userId);
  } catch (error) {
    Log.showError(TAG, `queryAbilityWithoutBundleName, queryExtensionAbilityInfo error: ${JSON.stringify(error)}`);
  }
  Log.showDebug(TAG, 'queryAbilityWithoutBundleName, end');
  let rets = [...abilitys, ...extensionAbilitys];
  Log.showDebug(TAG, `queryAbilityWithoutBundleName, rets: ${JSON.stringify(rets)}`);
  return rets;
}

export function filterAbilityInfo(info: AbilityInfoWithId, filterKey: string): PluginData | undefined {
  Log.showInfo(TAG, `filterAbilityInfo, info: ${JSON.stringify(info)} filterKey: ${filterKey}`);
  let pluginDatas: (CustomizeData | Metadata)[] = [];
  if (info.metaData && info.metaData.length) {
    pluginDatas = info.metaData.filter((data) => data.name == filterKey);
  } else if (info.metadata && info.metadata.length) {
    pluginDatas = info.metadata.filter((data) => data.name == filterKey);
  }
  Log.showInfo(TAG, `filterAbilityInfo, pluginDatas: ${JSON.stringify(pluginDatas)}`);
  if (!pluginDatas.length) {
    Log.showDebug(TAG, `filterKey: ${filterKey}, metadata: ${JSON.stringify(info.metadata.values)}`);
    return undefined;
  }
  let pluginData: PluginData;
  if (pluginDatas[0].value && pluginDatas[0].value.length > 0) {
    pluginData = JSON.parse('{' + pluginDatas[0].value + '}') as PluginData;
  } else if (pluginDatas[0].extra && pluginDatas[0].extra.length > 0) {
    pluginData = JSON.parse('{' + pluginDatas[0].extra + '}') as PluginData;
  }
  if (!pluginData) {
    Log.showError(TAG, `Can't parse pluginData: ${pluginDatas[0]}, filterKey: ${filterKey}`);
    return undefined;
  }
  Log.showInfo(TAG, `filterAbilityInfo, pluginData: ${JSON.stringify(pluginData)}`);
  return pluginData;
}

export function registerBundleListener(listener: BundleListener, callback: (handle: ListenerHandle) => void): void {
  commonEventManager.createSubscriber(BUNDLE_SUBSCRIBE_INFO, (err, handle) => {
    Log.showDebug(TAG, `registerBundleListener, err: ${JSON.stringify(err)}, handle: ${handle}`);
    if (err.code != 0) {
      Log.showError(TAG, `Can't regitser bundle subscribe, err: ${JSON.stringify(err)}`);
      return;
    }
    commonEventManager.subscribe(handle, (err, data) => {
      Log.showInfo(TAG, `bundle change, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      if (err.code != 0) {
        Log.showError(TAG, `Can't handle bundle change, err: ${JSON.stringify(err)}`);
        return;
      }

      switchUserManager.getInstance()
        .getCurrentUserInfo()
        .then((userInfo) => {
          if (data.parameters.userId != userInfo.userId) {
            return;
          } else {
            let event = BundleEventType.UNKNOWN_EVENT;
            switch (data.event) {
              case commonEventManager.Support.COMMON_EVENT_PACKAGE_ADDED:
                event = BundleEventType.BUNDLE_ADD;
                break;
              case commonEventManager.Support.COMMON_EVENT_PACKAGE_CHANGED:
                event = BundleEventType.BUNDLE_CHANGE;
                break;
              case commonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED:
                event = BundleEventType.BUNDLE_REMOVE;
                break;
              default:
                Log.showError(TAG, `unknow event: ${event}`);
            }
            listener.onBundleNotify(data.bundleName ?? 'unkown', event);
          }
        });
    });
    callback({
      unRegister: () => {
        commonEventManager.unsubscribe(handle, () => {
          Log.showInfo(TAG, `unRegister bundle info listener, handle: ${handle}`);
        });
      },
    });
  });
}
