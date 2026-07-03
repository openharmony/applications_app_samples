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
export interface ISuperDefinitionList {
  id: string;
  name: Resource;
}

export interface IProductionInformation {
  id: string;
  label: string;
  value: string;
  icon: Resource;
}

export interface ISelectInformationTypeList {
  id: string;
  label: string;
}

export interface IAssemblyUnitList {
  id: string;
  label: string;
}

export interface IFeatureList {
  id: string;
  label: string;
}

/**
 * 进度加载
 */
@Observed
export class Schedule {
  public label: string;
  public check: boolean;

  constructor(label: string, check: boolean) {
    this.label = label;
    this.check = check;
  }
}


/**
 * 设备控制
 */
@Observed
export class DeviceControlOperation {
  public label: string | Resource;
  public value: string;

  constructor(label: string | Resource, value: string) {
    this.label = label;
    this.value = value;
  }
}

/**
 * 摄像头转向
 */
@Observed
export class CameraSteering {
  public label: string | Resource;
  public value: number;

  constructor(label: string | Resource, value: number) {
    this.label = label;
    this.value = value;
  }
}

/**
 * 选择坐标列表
 */
@Observed
export class CoordinateList {
  public id: string;
  public name: string;
  public check: boolean; //当前选中项目
  public level?: string; //水平
  public pitching?: string; //俯仰
  public focal?: string; //焦距

  constructor(id: string, name: string, check: boolean, level?: string, pitching?: string, focal?: string) {
    this.id = id;
    this.name = name;
    this.check = check;
    this.level = level;
    this.pitching = pitching;
    this.focal = focal;
  }
}

/**
 * 设备用途
 */
@Observed
export class ApplicationEquipmentList {
  public label: string;
  public value: string;
  public check: boolean;

  constructor(label: string, value: string, check: boolean) {
    this.label = label;
    this.value = value;
    this.check = check;
  }
}


/**
 * 扫设备列表描
 */
@Observed
export class ScanningDeviceList {
  public label: string;
  public value: string;
  public check: boolean;

  constructor(label: string, value: string, check: boolean) {
    this.label = label;
    this.value = value;
    this.check = check;
  }
}


/**
 * 选择分类列表
 */
@Observed
export class SelectCategoryList {
  public label: string;
  public value: string;

  constructor(label: string, value: string) {
    this.label = label;
    this.value = value;
  }
}

/**
 * 分布式摄像头列表
 */
@Observed
export class DistributedCameraList {
  public id: string;
  public name: string;

  constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }
}

/**
 * 报警信息列表
 */
@Observed
export class AlarmInformationList {
  public id: string;
  public name: string;

  constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }
}


/**
 * 故障管理列表
 */
@Observed
export class FaultManagementlist {
  public id: string;
  public title: string;
  public deviceNumber: string;
  public type: string;
  public maskable: string;
  public invalid: string;

  constructor(id: string, title: string, deviceNumber: string, type: string, maskable: string, invalid: string) {
    this.id = id;
    this.title = title;
    this.deviceNumber = deviceNumber;
    this.type = type;
    this.maskable = maskable;
    this.invalid = invalid;
  }
}

/**
 * 菜单列表
 */
@Observed
export class MenuList {
  public id: string;
  public name: string;
  public icon: Resource;

  constructor(id: string, name: string, icon: Resource) {
    this.id = id;
    this.name = name;
    this.icon = icon;
  }
}