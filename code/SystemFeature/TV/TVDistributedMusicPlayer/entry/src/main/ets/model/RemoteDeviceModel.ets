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

import logger from '../utils/Logger';
import { objType } from '../utils/Utils';
import { AuthParam } from '../const/Type';

interface DeviceState {
  loading: boolean;
  msg: string;
}

let deviceStateObj: Map<string, DeviceState> = new Map();
deviceStateObj.set('1', { loading: false, msg: '点击进行设备互信' });
deviceStateObj.set('2', { loading: true, msg: '设备互信中...' });
deviceStateObj.set('3', { loading: false, msg: '在线，点击进行流转' });
deviceStateObj.set('4', { loading: false, msg: '离线，等待对端设备上线' });
deviceStateObj.set('5', { loading: true, msg: '启动视频流转中...' });
deviceStateObj.set('6', { loading: false, msg: '视频流转中，点击停止' });
deviceStateObj.set('7', { loading: false, msg: '停止视频流转中...' });

const BUNDLE_NAME = 'com.ohos.demandplayer';

export interface DeviceInfo {
  deviceId: string;
  deviceName: string;
  deviceType: DeviceType;
  networkId: string;
  range: number;
}

export enum DeviceType {
  UNKNOWN_TYPE = 0,
  SPEAKER = 0x0A,
  PHONE = 0x0E,
  TABLET = 0x11,
  WEARABLE = 0x6D,
  CAR = 0x83,
  TV = 0x9C
}

export enum DeviceStateChangeAction {
  ONLINE = 0,
  READY = 1,
  OFFLINE = 2,
  CHANGE = 3
}

export interface DistributedManagerDeviceInfo {
  deviceId: string;
  deviceName: string;
  deviceType: DeviceType;
  networkId: string;
  range: number;
  deviceState?: DeviceState | number;
  isInAuth?: boolean; // 是否正在可信认证
  isTrust?: boolean; // 是否可信
  trustDeviceId?: string; // 可信设备id
  transferLoading?: boolean; // 是否流转中
  isInTransfer?: boolean; // 是否流转中
  action?:DeviceStateChangeAction; // 可信设备状态 0在线， 1：设备已OK 2:设备已离线
  updateTime?:number; // 最后一次更新时间
  pinToken?: number;
  isDelete?: boolean;
}

export class DistributedManager {
  private static instance: DistributedManager | null; // 单例对象

 private deviceManager: object | null = null;
  public subscribeId: number;
  public publishId: number;

  public findingChange: object | null = null;
  public deviceList: DistributedManagerDeviceInfo[] | null; // 设备列表
  public deviceListChange: (data: DistributedManagerDeviceInfo[]) => void = () => {};

  public trustIdList: string[]; // 可信设备ID列表
  public trustDeviceMap: Map<string, DistributedManagerDeviceInfo>; // 设备对象列表

  public deviceIdList: string[]; // 设备ID列表
  public deviceMap: Map<string, DistributedManagerDeviceInfo>; // 设备对象列表

  public localDeviceInfo:DeviceInfo | null;

  public findingInterval: number | null = null;
  public findingTrustInterval: number | null = null;

  public onFoundInterval: number | null = null;


  // 构造函数，初始化分布式设备管理器
  // 生成订阅和发布ID，初始化设备列表和映射
  private constructor(){
    this.subscribeId = this.getSubscribeId();
    this.publishId = this.getPublishId();
    this.findingChange = null;
    this.localDeviceInfo = null;
    this.deviceList = [];

    this.trustIdList = [];
    this.trustDeviceMap = new Map<string, DistributedManagerDeviceInfo>();

    this.deviceIdList = [];
    this.deviceMap = new Map<string, DistributedManagerDeviceInfo>();

    // 创建设备管理器实例
    this.createDeviceManager();
  }
  // 获取分布式设备管理器单例
  // 确保整个应用只有一个设备管理器实例
  static getInstance(): DistributedManager {
    if (DistributedManager.instance == null) {
      DistributedManager.instance = new DistributedManager();
    }
    return DistributedManager.instance;
  }

  // SubscribeId
  getSubscribeId(){
    return 16251;
  }

  // publishId
  getPublishId(){
    return 16252;
  }

  // 创建设备管理器
  // 模拟设备管理器的创建过程，初始化相关回调和监听器
  createDeviceManager(){
    logger.debug(`createDeviceManager IN`);
    try {
      // 模拟创建设备管理器
      setTimeout(() => {
        // 模拟成功回调
        interface DeviceManager {
          // 设备管理器方法
        }
        this.deviceManager = {} as DeviceManager;
        // 模拟调用后续方法，初始化设备管理功能
        this.getLocalDeviceInfo();
        this.stopDeviceDiscovery();
        this.publishDeviceDiscovery();
        this.onServiceDie();
        this.onDeviceFound();
        this.onDiscoverFail();
        this.onDeviceStateChange();
        this.getTrustedDeviceList();
      }, 100);
    } catch(err) {
      logger.debug('createDeviceManager try catch! errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  // 获取本地设备信息
  // 模拟获取本地设备的基本信息，包括设备ID、名称、类型等
  getLocalDeviceInfo(){ 
    logger.debug(`getLocalDeviceInfo IN`);
    try {
      if (this.deviceManager) {
        // 模拟获取本地设备信息
        setTimeout(() => {
          const mockData: DeviceInfo = {
            deviceId: 'local-device-id',
            deviceName: 'Local Device',
            deviceType: DeviceType.TV,
            networkId: 'local-network-id',
            range: 0
          };
          logger.debug('getLocalDeviceInfo: ' + JSON.stringify(mockData));
          this.localDeviceInfo = mockData;
        }, 100);
      }
    } catch (err) {
      logger.debug('getLocalDeviceInfo try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  // 注册发现设备回调监听
  // 当发现新设备时，将设备信息添加到设备列表中
  onDeviceFound(){
    // 模拟注册发现设备回调监听
    try {
      if (this.deviceManager) {
        // 模拟设备发现
        setTimeout(() => {
          interface DeviceFoundData {
            device: DeviceInfo;
          }
          const mockData: DeviceFoundData = {
            device: {
              deviceId: 'mock-device-id-1',
              deviceName: 'Mock Device 1',
              deviceType: DeviceType.TV,
              networkId: 'mock-network-id-1',
              range: 10
            }
          };
          logger.debug('onDeviceFound callback:' + JSON.stringify(mockData));
          if(mockData && mockData.device && mockData.device.deviceId){
            let updateTime = new Date().getTime();
            if(!this.deviceMap.get(mockData.device.deviceId)){
              // 新设备，创建设备信息对象并添加到设备列表
              let device:DistributedManagerDeviceInfo = {
                deviceId: mockData.device.deviceId,
                deviceName: mockData.device.deviceName,
                deviceType: mockData.device.deviceType,
                networkId: mockData.device.networkId,
                range: mockData.device.range,
                isInAuth: false,
                isTrust: false,
                trustDeviceId: '',
                transferLoading: false,
                isInTransfer: false,
                deviceState: deviceStateObj.get('1'),
                action: DeviceStateChangeAction.READY,
                updateTime: updateTime,
                pinToken: -1,
                isDelete: false,
              };
              this.addDevice(mockData.device.deviceId, device);
            } else {
              // 设备已存在，更新设备的最后更新时间
              this.updateDeviceProp(mockData.device.deviceId, 'updateTime', updateTime);
            }
            if(this.onFoundInterval){
              clearInterval(this.onFoundInterval);
            }
            // 延迟更新设备列表，确保所有设备信息都已处理
            this.onFoundInterval = setTimeout(()=>{
              this.updateDeviceIdList();
            }, 200);
          }
        }, 100);
      }
    } catch (err) {
      logger.debug('onDeviceFound try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  offDeviceFound(){
    try {
      if (this.deviceManager) {
        // 模拟取消监听
        logger.debug(`offDeviceFound success`);
      }
    } catch (err) {
      logger.debug('offDeviceFound try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  // 注册设备发现失败回调监听。
  onDiscoverFail() {
    try {
      if (this.deviceManager) {
        // 模拟注册失败回调
        logger.debug(`onDiscoverFail success`);
      }
    } catch (err) {
      logger.debug('onDiscoverFail try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  offDiscoverFail() {
    try {
      if (this.deviceManager) {
        // 模拟取消监听
        logger.debug(`offDiscoverFail success`);
      }
    } catch (err) {
      logger.debug('offDiscoverFail try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  onPublishSuccess(){
    try {
      if (this.deviceManager) {
        // 模拟注册发布成功回调
        logger.debug(`onPublishSuccess success`);
      }
    } catch (err) {
      logger.debug('onPublishSuccess try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  offPublishSuccess(){
    try {
      if (this.deviceManager) {
        // 模拟取消监听
        logger.debug(`offPublishSuccess success`);
      }
    } catch (err) {
      logger.debug('offPublishSuccess errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  onPublishFail(){
    try {
      if (this.deviceManager) {
        // 模拟注册发布失败回调
        logger.debug(`onPublishFail success`);
      }
    } catch (err) {
      logger.debug('publishFail try catch errCode:' + err.code + ',errMessage:' + err.message);
    }

  }

  offPublishFail(){
    try {
      if (this.deviceManager) {
        // 模拟取消监听
        logger.debug(`offPublishFail success`);
      }
    } catch (err) {
      logger.debug('offPublishFail try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  onServiceDie(){
    try {
      if (this.deviceManager) {
        // 模拟注册服务死亡回调
        logger.debug(`onServiceDie success`);
      }
    } catch (err) {
      logger.debug('serviceDie try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  offServiceDie(){
    try {
      if (this.deviceManager) {
        // 模拟取消监听
        logger.debug(`offServiceDie success`);
      }
    } catch (err) {
      logger.debug('offServiceDie errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  // 监听设备状态改变回调
  onDeviceStateChange(){
    try {
      if (this.deviceManager) {
        // 模拟注册设备状态改变回调
        logger.debug(`onDeviceStateChange success`);
      }
    } catch (err) {
      logger.debug('deviceStateChange try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  offDeviceStateChange(){
    try {
      if (this.deviceManager) {
        // 模拟取消监听
        logger.debug(`offDeviceStateChange success`);
      }
    } catch (err) {
      logger.debug('offDeviceStateChange errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  offAllEvents(){
    this.stopDeviceDiscovery();
    this.offDeviceFound();
    this.offDiscoverFail();
    this.offDeviceStateChange();
    this.offServiceDie();
  }


  // 开始扫描设备
  // 定期执行设备发现和获取可信设备列表操作
  startScan(){
    // 先停止之前的扫描
    this.stopScan();
    // 每5秒执行一次设备发现和获取可信设备列表
    this.findingInterval = setInterval(()=>{
      this.startDeviceDiscovery();
      this.getTrustedDeviceList();
    }, 1000);
  }

  // 结束扫描
  // 清除设备发现和扫描的定时器
  stopScan(){
    if(this.onFoundInterval){
      // 清除设备发现的定时器
      clearInterval(this.onFoundInterval);
      this.onFoundInterval = null;
    }
    if(this.findingInterval){
      // 清除扫描的定时器
      clearInterval(this.findingInterval);
      this.findingInterval = null;
    }
  }

  // 开始发现周边设备
  // 配置设备发现参数，启动设备发现过程
  startDeviceDiscovery(){ 
    // 生成发现标识，确保每次调用发现接口的标识不一致
    this.getSubscribeId();
    // 模拟subscribeInfo，配置设备发现参数
    interface SubscribeInfo {
      subscribeId: number;
      mode: number;
      medium: number;
      freq: number;
      isSameAccount: boolean;
      isWakeRemote: boolean;
      capability: number;
    }
    let subscribeInfo: SubscribeInfo = {
      subscribeId: this.subscribeId,
      mode: 1, // 主动模式
      medium: 1,  // 自动发现类型，同时支持多种发现类型
      freq: 2,    // 高频率
      isSameAccount: false,
      isWakeRemote: true,
      capability: 1
    };
    try {
      if (this.deviceManager) {
        // 模拟开始设备发现
        logger.debug('startDeviceDiscovery success');
        // 4秒后停止设备发现
        setTimeout(()=>{
          this.stopDeviceDiscovery();
        }, 4000);
      }
    } catch (err) {
      logger.debug('startDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  // 停止发现周边设备
  stopDeviceDiscovery(){ 
    try {
      if (this.deviceManager) {
        // 模拟停止设备发现
        logger.debug('stopDeviceDiscovery success');
      }
    } catch (err) {
      logger.debug('stopDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  // 获取可信设备列表
  // 模拟获取可信设备信息，并更新设备列表
  getTrustedDeviceList(){ 
    try {
      if (this.deviceManager) {
        // 模拟获取可信设备列表
        setTimeout(() => {
          const mockData: DeviceInfo[] = [
            {
              deviceId: 'trusted-device-id-1',
              deviceName: 'Trusted Device 1',
              deviceType: DeviceType.TV,
              networkId: 'trusted-network-id-1',
              range: 5
            }
          ];
          if(mockData && mockData.length > 0) {
            let time = new Date().getTime();
            mockData.forEach((d) => {
              if (d && d.deviceId) {
                let trustDeviceId = d.deviceId;
                let deviceId = trustDeviceId;
                let existingTrustDevice = this.trustDeviceMap.get(trustDeviceId);
                if(existingTrustDevice){
                  // 可信设备已存在，更新设备信息
                  deviceId = existingTrustDevice.deviceId;
                  existingTrustDevice.networkId = d.networkId;
                  this.trustDeviceMap.set(trustDeviceId, existingTrustDevice);
                  this.updateDeviceProp(deviceId, 'networkId', d.networkId);
                  this.updateDeviceProp(deviceId, 'updateTime', time);
                } else {
                  // 新的可信设备，检查是否正在认证
                  let isInAuth = false;
                  let isInAuthId = '';
                  let isInAuthName = '';
                  let isInAuthType:DeviceType = DeviceType.UNKNOWN_TYPE;
                  for(let i=0;i<this.deviceIdList.length;i++){
                    let id = this.deviceIdList[i];
                    let device = this.deviceMap.get(id);
                    if(device && device.isInAuth){
                      isInAuth = true;
                      isInAuthId = id;
                      isInAuthName = device.deviceName;
                      isInAuthType = device.deviceType;
                    }
                  }

                  // 创建设备信息对象
                  let trustDevice:DistributedManagerDeviceInfo = {
                    deviceId: deviceId,
                    deviceName: d.deviceName,
                    deviceType: d.deviceType,
                    networkId: d.networkId,
                    range: d.range,
                    isInAuth: false,
                    isTrust: true,
                    trustDeviceId: trustDeviceId,
                    transferLoading: false,
                    isInTransfer: false,
                    deviceState: 3, // 使用数字值替代deviceStateObj['3']
                    action: DeviceStateChangeAction.READY,
                    updateTime: time,
                    pinToken: -1,
                    isDelete: false,
                  };
                  if(isInAuthId && isInAuth && isInAuthName==d.deviceName && isInAuthType==d.deviceType){
                    // 设备正在认证中，更新现有设备的信息
                    trustDevice.deviceId = isInAuthId;
                    this.updateDeviceProp(isInAuthId, 'trustDeviceId', trustDeviceId);
                    this.updateDeviceProp(isInAuthId, 'isInAuth', false);
                    this.updateDeviceProp(isInAuthId, 'isTrust', true);
                  } else {
                    // 添加新的可信设备
                    this.addDevice(trustDeviceId,trustDevice);
                  }
                  // 添加到可信设备映射
                  this.addTrustDevice(trustDeviceId,trustDevice);
                }
              }
            });
          }
          // 更新设备列表
          this.updateDeviceIdList();
        }, 100);
      }
    } catch (err) {
      logger.debug('getTrustedDeviceList errCode:' + err.code + ',errMessage:' + err.message);
    }
  }
  // 发布设备
  publishDeviceDiscovery(){ 
    this.getPublishId();
    // 模拟publishInfo
    interface PublishInfo {
      publishId: number;
      mode: number;
      freq: number;
      ranging: boolean;
    }
    let publishInfo: PublishInfo = {
      'publishId': this.publishId,
      'mode': 0x55, // 主动模式
      'freq': 2,    // 高频率
      'ranging': true  // 支持发现时测距
    };
    try {
      if (this.deviceManager) {
        // 模拟发布设备
        logger.debug('publishDeviceDiscovery success');
      }
    } catch (err) {
      logger.debug('publishDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }

  unPublishDeviceDiscovery(){ 
    try {
      if (this.deviceManager) {
        // 模拟取消发布设备
        logger.debug('unPublishDeviceDiscovery success');
      }
    } catch (err) {
      logger.debug('unPublishDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }
  // 认证设备
  // 模拟设备认证过程，设置认证状态并更新设备信息
  authenticateDevice(deviceInfo: DistributedManagerDeviceInfo,
    authParam: AuthParam) {
    // 认证的设备信息，可以从发现的结果中获取
    let deviceId = deviceInfo.deviceId;
    let device = this.deviceMap.get(deviceId);
    if (device) {
      // 设置设备为认证中状态
      device.isInAuth = true;
      //        update
      try {
        if (this.deviceManager) {
          // 模拟设备认证
          setTimeout(() => {
            if (device) {
              // 认证完成，设置认证状态为false
              device.isInAuth = false;
              // 模拟AppStorage.get("inputToken")
              device.pinToken = 123456;
              device.updateTime = new Date().getTime() - 100 * 100 * 1;

              // 获取可信设备列表，更新设备状态
              this.getTrustedDeviceList();

              // 更新设备列表
              this.updateDeviceIdList();
            }
          }, 100);
        }
      } catch (err) {
        // 认证失败，设置认证状态为false
        device.isInAuth = false;
        logger.debug('authenticateDevice try catch errCode:' + err.code + ',errMessage:' + err.message);
      }
    }
  }
  // 解除认证的设备
  // 模拟解除设备认证过程，更新设备状态
  unAuthenticateDevice(deviceInfo:DistributedManagerDeviceInfo) { 
    let deviceId = deviceInfo.deviceId;
    let device = this.deviceMap.get(deviceId);
    if (device) {
      device.isInAuth = true;
      try {
        if (this.deviceManager) {
          // 模拟解除设备认证
          logger.debug('unAuthenticateDevice success');
          let trustDeviceId = device.trustDeviceId;
          if(trustDeviceId) {
            // 从可信设备映射中删除
            this.trustDeviceMap.delete(trustDeviceId);
          }
          if(deviceId == trustDeviceId){
            // 设备ID和可信设备ID相同，从设备映射中删除
            this.deviceMap.delete(deviceId);
          } else {
            // 设备ID和可信设备ID不同，更新设备状态
            device.isInAuth = false;
            device.networkId = '';
            device.isTrust = false;
            device.trustDeviceId = '';
            device.isInTransfer = false;
            device.action = DeviceStateChangeAction.READY;
            device.updateTime = new Date().getTime();
            device.pinToken = -1;
            device.isDelete = false;
          }
        }
      } catch (err) {
        logger.debug('authenticateDevice try catch errCode:' + err.code + ',errMessage:' + err.message);
      }
    }
  }

  // 添加设备到设备列表
  // 如果设备ID不在列表中，添加到列表，然后更新设备映射
  addDevice(deviceId:string, data:DistributedManagerDeviceInfo){
    if(!this.deviceIdList.includes(deviceId)){
      this.deviceIdList.push(deviceId);
    }
    this.deviceMap.set(deviceId, data);
  }

  // 添加可信设备到可信设备列表
  // 如果可信设备ID不在列表中，添加到列表，然后更新可信设备映射
  addTrustDevice(deviceId:string, data:DistributedManagerDeviceInfo){
    if(!this.trustIdList.includes(deviceId)){
      this.trustIdList.push(deviceId);
    }
    this.trustDeviceMap.set(deviceId, data);
  }
  // 更新设备列表
  // 过滤出60秒内更新的设备，并触发设备列表变化回调
  updateDeviceIdList(){ 
    let deviceList: DistributedManagerDeviceInfo[] = [];
    let time = new Date().getTime();
    let sp = 100 * 60 * 1; // 60秒
    this.deviceIdList.forEach((id)=>{
      let device = this.deviceMap.get(id);
      if(device && device.updateTime){ 
        let overTime = time - device.updateTime;
        if(overTime < sp) { 
          // 60秒内更新的设备才会显示
          deviceList.push(device);
        }
      }
    });
    this.deviceList = deviceList;
    // 触发设备列表变化回调
    if('function' == objType(this.deviceListChange)){
      this.deviceListChange(deviceList);
    }
  }

  // 更新设备属性
  // 根据属性名更新设备的对应属性值，并同步更新可信设备的属性
  updateDeviceProp(deviceId: string, key: string, value: boolean | string | number | DeviceStateChangeAction): void {
    let device = this.deviceMap.get(deviceId);
    if(device){
      // 直接设置属性，避免使用索引访问
      switch(key) {
        case 'transferLoading':
          device.transferLoading = value as boolean;
          break;
        case 'isInTransfer':
          device.isInTransfer = value as boolean;
          break;
        case 'isDelete':
          device.isDelete = value as boolean;
          break;
        case 'isInAuth':
          device.isInAuth = value as boolean;
          break;
        case 'networkId':
          device.networkId = value as string;
          break;
        case 'isTrust':
          device.isTrust = value as boolean;
          break;
        case 'trustDeviceId':
          device.trustDeviceId = value as string;
          break;
        case 'action':
          device.action = value as DeviceStateChangeAction;
          break;
        case 'updateTime':
          device.updateTime = value as number;
          break;
        case 'pinToken':
          device.pinToken = value as number;
          break;
      }
      // 同步更新可信设备的属性
      let trustDeviceId = device.trustDeviceId;
      if(trustDeviceId) {
        let trustDevice = this.trustDeviceMap.get(trustDeviceId);
        if(trustDevice) {
          switch(key) {
            case 'transferLoading':
              trustDevice.transferLoading = value as boolean;
              break;
            case 'isInTransfer':
              trustDevice.isInTransfer = value as boolean;
              break;
            case 'isDelete':
              trustDevice.isDelete = value as boolean;
              break;
            case 'isInAuth':
              trustDevice.isInAuth = value as boolean;
              break;
            case 'networkId':
              trustDevice.networkId = value as string;
              break;
            case 'isTrust':
              trustDevice.isTrust = value as boolean;
              break;
            case 'trustDeviceId':
              trustDevice.trustDeviceId = value as string;
              break;
            case 'action':
              trustDevice.action = value as DeviceStateChangeAction;
              break;
            case 'updateTime':
              trustDevice.updateTime = value as number;
              break;
            case 'pinToken':
              trustDevice.pinToken = value as number;
              break;
          }
        }
      }
    }
  }

  // 删除设备
  // 将设备标记为已删除，而非从列表中移除
  deleteDeviceId(deviceId:string, newId?:string): void {
    let ind = this.deviceIdList.indexOf(deviceId);
    if(ind > -1){
      let device = this.deviceMap.get(deviceId);
      if(device){
        // 标记设备为已删除
        device.isDelete = true;
      }
    }
  }

  // 绑定设备列表变化回调函数
  onDeviceListChange(callback:(data: DistributedManagerDeviceInfo[]) => void ){
    if('function' == objType(callback)){
      this.deviceListChange = callback;
    }
  }

  // 释放设备管理器
  release(){ 
    try {
      this.stopScan();
      this.offAllEvents();
      if (this.deviceManager) {
        // 模拟释放设备管理器
        logger.debug('release device manager success');
      }
    } catch (err) {
      console.error('release try catch errCode:' + err.code + ',errMessage:' + err.message);
    }
  }
}
