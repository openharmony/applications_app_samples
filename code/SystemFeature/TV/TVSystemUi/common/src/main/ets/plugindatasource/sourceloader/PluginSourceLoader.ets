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
 

import Log from '../../default/Log';
import SourceLoader from './SourceLoader';
import Constants, { PluginType, ItemComponentData, LoaderConfigInfo, PluginComponentData } from '../common/Constants';
import { AbilityInfoWithId, filterAbilityInfo, PluginData } from '../common/BundleParseUtil';

const TAG = 'PluginSourceLoader';

export default class PluginSourceLoader extends SourceLoader {
  public mPluginFilter = '';
  private mPermission = '';
  private mItemDatas: ItemComponentData[] = [];

  constructor(config: LoaderConfigInfo) {
    super(config);
    this.mPluginFilter = config.action as string;
    this.mPermission = config.permission as string;
    Log.showDebug(TAG, `init loader, mPluginFilter: ${this.mPluginFilter}, mPermission: ${this.mPermission}`);
  }

  onAbilityAdd(abilityInfo: AbilityInfoWithId): void {
    Log.showDebug(TAG, `onAbilityAdd, abilityInfo: ${JSON.stringify(abilityInfo)}`);
    let pluginData: PluginData | undefined = filterAbilityInfo(abilityInfo, this.mPluginFilter);
    Log.showDebug(TAG, `onAbilityAdd, pluginData: ${JSON.stringify(pluginData)}`);
    if (pluginData) {
      let itemData = parseData(abilityInfo, pluginData);
      Log.showDebug(TAG, `onAbilityAdd, itemData: ${JSON.stringify(itemData)}`);
      if (!itemData) {
        return;
      }
      this.mItemDatas.push(itemData);
      this.getChannel().onLoadPluginComponentData(itemData);
      Log.showDebug(TAG, `item[${itemData.id}] add success, name: ${abilityInfo.name}`);
      return;
    }
    Log.showDebug(TAG, `Can't filter ${abilityInfo.name}.`);
  }

  onUpdatePluginComponentData(data: ItemComponentData): void{
    Log.showDebug(TAG, `onUpdatePluginComponentData, data: ${JSON.stringify(data)}`);
    for (let itemData of this.mItemDatas) {
      if (data.bundleName == itemData.bundleName &&
          data.abilityName == itemData.abilityName &&
          data.template == itemData.template) {

        Log.showDebug(TAG, `onUpdatePluginComponentData, update id: ${itemData.id} `);
        itemData.actionData.pluginData = data.actionData.pluginData;
        if (itemData.actionData.pluginData) {
          this.addItem(itemData);
        } else {
          this.removeItem(itemData);
        }
        break;
      }
    }
  }

  onBundleRemove(bundleName: string): void {
    for (let i = this.mItemDatas.length - 1; i >= 0; i--) {
      if (bundleName == this.mItemDatas[i].bundleName) {
        Log.showDebug(TAG, `remove item index: ${i}, abilityname: ${this.mItemDatas[i].abilityName}`);
        this.removeItem(this.mItemDatas[i]);
        this.mItemDatas.splice(i, 1);
      }
    }
  }

  clearData(): void {
    Log.showDebug(TAG, `clear all, size: ${this.mItemDatas.length}`);
    this.mItemDatas.forEach((data) => this.removeItem(data));
    this.mItemDatas.length = 0;
  }

  reloadData(userId: number): void {
    Log.showDebug(TAG, `reloadData userId: ${userId}`);
  }
}

function parseData(info: AbilityInfoWithId, data: PluginData): ItemComponentData | undefined {
  let { label, pluginType, icon, template, launchType, ...extra } = data;
  if (pluginType == undefined || pluginType == null || pluginType.toString() != 
  PluginType.PLUGIN_COMPONENT.toString()) {
    return undefined;
  }
  let itemData: ItemComponentData = {
    id: info.itemId,
    pluginType: PluginType.PLUGIN_COMPONENT,
    deviceId: Constants.LOCAL_DEVICE,
    bundleName: info.bundleName,
    moduleName: info.moduleName,
    abilityName: info.name,
    abilityLabelId: info.labelId,
    abilityIconId: info.iconId,
    label: label,
    iconUrl: icon,
    template: template,
    actionData: {
      pluginData: null,
      launchType: launchType,
      extra: extra,
    },
  };
  return itemData;
}
