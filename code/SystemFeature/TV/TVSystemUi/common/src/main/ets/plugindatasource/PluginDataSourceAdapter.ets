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
 

import { worker } from '@kit.ArkTS';
import Log from '../default/Log';
import BundleManager from '../default/abilitymanager/bundleManager';
import { Want, common } from '@kit.AbilityKit';
import Constants, { ItemComponentData, LoaderConfigInfo, obtainMsg, RootConfigInfo } from './common/Constants';
import PluginSourceLoaderPatch from './sourceloader/PluginSourceLoaderPatch'

export interface PluginWorkerListener {
  initFinish(): void;
  onItemAdd(data: ItemComponentData): void;
  onItemRemove(data: ItemComponentData): void;
};

const TAG = 'PluginDataSourceAdapter';

export default class PluginDataSourceAdapter {
  public mContext: common.ServiceExtensionContext;
  public mWorker;
  public mName: string;
  public mListener: PluginWorkerListener;
  public mWant: Want;
  private mPluginSourceLoaderPatch: PluginSourceLoaderPatch;
  private mModuleName: string;

  constructor(name: string, context: common.ServiceExtensionContext, listener: PluginWorkerListener, moduleName: string) {
    Log.showDebug(TAG, `constructor, name: ${name}`);
    this.mName = name;
    this.mContext = context;
    this.mListener = listener;
    this.mModuleName = moduleName;
    const WORKER_JS_URL = this.mModuleName + '/ets/workers/PluginDataSourceWorker.js';
    this.mWorker = new worker.Worker(WORKER_JS_URL, {
      type: 'classic',
      name: this.mName,
    });

    this.mWorker.onmessage = this.onMessage.bind(this);
    this.mWorker.onmessageerror = this.onMessageError.bind(this);
    this.mWorker.onexit = this.onExit.bind(this);
    this.mWorker.onerror = this.onError.bind(this);
  }

  setWant(want: Want): void{
    this.mWant = want;
  }

  initDataSource(configs: RootConfigInfo): void {
    Log.showDebug(TAG, `name: ${this.mName}, initDataSource, configs: ${JSON.stringify(configs)}`);
    this.mWorker.postMessage(obtainMsg(Constants.INIT_CONFIG, configs));
    const loaderMap = configs.loaderConfig as Record<string, LoaderConfigInfo | undefined>;
    if (loaderMap.pluginSourceLoader || loaderMap['PluginSourceLoader']) {
      this.mPluginSourceLoaderPatch = new PluginSourceLoaderPatch(this.mWant, this);
    }
  }

  loadData(userId: number): void {
    Log.showDebug(TAG, `name: ${this.mName}, loadData`);
    this.mWorker.postMessage(obtainMsg(Constants.LOAD_DATA, userId));
  }

  clearAll(): void {
    Log.showDebug(TAG, `name: ${this.mName}, clearAll`);
    this.mWorker.postMessage(obtainMsg(Constants.CLEAR_ALL, {}));
    this.mPluginSourceLoaderPatch?.clearAll();
  }

  onMessage(msg: { data }): void {
    Log.showDebug(TAG, `name: ${this.mName}, onMessage, msg: ${JSON.stringify(msg)}`);
    let data = msg.data;
    switch (data.action) {
      case Constants.INIT_FINISH:
        this.onInitFinish();
        break;
      case Constants.ADD_ITEM:
        this.onItemAdd(data.data);
        break;
      case Constants.REMOVE_ITEM:
        this.onItemRemove(data.data);
        break;
      case Constants.LOAD_PLUGIN_COMPONENT_DATA:
        this.onLoadPluginComponentData(data.data).then(() => {
        }).catch(err => {
        });
        break;
      default:
        Log.showError(TAG, `name: ${this.mName}, unknown type: ${data.action}`);
    }
  }

  onInitFinish(): void {
    Log.showDebug(TAG, `name: ${this.mName}, onInitFinish`);
    this.mListener.initFinish();
  }

  async onItemAdd(itemData: ItemComponentData): Promise<void> {
    Log.showDebug(TAG, `name: ${this.mName}, onItemAdd, itemData: ${JSON.stringify(itemData)}`);
    itemData.label && (itemData.label = decodeURIComponent(itemData.label));
    if (itemData.label && itemData.iconUrl) {
      this.mListener.onItemAdd(itemData);
      return;
    }
    Promise.all([
      itemData.iconUrl ?? BundleManager.getMediaBase64({bundleName: itemData.bundleName,
        moduleName: itemData.moduleName, id: itemData.abilityIconId}),
      itemData.label ?? BundleManager.getString({
        bundleName: itemData.bundleName, moduleName: itemData.moduleName, id: itemData.abilityLabelId
      }),
    ])
      .then(([iconValue, labelValue]) => {
        iconValue && (itemData.iconUrl = iconValue);
        labelValue && (itemData.label = labelValue);
        this.mListener.onItemAdd(itemData);
      })
      .catch((err) => Log.showError(TAG, `name: ${this.mName}, Can't get bundle info, err: ${JSON.stringify(err)}`));
  }

  onItemRemove(itemData: ItemComponentData): void {
    Log.showDebug(TAG, `name: ${this.mName}, onItemRemove, itemData: ${JSON.stringify(itemData)}`);
    this.mListener.onItemRemove(itemData);
  }

  async onLoadPluginComponentData(itemData: ItemComponentData): Promise<void> {
    Log.showDebug(TAG, `name: ${this.mName}, onLoadPluginComponentData, itemData: ${JSON.stringify(itemData)}`);
    let ret = await this.mPluginSourceLoaderPatch?.requestPluginComponentData(itemData);
    this.mWorker.postMessage(obtainMsg(Constants.UPDATE_PLUGIN_COMPONENT_DATA, ret));
  }

  async onUpdatePluginComponentData(pluginComponentData: ItemComponentData): Promise<void> {
    Log.showDebug(TAG, `name: ${this.mName}, onUpdatePluginComponentData, pluginComponentData: ${JSON.stringify(pluginComponentData)}`);
    this.mWorker.postMessage(obtainMsg(Constants.UPDATE_PLUGIN_COMPONENT_DATA, pluginComponentData));
  }

  onMessageError(event): void {
    Log.showDebug(TAG, `name: ${this.mName}, mWorker.onmessageerror, event: ${JSON.stringify(event)}`);
  }

  onExit(code: number): void {
    Log.showDebug(TAG, `name: ${this.mName}, mWorker.onexit, code: ${code}`);
  }

  onError(err): void {
    Log.showDebug(TAG, `name: ${this.mName}, mWorker.onerror, err: ${JSON.stringify(err)}`);
  }
}
