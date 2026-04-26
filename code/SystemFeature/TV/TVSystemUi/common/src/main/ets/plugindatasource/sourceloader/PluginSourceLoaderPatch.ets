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
 

import { Want } from '@kit.AbilityKit';
import Log from '../../default/Log';
import { ItemComponentData } from '../common/Constants';
import { ListenerHandle, registerPushListener, requestFunction, PluginComponentInfo
} from '../common/PluginComponentManagerUtil';

const TAG = 'PluginSourceLoaderPatch';

export interface UpdatePluginComponentDataListener {
  onUpdatePluginComponentData(pluginComponentData: ItemComponentData): Promise<void>;
}

export default class PluginSourceLoaderPatch {
  public mOwnerWant: Want;
  private mListener: UpdatePluginComponentDataListener;
  private mListenerHandle: ListenerHandle;

  constructor(ownerWant: Want, listener: UpdatePluginComponentDataListener) {
    Log.showInfo(TAG, `constructor, ownerWant: ${JSON.stringify(ownerWant)}`);
    this.mOwnerWant = ownerWant;
    this.mListener = listener;
    registerPushListener(ownerWant, this, (handle) => {
      this.mListenerHandle = handle;
    });
  }

  async onPushPluginComponentData(pluginComponentInfo: PluginComponentInfo): Promise<void> {
    Log.showInfo(TAG, `onPushPluginComponentData, pluginComponentInfo: ${JSON.stringify(pluginComponentInfo)}`);
    let pluginComponentData = this.pluginComponentInfoToItemComponentData(pluginComponentInfo);
    this.mListener.onUpdatePluginComponentData(pluginComponentData).then(() => {
    }).catch(err => {
    });
  }

  async requestPluginComponentData(itemData: ItemComponentData): Promise<ItemComponentData> {
    Log.showInfo(TAG, `requestPluginComponentData, itemData: ${JSON.stringify(itemData)}`);
    let ret = await requestFunction(this.mOwnerWant, itemData);
    return this.pluginComponentInfoToItemComponentData(ret);
  }

  pluginComponentInfoToItemComponentData(pluginComponentInfo: PluginComponentInfo): ItemComponentData{
    let pluginComponentData: ItemComponentData = {
      id: null,
      pluginType: 3,
      deviceId: null,
      bundleName: pluginComponentInfo.bundleName,
      moduleName: pluginComponentInfo.moduleName,
      abilityName: pluginComponentInfo.abilityName,
      abilityLabelId: null,
      abilityIconId: null,
      template: pluginComponentInfo.template,
      actionData: {
        pluginData: {
          template: pluginComponentInfo.componentTemplate,
          data: pluginComponentInfo.data
        }
      }
    };
    return pluginComponentData;
  }

  clearAll(): void {
    Log.showInfo(TAG, 'clearAll');
    this.mListenerHandle?.unRegister();
    this.mListenerHandle = undefined;
  }
}
