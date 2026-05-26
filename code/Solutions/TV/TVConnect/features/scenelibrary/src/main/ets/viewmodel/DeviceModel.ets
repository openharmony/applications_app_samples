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
import { Logger, PreferencesHelper } from '@ohos/common';
import { DeviceInfo } from '@ohos/common/src/main/ets/database/entity/Scene';
import { InternationalManager } from '@ohos/mine';
import ActionItem from '../common/bean/ActionItem';
import DeviceItem from '../common/bean/DeviceItem';
import {
  actionBean,
  EventActionUIInfoDataItem,
  EventActionUIInfoData,
  triggerCondition
} from '../model/SceneCondition';
import { mock } from '../res/Mock';
import { profileEca } from '../res/Profile_eca';
import PositionComputerUtil from '../util/PositionComputingUtil';
import Point from './Point';
import { mockEN } from '../res/Mock_en';

const TAG = 'DevicesModel';

@Observed
export default class DevicesModel {
  public devicesArray: DeviceItem[] = [];
  public currentDevicesNum: number = 0;
  public triggersDevice: DeviceItem[] = [];
  // 获取已添加触发设备
  public triggers: DeviceItem[] = [];
  // 获取已添加执行设备
  public actions: DeviceItem[] = [];
  public deviceList: ActionItem[] = [];
  // 获取触发执行动作数据
  public eventActionUiInfoData: EventActionUIInfoData = new EventActionUIInfoData('', '', '', [], []);

  /**
   * 获取所有设备数据
   */
  public async getDevice() {
    let list: DeviceInfo[] = JSON.parse(mock).equipment;
    for (let i = 0; i < list.length; i++) {
      let item = new DeviceItem(list[i].devId, this.getDeviceIcon(list[i].devType), list[i].devName, list[i].devType);
      item.point.x = this.genPointByIndex(i).x;
      item.point.y = this.genPointByIndex(i).y;
      this.devicesArray.push(item);
    }
    Logger.info('devicesArray:' + JSON.stringify(this.devicesArray));
  }

  // 获取所有自定义设备
  public async getAllCustomDevice() {
    let language: string = await PreferencesHelper.get(InternationalManager.CURRENT_LANGUAGE_KEY, '') as string;
    let list: DeviceItem[] = language == 'EN' ? JSON.parse(mockEN).device : JSON.parse(mock).device;
    for (let i = 0; i < list.length; i++) {
      let item =
        new DeviceItem(list[i].deviceId, this.getDeviceIcon(list[i].deviceType), list[i].deviceName, list[i].deviceType);
      item.point.x = this.genPointByIndex(i).x;
      item.point.y = this.genPointByIndex(i).y;
      this.devicesArray.push(item);
    }
  }

  /**
   * 获取已添加执行设备列表数据
   */
  public getAddedTriggers(type: number, index: number, deviceType: string, device: DeviceItem) {
    Logger.info('数据源device：' + JSON.stringify(device));
    if (deviceType == device.deviceType) {
      if (type === 1) {
        this.triggers[index] = device;
      } else {
        this.actions[index] = device;
      }
      return true;
    }
    return false;
  }

  /**
   * 清空设备列表数据
   */
  public async getDeviceListEmpty() {
    this.deviceList = [];
    this.triggersDevice = [];
  }

  /**
   * 获取设备列表数据
   */
  public async getTriggersDevice(type: number) {
    let language: string = await PreferencesHelper.get(InternationalManager.CURRENT_LANGUAGE_KEY, '') as string;
    let list: DeviceItem[] = [];
    if (type == 1) {
      list = language == 'EN' ? JSON.parse(mockEN).triggersDevice : JSON.parse(mock).triggersDevice;
    } else {
      list = language == 'EN' ? JSON.parse(mockEN).executeDevice : JSON.parse(mock).executeDevice;
    }

    for (let i = 0; i < list.length; i++) {
      this.deviceList.push(new ActionItem(list[i].deviceId, list[i].deviceName, list[i].deviceType, false));
      let item =
        new DeviceItem(list[i].deviceId, this.getDeviceIcon(list[i].deviceType), list[i].deviceName, list[i].deviceType,
          list[i].actions);
      this.triggersDevice.push(item);
    }
  }


  /**
   * 根据设备ID查询设备可执行行为
   * @param id
   */
  public getActions(id: string) {
    let actionList: ActionItem[] = [];
    let result: Array<actionBean> | undefined = this.triggersDevice.filter((item: DeviceItem) => {
      return item.deviceId == id;
    })[0]?.actions;
    if (result) {
      result.forEach((item: actionBean) => {
        actionList.push(new ActionItem(item.eventId, item.eventName, '0', false));
      });
    }
    return actionList;
  }

  /**
   * 获取可执行行为事件/动作
   */
  public async getEventActionUiInfoData(type: number) {
    let data = JSON.parse(profileEca) as object;
    this.eventActionUiInfoData =
      new EventActionUIInfoData(data['prodId'], data['deviceTypeId'], data['deviceName'], [], []);

    data['eventUIInfo'].forEach((res: EventActionUIInfoDataItem) => {
      this.eventActionUiInfoData.eventUIInfo.push(new EventActionUIInfoDataItem(
        res.path,
        res.uiInfo,
        res.id,
        res.name,
        res.nameEn,
        res.conflictType,
        res.type,
        res.operator,
        res.min,
        res.max,
        res.unit,
        res.unitEn,
        false,
        '',
        '',
      ));
    }) || [];

    data['actionUIInfo'].forEach((res: EventActionUIInfoDataItem) => {
      this.eventActionUiInfoData.actionUIInfo.push(new EventActionUIInfoDataItem(
        res.path,
        res.uiInfo,
        res.id,
        res.name,
        res.nameEn,
        res.conflictType,
        res.type,
        res.operator,
        res.min,
        res.max,
        res.unit,
        res.unitEn,
        false,
        '',
        '',
      ));
    }) || [];
  }

  /**
   * 根据设备类型获取对应的设备标识
   * @param index
   */
  public getDeviceIcon(deviceType: string) {
    let icon: Resource = $r('app.media.ic_camera');
    switch (deviceType) {
      case '02A':
        icon = $r('app.media.ic_camera');
        break;
      case '02B':
        icon = $r('app.media.ic_gate');
        break;
      case '02C':
        icon = $r('app.media.ic_printer');
        break;
      case '02D':
        icon = $r('app.media.ic_camera');
        break;
      default:
        icon = $r('app.media.ic_pos');
        break;
    }
    return icon;
  }

  /**
   * 根据拖拽初始参数生成偏移度
   * @param index
   */
  public genPointByIndex(index: number): Point {
    return PositionComputerUtil.getInstance().getPointByIndex(index);
  }
}