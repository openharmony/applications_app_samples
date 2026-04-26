// @ts-nocheck
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
 

import { pluginComponentManager } from '@kit.ArkUI';
import { Want } from '@kit.AbilityKit';
import { ItemComponentData } from './Constants';
import Log from '../../default/Log';

const TAG = 'PluginComponentManagerUtil';

export class PluginComponentInfo {
  public bundleName: string;
  public moduleName: string;
  public abilityName: string;
  public template: string;
  public componentTemplate;
  public data;
}

export interface PushListener {
  onPushPluginComponentData(pluginComponentInfo: PluginComponentInfo): Promise<void>;
}

export interface ListenerHandle {
  unRegister(): void;
}

export async function requestFunction(owner: Want, itemData: ItemComponentData): Promise<PluginComponentInfo> {
  Log.showDebug(TAG, `requestFunction, owner: ${JSON.stringify(owner)}`);
  Log.showDebug(TAG, `requestFunction, itemData: ${JSON.stringify(itemData)}`);
  let param = {
    owner: owner,
    want: {
      bundleName: itemData.bundleName, abilityName: itemData.abilityName
    },
    name: itemData.template,
    data: {}
  };
  let ret = await pluginComponentManager.request(param);
  Log.showDebug(TAG, `requestFunction, callback ret: ${JSON.stringify(ret)}`);
  if (!ret) {
    throw new Error();
  }
  let info = new PluginComponentInfo();
  info.bundleName = itemData.bundleName;
  info.moduleName = itemData.moduleName;
  info.abilityName = itemData.abilityName;
  info.template = itemData.template;
  info.componentTemplate = ret.componentTemplate;
  info.data = ret.data;
  return info;
}

export function registerPushListener(
  owner: Want, listener: PushListener, callback: (handle: ListenerHandle) => void
  ): void {
  Log.showDebug(TAG, `registerPushListener start, owner: ${JSON.stringify(owner)}`);
  pluginComponentManager.on(owner, 'push', (source, template, data, extraData) => {
    Log.showDebug(TAG, `onPush, source: ${JSON.stringify(source)}`);
    Log.showDebug(TAG, `onPush, template: ${JSON.stringify(template)}`);
    Log.showDebug(TAG, `onPush, data: ${JSON.stringify(data)}`);
    Log.showDebug(TAG, `onPush, extraData: ${JSON.stringify(extraData)}`);
    let info = new PluginComponentInfo();
    info.bundleName = source.bundleName;
    info.abilityName = source.abilityName;
    info.template = template.source;
    info.componentTemplate = template;
    info.data = data;
    Log.showDebug(TAG, `onPush, info: ${JSON.stringify(info)}`);
    listener.onPushPluginComponentData(info).then(() => {
    }).catch((err) => {
    });
    Log.showDebug(TAG, 'onPush end');
  });
  Log.showDebug(TAG, 'registerPushListener end');

  callback({
    unRegister: () => {
      Log.showDebug(TAG, 'unRegisterPushListener start');
      pluginComponentManager.off(owner, (err) => {
        Log.showDebug(TAG, `unRegisterPushListener callback err: ${JSON.stringify(err)}`);
      });
      Log.showDebug(TAG, 'unRegisterPushListener end');
    },
  });
  Log.showDebug(TAG, 'registerPushListener callback end');
}