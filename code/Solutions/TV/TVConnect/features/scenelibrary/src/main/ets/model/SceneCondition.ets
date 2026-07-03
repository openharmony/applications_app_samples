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

@Observed
class TriggerCondition {
  public id: string = '';
  public deviceType: string = '';
  public deviceName: string = '';
  public eventTitleName?: string = '';
  public eventId?: string = '';
  public eventValue?: string = '';
  public eventName?: string = '';

  constructor(id: string, deviceType: string, deviceName: string, eventTitleName?: string, eventId?: string,
    eventValue?: string,
    eventName?: string) {
    this.id = id;
    this.deviceType = deviceType;
    this.deviceName = deviceName;
    this.eventTitleName = eventTitleName;
    this.eventId = eventId;
    this.eventValue = eventValue;
    this.eventName = eventName;
  }
}

@Observed
class Actions {
  public id: string = '';
  public deviceType: string = '';
  public deviceName: string = '';
  public actionTitleName?: string = '';
  public actionId?: string = '';
  public actionValue?: string = '';
  public actionName?: string = '';

  constructor(id: string, deviceType: string, deviceName: string, actionTitleName?: string, actionId?: string,
    actionValue?: string,
    actionName?: string) {
    this.id = id;
    this.deviceType = deviceType;
    this.deviceName = deviceName;
    this.actionTitleName = actionTitleName;
    this.actionId = actionId;
    this.actionValue = actionValue;
    this.actionName = actionName;
  }
}

class ActionBean {
  public eventId: string = '';
  public eventName: string = '';

  constructor(eventId: string, eventName: string) {
    this.eventId = eventId;
    this.eventName = eventName;
  }
}

@Observed
class CustomIconList {
  public label: string;
  public value: string;
  public check: boolean; //当前选中项目

  constructor(label: string, value: string, check: boolean) {
    this.label = label;
    this.value = value;
    this.check = check;
  }
}


@Observed
class DeviceList {
  public id: string;
  public name: string;
  public type: string; //1 在线 0 离线
  public check: boolean; //当前选中项目

  constructor(id: string, name: string, type: string, check: boolean) {
    this.id = id;
    this.name = name;
    this.type = type;
    this.check = check;
  }
}


/**
 * 执行事件/动作数据
 */
export interface IUiInfo {
  descCh: string;
  descEn: string;
  enumVal: string;
}

@Observed
export default class EventActionUIInfoDataItem {
  public path: string = '';
  public uiInfo: IUiInfo[] = [];
  public id: string = '';
  public name: string = '';
  public nameEn: string = '';
  public conflictType: string = '';
  public type: string = '';
  public operator: string = '';
  public min: string = '';
  public max: string = '';
  public unit: string = '';
  public unitEn: string = '';
  public check: boolean = false; //当前选中项目
  public selectedName: string = ''; //已选择名称
  public selectedValue: string = ''; //已选择值

  constructor(path: string, uiInfo: IUiInfo[], id: string, name: string, nameEn: string, conflictType: string,
    type: string,
    operator: string, min: string, max: string, unit: string, unitEn: string, check: false, selectedName: string,
    selectedValue: string) {
    this.path = path;
    this.uiInfo = uiInfo;
    this.id = id;
    this.name = name;
    this.nameEn = nameEn;
    this.conflictType = conflictType;
    this.type = type;
    this.operator = operator;
    this.min = min;
    this.max = max;
    this.unit = unit;
    this.unitEn = unitEn;
    this.check = check;
    this.selectedName = selectedName;
    this.selectedValue = selectedValue;
  }
}

// 触发执行动作数据
@Observed
class EventActionUIInfoData {
  public prodId: string;
  public deviceTypeId: string;
  public deviceName: string;
  public eventUIInfo: Array<EventActionUIInfoDataItem>; //触发条件UI
  public actionUIInfo: Array<EventActionUIInfoDataItem>; //执行任务UI

  constructor(prodId: string, deviceTypeId: string, deviceName: string, eventUIInfo: Array<EventActionUIInfoDataItem>,
    actionUIInfo: Array<EventActionUIInfoDataItem>) {
    this.prodId = prodId;
    this.deviceTypeId = deviceTypeId;
    this.deviceName = deviceName;
    this.eventUIInfo = eventUIInfo;
    this.actionUIInfo = actionUIInfo;
  }
}


export {
  TriggerCondition as triggerCondition,
  Actions as actions,
  ActionBean as actionBean,
  CustomIconList,
  DeviceList,
  EventActionUIInfoDataItem,
  EventActionUIInfoData };