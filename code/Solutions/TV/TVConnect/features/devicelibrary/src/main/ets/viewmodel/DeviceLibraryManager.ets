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
import { Device, Logger } from '@ohos/common/index';
import { BasicDataSource } from './BasicDataSource';
import { InternationalManager, LibraryManagerFactory, LibraryManagerType } from '@ohos/mine';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import emitter from '@ohos.events.emitter';
import { loadDevices } from './DeviceLoader';

export class DevicesData {
  /**
   * 当前设备库信息列表
   */
  public deviceList: Device[] = [];
  /**
   * 根据一级分类与二级分类分好的设备库信息列表
   */
  public tabContentData: Map<DeviceSelectEnum, Map<number, Array<DetailItemInfo>>> = new Map();
  public tabContentSubData: Map<DeviceSelectEnum, Map<number, Array<DetailItemInfo>>> = new Map();
  /**
   * 根据二级分类索引
   */
  public tabSideData: Map<DeviceSelectEnum, Array<string>> = new Map();
}

/**
 * 设备库管理类
 */
export class DeviceLibraryManager {
  private static instance: DeviceLibraryManager;
  /**
   * 单页数量
   */
  public static readonly LOAD_PAGE_NUM = Number.MAX_VALUE;
  /**
   * 加载更多阙值
   */
  public static readonly LOAD_MORE_THRESHOLD = 20;
  /**
   * 事件通知
   */
  public static readonly EMITTER_DEVICE_LIBRARY_UPDATE_EVENT: number = 1000;
  /**
   * 回调延时
   */
  public static readonly CALLBACK_DELAY = 50;
  /**
   * 事件缓存key
   */
  private LISTENER_EVENT_BASE = 'LISTENER_EVENT';
  /**
   * 根据二级分类索引于设备详情的坐标对应缓存
   */
  private devicesData: DevicesData = new DevicesData();
  /**
   * 事件缓存
   */
  private eventMap: Map<string, Callback<TopTabItemInfo>> = new Map();
  /**
   * 当前点击的设备，用于跳转到设备详情页的信息展示
   */
  public selectItem: DetailItemInfo | undefined = undefined;
  private inited = false;
  private initCallbacks: Array<(inited: boolean) => void> = [];
  private topListData = [
    { index: DeviceSelectEnum.INDUSTRY, title: $r('app.string.application_industry') } as TopTabItemInfo,
    { index: DeviceSelectEnum.OS_TYPE, title: $r('app.string.system_type') } as TopTabItemInfo,
    { index: DeviceSelectEnum.OS_VERSION, title: $r('app.string.system_version') } as TopTabItemInfo,
    { index: DeviceSelectEnum.MANUFACTURER, title: $r('app.string.manufacturer_name') } as TopTabItemInfo,
    { index: DeviceSelectEnum.DEVICE_TYPE, title: $r('app.string.device_type') } as TopTabItemInfo,
    { index: DeviceSelectEnum.CERTIFIED, title: $r('app.string.connect_auth') } as TopTabItemInfo,
  ];

  private constructor() {
  }

  public static getInstance() {
    if (DeviceLibraryManager.instance == undefined) {
      // 创建对象
      DeviceLibraryManager.instance = new DeviceLibraryManager();
      LibraryManagerFactory.getInstance();
      // 注册监听
      DeviceLibraryManager.instance.registerListener();
    }
    return DeviceLibraryManager.instance;
  }

  // 注册监听
  registerListener() {
    InternationalManager.registerLanguageChangeListener(() => {
      Logger.info('DeviceLibraryManager', 'onLanguageChange');
      this.updateData();
    });
    LibraryManagerFactory.getInstance().getManager(LibraryManagerType.DEVICE).registerUpdateLibraryListener(() => {
      Logger.info('DeviceLibraryManager', 'onFileImport');
      this.updateData();
    });
  }


  registerInitCallback(callback: (inited: boolean) => void): void {
    this.initCallbacks.push(callback);
    setTimeout(() => {
      callback(this.inited);
    }, DeviceLibraryManager.CALLBACK_DELAY);
  };

  unRegisterInitCallback(callback: (inited: boolean) => void): void {
    this.initCallbacks = this.initCallbacks.filter((cb) => {
      return (cb !== callback);
    });
  };

  /**
   * 初始化设备库管理类，从数据库中查询所有设备信息
   */
  async updateData() {
    if (this.inited) {
      return;
    }

    loadDevices(getContext())
      .then((data) => {
        this.devicesData = data as DevicesData;
        emitter.emit({ eventId: DeviceLibraryManager.EMITTER_DEVICE_LIBRARY_UPDATE_EVENT });
        this.inited = true;
        this.initCallbacks.forEach((cb) => {
          cb(this.inited);
        });
      }).catch((error: BusinessError) => {
      Logger.error('DeviceLibraryManager', 'update data error = ' + JSON.stringify(error));
    });
  }

  getSideDataArray(tabIndex: DeviceSelectEnum): Array<string> {
    let sideArray = this.devicesData.tabSideData.get(tabIndex);
    return sideArray || [];
  }

  getContentData(tabIndex: number): Map<number, DetailItemInfo[]> {
    let dataMap = this.devicesData.tabContentSubData.get(tabIndex);
    return dataMap ?? new Map();
  }

  getAllContentData(tabIndex: number, sideIndex: number): Array<DetailItemInfo> {
    let dataMap = this.devicesData.tabContentData.get(tabIndex)?.get(sideIndex);
    return dataMap ?? [];
  }

  /**
   * 设备名称全字段搜索
   */
  searchListByNameFullField(value: string): Array<DetailItemInfo> {
    if (!value || value.trim() === '') {
      return [];
    }
    let res: DetailItemInfo[] = [];
    try {
      // 对 value 做转义，防止正则表达式注入
      const escapedValue = value.replace(/[.*+?^${}()|[$$\$$]/g, '\\$&');
      let regex = new RegExp(escapedValue);

      for (let device of this.devicesData.deviceList) {
        const deviceName = device.deviceName ?? '';
        if (regex.test(deviceName)) {
          res.push({ title: deviceName, device: device } as DetailItemInfo);
        }
      }
    } catch (e) {
      Logger.error('DeviceLibraryManager searchListByNameFullField', JSON.stringify(e));
    }
    return res;
  }

  dispatchSideClickListener(tabIndex: number, info: TopTabItemInfo) {
    let event = `${this.LISTENER_EVENT_BASE}_${tabIndex}`;
    let callBack = this.eventMap.get(event);
    if (callBack != undefined) {
      callBack(info);
    }
  }

  registerSideClickListener(tabIndex: number, callBack: Callback<TopTabItemInfo>) {
    let event = `${this.LISTENER_EVENT_BASE}_${tabIndex}`;
    this.eventMap.set(event, callBack);
  }

  unRegisterSideClickListener(tabIndex: number) {
    let event = `${this.LISTENER_EVENT_BASE}_${tabIndex}`;
    this.eventMap.delete(event);
  }

  getTopListData() {
    return this.topListData;
  }
}

/**
 * 一级分类枚举
 */
export enum DeviceSelectEnum {
  INDUSTRY = 0, OS_TYPE, OS_VERSION, MANUFACTURER, DEVICE_TYPE, CERTIFIED
}

/**
 * 一级分类信息
 */
export class TopTabItemInfo {
  public index: number = 0;
  public title: Resource | string = '';
}

export enum ItemTypeEnum {
  DEVICE_ITEM = 0, TITLE_ITEM, PLACE_HOLDER_MORE
}

export class DetailItemInfo {
  public image: Resource | null = null;
  public title: string = '';
  public device: Device | undefined = undefined;
  public itemType: ItemTypeEnum = ItemTypeEnum.DEVICE_ITEM;
  public sideIndex: number = 0;
  public subIndex: number = 0;
}

export class DetailItemListInfo {
  public index: number = 0;
  public title: string = '';
  public detailItems: DetailItemInfo[] = [];
}

/**
 * 用于懒加载的设备库数据源
 */
export class DeviceLibraryDataSource extends BasicDataSource<DetailItemInfo> {
  private currentTab = 0;
  private dataMap: Map<number, DetailItemInfo[]> = new Map();

  constructor(currentTab: number) {
    super();
    this.currentTab = currentTab;
  }

  public reloadData() {
    this.dataMap = DeviceLibraryManager.getInstance().getContentData(this.currentTab);
    const dataArray: DetailItemInfo[] = [];
    this.dataMap.forEach(data => {
      dataArray.push(...data);
    });
    this.setData(dataArray);
    this.notifyDataReload();
  }

  public getSideData(sideIndex: number): DetailItemInfo[] | undefined {
    let data = this.dataMap.get(sideIndex)?.filter(value => {
      return value.itemType !== ItemTypeEnum.TITLE_ITEM;
    });
    return data && data.length > 0 ? data : undefined;
  }
}

/**
 * 用于懒加载的侧边栏数据源
 */
export class SideListDataSource extends BasicDataSource<string> {
  private currentTab = 0;

  constructor(currentTab: number) {
    super();
    this.currentTab = currentTab;
  }

  loadData() {
    let array = DeviceLibraryManager.getInstance().getSideDataArray(this.currentTab);
    this.setData(array);
    this.notifyDataReload();
  }
}

export class TabBarDataSource extends BasicDataSource<TopTabItemInfo> {
  constructor() {
    super();
    this.originDataArray.push(...DeviceLibraryManager.getInstance().getTopListData());
  }
}

export class DeviceMoreDataSource extends BasicDataSource<DetailItemInfo> {
  private currentTab = 0;
  private sideIndex = 0;

  constructor(currentTab: DeviceSelectEnum, sideIndex: number) {
    super();
    this.currentTab = currentTab;
    this.sideIndex = sideIndex;
  }

  public loadData() {
    let total = DeviceLibraryManager.getInstance().getAllContentData(this.currentTab, this.sideIndex);
    this.setData(total);
    this.notifyDataReload();
  }
}

/**
 * 设备详情信息
 */
@Observed
export class DeviceDetailInfo {
  public infos: [Resource, string][] = [];

  constructor(info: DetailItemInfo) {
    if (info?.device != undefined) {
      this.infos.push([$r('app.string.manufacturer_name'), info.device.manufacturer.manufacturerName]);
      this.infos.push([$r('app.string.device_type'), info.device.deviceType.deviceTypeName]);
      this.infos.push([$r('app.string.device_name'), info.device.deviceName]);
      this.infos.push([$r('app.string.operating_system_type'), info.device.osTypeName]);
      this.infos.push([$r('app.string.operating_system_version_number'), info.device.osVersion]);
    }
  }
}