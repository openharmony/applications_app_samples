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
import { common } from '@kit.AbilityKit';
import { ConnectDatabaseHelperImpl, Device, DeviceLibraryDao, Logger } from '@ohos/common';
import {
  DetailItemInfo,
  DetailItemListInfo,
  DevicesData,
  DeviceSelectEnum,
  ItemTypeEnum
} from './DeviceLibraryManager';

/**
 * 初始化设备库管理类，从数据库中查询所有设备信息
 */
@Concurrent
export async function loadDevices(context: common.BaseContext): Promise<DevicesData> {
  const TAG = 'loadDevices';

  const SUB_ARRAY_SIZE = 10;
  const CERTIFIED_SUB_ARRAY_SIZE = 12;

  const data: DevicesData = new DevicesData();
  Logger.debug(TAG, 'updateData start');
  let databaseHelper = await ConnectDatabaseHelperImpl.getInstance(context);
  let dao = new DeviceLibraryDao(databaseHelper);
  let deviceList: Device[] = await dao.queryAllDevice();
  Logger.debug(TAG, 'updateData queryAllDevice end');
  if (deviceList == undefined || deviceList.length == 0) {
    Logger.warn(TAG, 'query All device size==0');
    return data;
  }
  data.deviceList = deviceList;
  let industryMap: Map<string, DetailItemListInfo> = new Map();
  let osTypeMap: Map<string, DetailItemListInfo> = new Map();
  let osVersionMap: Map<string, DetailItemListInfo> = new Map();
  let manufacturerMap: Map<string, DetailItemListInfo> = new Map();
  let deviceTypeMap: Map<string, DetailItemListInfo> = new Map();
  let connectCertifiedMap: Map<string, DetailItemListInfo> = new Map();
  Logger.debug(TAG, 'updateData analysis start');
  for (let device of deviceList) {
    let deviceItem = { title: device.deviceName, device: device } as DetailItemInfo;
    for (let i of device.industry) {
      let industryData = industryMap.get(i.industryName) ?? new DetailItemListInfo;
      industryData.title = i.industryName;
      industryData.detailItems.push(deviceItem);
      industryMap.set(i.industryName, industryData);
    }
    let osTypeData = osTypeMap.get(device.osTypeName) ?? new DetailItemListInfo;
    osTypeData.title = device.osTypeName;
    osTypeData.detailItems.push(deviceItem);
    osTypeMap.set(device.osTypeName, osTypeData);
    let osVersionData = osVersionMap.get(device.osVersion) ?? new DetailItemListInfo;
    osVersionData.title = device.osVersion;
    osVersionData.detailItems.push(deviceItem);
    osVersionMap.set(device.osVersion, osVersionData);
    let manufacturerData = manufacturerMap.get(device.manufacturer.manufacturerName) ?? new DetailItemListInfo;
    manufacturerData.title = device.manufacturer.manufacturerName;
    manufacturerData.detailItems.push(deviceItem);
    manufacturerMap.set(device.manufacturer.manufacturerName, manufacturerData);
    let deviceTypeData = deviceTypeMap.get(device.deviceType.deviceTypeName) ?? new DetailItemListInfo;
    deviceTypeData.title = device.deviceType.deviceTypeName;
    deviceTypeData.detailItems.push(deviceItem);
    deviceTypeMap.set(device.deviceType.deviceTypeName, deviceTypeData);
    if (device.oHConnectCertified) {
      let connectCertifiedData = connectCertifiedMap.get('certified') ?? new DetailItemListInfo;
      connectCertifiedData.detailItems.push(deviceItem);
      connectCertifiedMap.set('certified', connectCertifiedData);
    }
  }
  Logger.debug('DeviceLibraryManager', 'updateData analysis end');

  const detailItemInfoCopy = (item: DetailItemInfo, sideIndex: number, subIndex: number): DetailItemInfo => {
    const d = new DetailItemInfo();
    d.image = item.image;
    d.title = item.title;
    d.device = item.device;
    d.itemType = item.itemType ?? 0;
    d.sideIndex = sideIndex;
    d.subIndex = subIndex;
    return d;
  };
  const setDetailItemList = (data: DevicesData, selectEnum: DeviceSelectEnum, map: Map<string, DetailItemListInfo>) => {
    let allDataMap: Map<number, Array<DetailItemInfo>> = new Map();
    let subDataMap: Map<number, Array<DetailItemInfo>> = new Map();
    let sideArray: string[] = [];
    let sideIndex = 0;
    map.forEach((item) => {
      const subArray: DetailItemInfo[] = [];
      let subArraySize = CERTIFIED_SUB_ARRAY_SIZE;
      if (selectEnum != DeviceSelectEnum.CERTIFIED) {
        subArraySize = SUB_ARRAY_SIZE;
        let emptyInfo = new DetailItemInfo();
        emptyInfo.title = item.title;
        emptyInfo.sideIndex = sideIndex;
        emptyInfo.itemType = ItemTypeEnum.TITLE_ITEM;
        subArray.push(emptyInfo);
        if (sideArray.indexOf(item.title) == -1) {
          sideArray.push(item.title);
        }
      }

      allDataMap.set(sideIndex, item.detailItems);
      if (item.detailItems.length > subArraySize) {
        const itemCopy =
          item.detailItems.slice(0, subArraySize - 1).map((v, index) => detailItemInfoCopy(v, sideIndex, index));
        subArray.push(...itemCopy);
        const morePlaceHolder = new DetailItemInfo();
        morePlaceHolder.itemType = ItemTypeEnum.PLACE_HOLDER_MORE;
        morePlaceHolder.sideIndex = sideIndex;
        morePlaceHolder.subIndex = subArraySize - 1;
        subArray.push(morePlaceHolder);
      } else {
        const itemCopy = item.detailItems.map((v, index) => detailItemInfoCopy(v, sideIndex, index));
        subArray.push(...itemCopy);
      }
      subDataMap.set(sideIndex, subArray);
      sideIndex++;
    });
    data.tabContentData.set(selectEnum, allDataMap);
    data.tabContentSubData.set(selectEnum, subDataMap);
    data.tabSideData.set(selectEnum, sideArray);

  };

  Logger.debug(TAG, 'set data start');
  setDetailItemList(data, DeviceSelectEnum.INDUSTRY, industryMap);
  setDetailItemList(data, DeviceSelectEnum.OS_TYPE, osTypeMap);
  setDetailItemList(data, DeviceSelectEnum.OS_VERSION, osVersionMap);
  setDetailItemList(data, DeviceSelectEnum.MANUFACTURER, manufacturerMap);
  setDetailItemList(data, DeviceSelectEnum.DEVICE_TYPE, deviceTypeMap);
  setDetailItemList(data, DeviceSelectEnum.CERTIFIED, connectCertifiedMap);
  Logger.debug(TAG, ' set data end');
  return data;
}


