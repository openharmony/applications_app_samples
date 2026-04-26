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
 

import { Event } from '../../default/event/EventUtil';

export default class Constants {
  static readonly INIT_CONFIG = 'initConfig';
  static readonly INIT_FINISH = 'initFinish';
  static readonly CLEAR_ALL = 'clearAll';
  static readonly ADD_ITEM = 'addItem';
  static readonly REMOVE_ITEM = 'removeItem';
  static readonly LOCAL_DEVICE = 'local';
  static readonly LOAD_DATA = 'loadData';
  static readonly LOAD_PLUGIN_COMPONENT_DATA = 'loadPluginComponentData';
  static readonly UPDATE_PLUGIN_COMPONENT_DATA = 'updatePluginComponentData';
}

export interface FilterData {
  id: string;
  bundleName: string;
  abilityName: string;
}

export interface LoaderConfigInfo {
  action?: string;
  permission?: string;
}

export interface LoaderConfigMap {
  metaSource?: LoaderConfigInfo;
  pluginSourceLoader?: LoaderConfigInfo;
  dataAbilitySourceLoader?: LoaderConfigInfo;
}

export interface RootConfigInfo {
  action: string;
  filterDatas: FilterData[];
  loaderConfig: LoaderConfigMap;
}

export enum PluginType {
  META = 1,
  DATA_ABILITY = 2,
  PLUGIN_COMPONENT = 3,
}

export type MsgData = string | number | boolean | Object | undefined;

export interface WorkerMsg {
  action: string;
  data: MsgData;
}

export function obtainMsg(action: string, data: MsgData): WorkerMsg {
  const msg: WorkerMsg = {
    action: action,
    data: data
  };
  return msg;
}

export interface ItemComponentData {
  id: string;
  pluginType: number;
  deviceId: string;
  bundleName: string;
  moduleName: string,
  abilityName: string;
  abilityLabelId: number;
  abilityIconId: number;
  label?: string;
  iconUrl?: Resource | string;
  template?: string;
  state?: Object;
  actionData?: ActionData;
}

export class ActionData {
  clickAction?: Event;
  longClickAction?: Event;
  launchType?: number;
  pluginData?: PluginComponentData;
  extra?: Object;
}

export class PluginComponentData {
  public template: string = '';
  public data: PluginComponentPayload = new PluginComponentPayload();
}

export class PluginComponentPayload {
}
