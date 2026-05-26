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


/*
 * 场景
 * */
export interface Scene {
  scenarioCard: ScenarioCard;
  flow: Flow[];
}

/*
 * 场景信息
 * */
export interface ScenarioCard {
  scenarioCardId: string;
  title: string;
  version: string;
  enabled: boolean;
  foreground: string;
  logo: string;
  author: string;
  order: number;
  tag: string;
  type: string;
  description: string;
}

/*
 * 流程
 * */
export interface Flow {
  createTime: string;
  hasCustomAction: boolean;
  id: string;
  repeatInterval: number;
  repeatTimes: number;
  title: string;
  type: string;
  version: string;
  actions: Action[]; //根据actionType判断应该转换为哪一个子类
  trigger: Trigger;
}

/*
 * 父类action
 * */
export interface Action {
  actionId: string;
  actionType: string;
  actions: Action[];
}

/*
 * 设备控制action
 * */
export interface DeviceAction extends Action {
  conditions: object[]; //当前场景库无condition实例，后续补充
  enabled: boolean;
  source: number;
  title: string;
  valid: boolean;
}

/*
 * subsystem控制action
 * */
export interface SubsystemAction extends Action {
  actionId: string;
  actionType: string;
  type: string;
  deviceInfo: DeviceInfo;
  servies: Services;
  command: string;
}

/*
 * 触发条件
 * */
export interface Trigger {
  events: Event[];
}

/*
 * 设备信息
 * */
export interface DeviceInfo {
  devId: string;
  devName: string;
  devType: string;
  path: string;
}

/*
 * 服务
 * */
export interface Services {
  sid: string;
  data: ServicesData;
}

/*
 * 服务数据
 * */
export interface ServicesData {
  characteristicName1: string;
  characteristicName2: string;
}

/*事件
 * */
export interface Event {
  type: string;
  deviceInfo: DeviceInfo;
  operator: string;
  value: string;
  strategy: EventStrategy;
  pushMsg: string;
}

/*
 * 策略
 * */
export interface EventStrategy {
  trigger: string;
}

/*
 * 设置（当前场景库无settiongs实例，后续补充）
 * */
export interface Settings {}