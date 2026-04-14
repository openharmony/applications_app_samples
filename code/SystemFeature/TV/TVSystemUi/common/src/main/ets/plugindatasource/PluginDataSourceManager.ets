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
 

import Log from '../default/Log';
import SourceLoaderFactory from './sourceloader/SourceLoaderFactory';
import SourceLoader from './sourceloader/SourceLoader';
import PluginSourceLoader from './sourceloader/PluginSourceLoader';
import { FilterData, ItemComponentData, RootConfigInfo, LoaderConfigInfo } from './common/Constants';
import {
  AbilityInfoWithId,
  BundleEventType,
  ListenerHandle,
  queryAbility,
  registerBundleListener,
} from './common/BundleParseUtil';
import { AbilityInfo } from 'bundle/abilityInfo';
import { ExtensionAbilityInfo } from 'bundleManager/ExtensionAbilityInfo';

export type PluginListener = {
  onItemAdd: (itemData: ItemComponentData) => void;
  onItemRemove: (itemData: ItemComponentData) => void;
  onLoadPluginComponentData: (itemData: ItemComponentData) => void;
};

const TAG = 'PluginDataSourceManager';
const INVALID_USERID = -1;
const SUPPORTED_LOADER_TYPES: string[] = ['MetaSource', 'PluginSourceLoader', 'DataAbilitySourceLoader'];

export default class PluginDataSourceManager {
  public mAction = '';
  public mUserId: number = INVALID_USERID;
  public mListenerHandle: ListenerHandle | undefined = undefined;
  public mFilterDatas: Map<string, string> = new Map();
  private mLoaders: Map<string, SourceLoader> = new Map();
  private mFactory: SourceLoaderFactory;

  constructor(listener: PluginListener) {
    this.mFactory = new SourceLoaderFactory({
      add: listener.onItemAdd,
      remove: listener.onItemRemove,
      onLoadPluginComponentData: listener.onLoadPluginComponentData,
    });
  }

  initDataSource(configs: RootConfigInfo): void {
    Log.showDebug(TAG, `initDataSource, configs: ${JSON.stringify(configs)}`);
    this.mAction = configs.action;
    configs.filterDatas.forEach((data: FilterData) => this.mFilterDatas.set(data.abilityName, data.id));
    SUPPORTED_LOADER_TYPES.forEach((pluginType: string) => {
      const loaderConfig: LoaderConfigInfo | undefined = this.getLoaderConfig(configs, pluginType);
      if (!loaderConfig) {
        return;
      }
      const sourceLoader = this.mFactory.getSourceLoader(pluginType, loaderConfig);
      if (sourceLoader instanceof SourceLoader) {
        this.mLoaders.set(pluginType, sourceLoader);
        Log.showInfo(TAG, `getSourceLoader plugin: ${pluginType}, loader${this.mLoaders.get(pluginType)}`);
      }
    });
    Log.showDebug(TAG, `action:${this.mAction}, filterData: ${JSON.stringify(this.mFilterDatas)}`);
    registerBundleListener(this, (handle) => {
      this.mListenerHandle = handle;
    });
  }

  async onBundleNotify(bundleName: string, event: BundleEventType): Promise<void> {
    Log.showDebug(TAG, `onBundleNotify, bundleName: ${bundleName}, event: ${event}`);
    if (event == BundleEventType.BUNDLE_CHANGE || event == BundleEventType.BUNDLE_REMOVE) {
      this.mLoaders.forEach((loader) => loader.onBundleRemove(bundleName));
    }
    if (event == BundleEventType.BUNDLE_CHANGE || event == BundleEventType.BUNDLE_ADD) {
      let abilityInfos = await queryAbility(this.mAction, this.mUserId, bundleName);
      Log.showInfo(TAG, `abilityInfos: ${JSON.stringify(abilityInfos)}`);
      abilityInfos.forEach((info) => this.notifyAbilityAdd(info));
    }
  }

  clearAll(): void {
    Log.showDebug(TAG, 'clearAll');
    this.unregisterListener();
    this.mLoaders.forEach((sourceLoader) => sourceLoader.clearData());
  }

  async loadData(userId: number): Promise<void> {
    Log.showDebug(TAG, `loadData, userId: ${userId}, this.mUserId: ${this.mUserId}`);
    if (this.mUserId != userId) {
      Log.showDebug(TAG, `loadData, queryAbility`);
      this.mUserId = userId;
      this.mLoaders.forEach((sourceLoader) => sourceLoader.clearData());
      let abilityInfos = await queryAbility(this.mAction, this.mUserId);
      Log.showDebug(TAG, `loadData, abilityInfos: ${JSON.stringify(abilityInfos)}`);
      abilityInfos.forEach((info) => this.notifyAbilityAdd(info));
    }
    this.mLoaders.forEach((sourceLoader) => sourceLoader.reloadData(this.mUserId));
    Log.showDebug(TAG, `loadData, end`);
  }

  private notifyAbilityAdd(info: AbilityInfo | ExtensionAbilityInfo): void {
    Log.showDebug(TAG, `notifyAbilityAdd, info: ${JSON.stringify(info)}`);
    let itemId = this.mFilterDatas.get(info.name);
    if (!itemId) {
      Log.showError(TAG, `notifyAbilityAdd, can't find itemId, ability:${info.name}`);
      return;
    }
    let abilityInfo: AbilityInfoWithId = {
      ...info,
      itemId: itemId,
    };
    if ((!abilityInfo.metaData || !abilityInfo.metaData.length) && 
    (!abilityInfo.metadata || !abilityInfo.metadata.length)) {
      Log.showError(TAG, `Can't find metadata, abilityId: ${abilityInfo.name}`);
      return;
    }
    this.mLoaders.forEach((loader) => loader.onAbilityAdd(abilityInfo));
  }

  private unregisterListener(): void {
    this.mListenerHandle?.unRegister();
    this.mListenerHandle = undefined;
  }

  private getLoaderConfig(configs: RootConfigInfo, pluginType: string): LoaderConfigInfo | undefined {
    const loaderMap = configs.loaderConfig as Record<string, LoaderConfigInfo | undefined>;
    if (pluginType == 'MetaSource') {
      return loaderMap.metaSource ?? loaderMap['MetaSource'];
    }
    if (pluginType == 'PluginSourceLoader') {
      return loaderMap.pluginSourceLoader ?? loaderMap['PluginSourceLoader'];
    }
    if (pluginType == 'DataAbilitySourceLoader') {
      return configs.loaderConfig.DataAbilitySourceLoader;
    }
    return undefined;
  }

  async updatePluginComponentData(pluginComponentData: ItemComponentData): Promise<void> {
    Log.showInfo(TAG, 'updatePluginComponentData');
    this.mLoaders.forEach((loader) => {
      if (loader instanceof PluginSourceLoader) {
        (loader as PluginSourceLoader).onUpdatePluginComponentData(pluginComponentData);
      }
    });
  }
}
