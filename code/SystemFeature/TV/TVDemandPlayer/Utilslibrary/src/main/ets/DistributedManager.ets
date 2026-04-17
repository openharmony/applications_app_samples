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
import { deviceManager } from '@kit.DistributedServiceKit';
import { initInfo, initDebug } from './log';
import { objType } from './Utils'

const TAG = 'devicemanagerkit_js-ets'
let log = initDebug(TAG);
let debugLog = initDebug(TAG);

//let defDeviceList = [
//    {
//        deviceId: 'fgdhskjafkjds',
//        deviceName: '测试设备1',
//        deviceType: 0,
//        networkId: '123',
//        range: 1,
//        deviceState: 1,
//        isInAuth: false, // 是否正在可信认证
//        isTrust: false, // 是否可信
//        trustDeviceId: 'fgdhskjafkjds', // 可信设备id
//        transferLoading: false, // 是否流转中
//        isInTransfer: false, // 是否流转中
//        action: 2, // 可信设备状态 0在线， 1：设备已OK 2:设备已离线
//        updateTime: 123, // 最后一次更新时间
//        pinToken: 1,
//        isDelete: false
//    },
//    {
//        deviceId: 'fgdhskjafkjds111',
//        deviceName: '测试设备2',
//        deviceType: 0,
//        networkId: '123',
//        range: 1,
//        deviceState: 1,
//        isInAuth: false, // 是否正在可信认证
//        isTrust: false, // 是否可信
//        trustDeviceId: 'fgdhskjafkjds111', // 可信设备id
//        transferLoading: false, // 是否流转中
//        isInTransfer: false, // 是否流转中
//        action: 2, // 可信设备状态 0在线， 1：设备已OK 2:设备已离线
//        updateTime: 123, // 最后一次更新时间
//        pinToken: 1,
//        isDelete: false
//    },
//    {
//        deviceId: 'fgdhskjafkjds222',
//        deviceName: '测试设备3',
//        deviceType: 0,
//        networkId: '123',
//        range: 1,
//        deviceState: 1,
//        isInAuth: false, // 是否正在可信认证
//        isTrust: false, // 是否可信
//        trustDeviceId: 'fgdhskjafkjds222', // 可信设备id
//        transferLoading: false, // 是否流转中
//        isInTransfer: false, // 是否流转中
//        action: 2, // 可信设备状态 0在线， 1：设备已OK 2:设备已离线
//        updateTime: 123, // 最后一次更新时间
//        pinToken: 1,
//        isDelete: false
//    },
//    {
//        deviceId: 'fgdhskjafkjds333',
//        deviceName: '测试设备4',
//        deviceType: 0,
//        networkId: '123',
//        range: 1,
//        deviceState: 1,
//        isInAuth: false, // 是否正在可信认证
//        isTrust: false, // 是否可信
//        trustDeviceId: 'fgdhskjafkjds333', // 可信设备id
//        transferLoading: false, // 是否流转中
//        isInTransfer: false, // 是否流转中
//        action: 2, // 可信设备状态 0在线， 1：设备已OK 2:设备已离线
//        updateTime: 123, // 最后一次更新时间
//        pinToken: 1,
//        isDelete: false
//    }
//]


class DeviceStateFactory {
    static stateReady(): DeviceStateInfo {
        return { loading: false, msg: '点击进行设备互信' };
    }

    static stateAuthing(): DeviceStateInfo {
        return { loading: true, msg: '设备互信中...' };
    }

    static stateOnlineTransfer(): DeviceStateInfo {
        return { loading: false, msg: '在线，点击进行视频流转' };
    }

    static stateOffline(): DeviceStateInfo {
        return { loading: false, msg: '离线，等待对端设备上线' };
    }

    static stateStartingTransfer(): DeviceStateInfo {
        return { loading: true, msg: '启动视频流转中...' };
    }

    static stateTransfering(): DeviceStateInfo {
        return { loading: false, msg: '视频流转中，点击停止' };
    }

    static stateStoppingTransfer(): DeviceStateInfo {
        return { loading: false, msg: '停止视频流转中...' };
    }
}

const BUNDLE_NAME = 'com.ohos.demandplayer';

export interface DeviceInfo {
    deviceId: string;
    deviceName: string;
    deviceType: DeviceType;
    networkId: string;
    range: number;
}

class DeviceInfoModel implements DeviceInfo {
    public deviceId: string = '';
    public deviceName: string = '';
    public deviceType: DeviceType = DeviceType.UNKNOWN_TYPE;
    public networkId: string = '';
    public range: number = 0;
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
    deviceState?: DeviceStateInfo;
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

interface DeviceStateInfo {
    loading: boolean;
    msg: string;
}

class AuthExtraInfo {
}

export class AuthParam {
    public authType: number = 1;
    public extraInfo: Object = new AuthExtraInfo();
}

export class DistributedManager {
    private static instance: DistributedManager | null; // 单例对象

    private deviceManager: deviceManager.DeviceManager | null = null;
    private subscribeId: number;
    private publishId: number;

    private findingChange: Object | null;
    public deviceList: DistributedManagerDeviceInfo[] | null; // 设备列表
    private deviceListChange: (data: DistributedManagerDeviceInfo[]) => void =
        (_data: DistributedManagerDeviceInfo[]): void => {};

    private trustIdList: string[]; // 可信设备ID列表
    private trustDeviceMap: Map<string, DistributedManagerDeviceInfo>; // 设备对象列表

    private deviceIdList: string[]; // 设备ID列表
    private deviceMap: Map<string, DistributedManagerDeviceInfo>; // 设备对象列表

    public localDeviceInfo:DeviceInfo | null;

    private findingInterval: number | null;
    private findingTrustInterval: number | null;

    private onFoundInterval: number | null;


    private constructor(){
        this.subscribeId = this.getSubscribeId();
        this.publishId = this.getPublishId();
        this.findingChange = null;
        this.localDeviceInfo = null;
        this.deviceList = [];
        this.findingInterval = null;
        this.findingTrustInterval = null;
        this.onFoundInterval = null;

        this.trustIdList = [];
        this.trustDeviceMap = new Map<string, DistributedManagerDeviceInfo>();

        this.deviceIdList = [];
        this.deviceMap = new Map<string, DistributedManagerDeviceInfo>();


        this.createDeviceManager()
    }
    static getInstance(): DistributedManager {
        if (DistributedManager.instance == null) {
            DistributedManager.instance = new DistributedManager();
        }
        return DistributedManager.instance;
    }


    getSubscribeId(){







        return 16251;
    }


    getPublishId(){







        return 16252;
    }

    // 创建设备管理器
    createDeviceManager(){
        log(`createDeviceManager IN`);
        try {
            deviceManager.createDeviceManager(BUNDLE_NAME, (err, data) => {
                if (err) {
                    debugLog('createDeviceManager error! errCode:' + err.code + ',errMessage:' + err.message + ',errData:' + JSON.stringify(err.data));
                    return;
                }
                this.deviceManager = data;

                this.getLocalDeviceInfo();
                this.stopDeviceDiscovery();
                this.unPublishDeviceDiscovery();
                this.onServiceDie();
                this.onDeviceFound();
                this.onDiscoverFail();
                this.onDeviceStateChange();
                this.getTrustedDeviceList();

            });
        } catch(err) {
            debugLog('createDeviceManager try catch! errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    // 获取本地设备信息
    getLocalDeviceInfo(){
        log(`getLocalDeviceInfo IN`);
        try {
            this.deviceManager?.getLocalDeviceInfo((err, data) => {
                if (err) {
                    debugLog('getLocalDeviceInfo error! errCode:' + err.code + ',errMessage:' + err.message + ',errData:' + JSON.stringify(err.data));
                    return;
                }
                log('getLocalDeviceInfo: ' + JSON.stringify(data));
                if(data && data.deviceId){
                    let localDevice = new DeviceInfoModel();
                    localDevice.deviceId = data.deviceId;
                    localDevice.deviceName = data.deviceName;
                    localDevice.deviceType = data.deviceType;
                    localDevice.networkId = data.networkId;
                    localDevice.range = data.range;
                    this.localDeviceInfo = localDevice;
                }
            })
        } catch (err) {
            debugLog('getLocalDeviceInfo try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }


    onDeviceFound(){


        try {
            this.deviceManager?.on('deviceFound', (data) => {
                log('onDeviceFound callback:' + JSON.stringify(data));
                if(data && data.device && data.device.deviceId){
                    let updateTime = new Date().getTime()
                    if (!this.deviceMap.has(data.device.deviceId)) {
                        let device:DistributedManagerDeviceInfo = {
                            deviceId: data.device.deviceId,
                            deviceName: data.device.deviceName,
                            deviceType: data.device.deviceType,
                            networkId: data.device.networkId,
                            range: data.device.range,
                            isInAuth: false,
                            isTrust: false,
                            trustDeviceId: '',
                            transferLoading: false,
                            isInTransfer: false,
                            deviceState: DeviceStateFactory.stateReady(),
                            action: DeviceStateChangeAction.READY,
                            updateTime: updateTime,
                            pinToken: -1,
                            isDelete: false,
                        };
                        this.addDevice(data.device.deviceId, device);
                    } else {
                        this.updateDeviceProp(data.device.deviceId, 'updateTime', updateTime);
                    }
                    if(this.onFoundInterval){
                        clearInterval(this.onFoundInterval)
                    }
                    this.onFoundInterval = setTimeout(()=>{
                        this.updateDeviceIdList();
                    }, 200)
                }
            });

        } catch (err) {
            debugLog('onDeviceFound try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    offDeviceFound(){

        try {
            this.deviceManager?.off('deviceFound');

        } catch (err) {
            debugLog('offDeviceFound try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    // 注册设备发现失败回调监听。
    onDiscoverFail() {

        try {
            this.deviceManager?.on('discoverFail', (data) => {
                log('onDiscoverFail callback:' + JSON.stringify(data));
            });

        } catch (err) {
            debugLog('onDiscoverFail try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    offDiscoverFail() {

        try {
            this.deviceManager?.off('discoverFail');

        } catch (err) {
            debugLog('offDiscoverFail try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    onPublishSuccess(){

        try {
            this.deviceManager?.on('publishSuccess', (data) => {
                log('onPublishSuccess callback:' + JSON.stringify(data));
            });

        } catch (err) {
            debugLog('onPublishSuccess try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    offPublishSuccess(){

        try {
            this.deviceManager?.off('publishSuccess');

        } catch (err) {
            debugLog('offPublishSuccess errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    onPublishFail(){

        try {
            this.deviceManager?.on('publishFail', (data) => {
                log('onPublishFail callback:' + JSON.stringify(data));
            });

        } catch (err) {
            debugLog('publishFail try catch errCode:' + err.code + ',errMessage:' + err.message);
        }

    }

    offPublishFail(){

        try {
            this.deviceManager?.off('publishFail');

        } catch (err) {
            debugLog('offPublishFail try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    onServiceDie(){

        try {
            this.deviceManager?.on('serviceDie', () => {
                log('serviceDie callback');
            });

        } catch (err) {
            debugLog('serviceDie try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    offServiceDie(){

        try {
            this.deviceManager?.off('serviceDie');

        } catch (err) {
            debugLog('offServiceDie errCode:' + err.code + ',errMessage:' + err.message);
        }
    }


    onDeviceStateChange(){

        try {
            this.deviceManager?.on('deviceStateChange', (data) => {

                if(data){
                    let trustDeviceId = data.device.deviceId;
                    let deviceId = trustDeviceId;
                    let action = data.action;
                    let time = new Date().getTime();

                    if (this.trustDeviceMap.has(trustDeviceId)) {
                        let trustDeviceInfo = this.trustDeviceMap.get(trustDeviceId);
                        if (trustDeviceInfo) {
                            deviceId = trustDeviceInfo.deviceId;
                        }
                        this.updateDeviceProp(deviceId, 'action', action);
                        this.updateDeviceProp(deviceId, 'updateTime', time);
                    } else {
                        let isInAuth = false;
                        let isInAuthId = '';
                        let isInAuthName = ''
                        let isInAuthType:DeviceType = DeviceType.UNKNOWN_TYPE;
                        for(let i=0;i<this.deviceIdList.length;i++){
                            let id = this.deviceIdList[i];
                            let localDevice = this.deviceMap.get(id);
                            if (localDevice && localDevice.isInAuth) {
                                isInAuth = true;
                                isInAuthId = id;
                                isInAuthName = localDevice.deviceName;
                                isInAuthType = localDevice.deviceType;
                            }
                        }

                        let trustDevice:DistributedManagerDeviceInfo = {
                            deviceId: deviceId,
                            deviceName: data.device.deviceName,
                            deviceType: data.device.deviceType,
                            networkId: data.device.networkId,
                            range: data.device.range,
                            isInAuth: false,
                            isTrust: true,
                            trustDeviceId: trustDeviceId,
                            transferLoading: false,
                            isInTransfer: false,
                            deviceState: DeviceStateFactory.stateOnlineTransfer(),
                            action: DeviceStateChangeAction.READY,
                            updateTime: time,
                            pinToken: -1,
                            isDelete: false,
                        };
                        if (
                            isInAuthId &&
                            isInAuth &&
                            isInAuthName == data.device.deviceName &&
                            isInAuthType == data.device.deviceType
                        ) {
                            trustDevice.deviceId = isInAuthId;
                            this.updateDeviceProp(isInAuthId, 'trustDeviceId', trustDeviceId);
                            this.updateDeviceProp(isInAuthId, 'isInAuth', false);
                            this.updateDeviceProp(isInAuthId, 'isTrust', true);
                        } else {
                            this.addDevice(trustDeviceId,trustDevice);
                        }
                        this.addTrustDevice(trustDeviceId,trustDevice);
                    }
                    this.updateDeviceIdList();
                }
            });
        } catch (err) {
            debugLog('deviceStateChange try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    offDeviceStateChange(){

        try {
            this.deviceManager?.off('deviceStateChange');

        } catch (err) {
            debugLog('offDeviceStateChange errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    offAllEvents(){
        this.stopDeviceDiscovery();
        this.offDeviceFound();
        this.offDiscoverFail();
        this.offDeviceStateChange();
        this.offServiceDie();
    }


    // 开始扫描
    startScan(){
        this.stopScan();
        this.findingInterval = setInterval(()=>{
            this.startDeviceDiscovery();
            this.getTrustedDeviceList();
        }, 5000)
    }

    // 结束扫描
    stopScan(){
        if(this.onFoundInterval){
            clearInterval(this.onFoundInterval)
            this.onFoundInterval = null;
        }
        if(this.findingInterval){
            clearInterval(this.findingInterval);
            this.findingInterval = null;
        }
    }


    startDeviceDiscovery(){


        this.getSubscribeId();
        let subscribeInfo: deviceManager.SubscribeInfo = {
            'subscribeId': this.subscribeId,
            'mode': deviceManager.DiscoverMode.DISCOVER_MODE_ACTIVE, // 主动模式
            'medium': deviceManager.ExchangeMedium.COAP,  // 自动发现类型，同时支持多种发现类型
            'freq': deviceManager.ExchangeFreq.HIGH,    // 高频率
            'isSameAccount': false,
            'isWakeRemote': true,
            'capability': 1
        };
        try {
            this.deviceManager?.startDeviceDiscovery(subscribeInfo);

            setTimeout(()=>{
                this.stopDeviceDiscovery();
            }, 4000)
        } catch (err) {
            debugLog('startDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    stopDeviceDiscovery(){

        try {

            this.deviceManager?.stopDeviceDiscovery(this.subscribeId);

        } catch (err) {
            debugLog('stopDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    getTrustedDeviceList(){
        try {
            this.deviceManager?.getTrustedDeviceList((err, data) => {
                if (err) {
                    debugLog('getTrustedDeviceList errCode:' + err.code + ',errMessage:' + err.message);
                    return;
                }
                if(data && data.length > 0) {
                    let time = new Date().getTime();
                    data.forEach((d) => {
                        if (d && d.deviceId) {
                            let trustDeviceId = d.deviceId;
                            let deviceId = trustDeviceId;
                            if (this.trustDeviceMap.has(trustDeviceId)) {
                                let trustDeviceData = this.trustDeviceMap.get(trustDeviceId);
                                if (trustDeviceData) {
                                    deviceId = trustDeviceData.deviceId;
                                    trustDeviceData.networkId = d.networkId;
                                }
                                this.updateDeviceProp(deviceId, 'networkId', d.networkId);
                                this.updateDeviceProp(deviceId, 'updateTime', time);
                            } else {
                                let isInAuth = false;
                                let isInAuthId = '';
                                let isInAuthName = '';
                                let isInAuthType:DeviceType = DeviceType.UNKNOWN_TYPE;
                                for(let i=0;i<this.deviceIdList.length;i++){
                                    let id = this.deviceIdList[i];
                                    let localDevice = this.deviceMap.get(id);
                                    if (localDevice && localDevice.isInAuth) {
                                        isInAuth = true;
                                        isInAuthId = id;
                                        isInAuthName = localDevice.deviceName;
                                        isInAuthType = localDevice.deviceType;
                                    }
                                }

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
                                    deviceState: DeviceStateFactory.stateOnlineTransfer(),
                                    action: DeviceStateChangeAction.READY,
                                    updateTime: time,
                                    pinToken: -1,
                                    isDelete: false,
                                };
                                if(isInAuthId && isInAuth && isInAuthName==d.deviceName && isInAuthType==d.deviceType){
                                    trustDevice.deviceId = isInAuthId;
                                    this.updateDeviceProp(isInAuthId, 'trustDeviceId', trustDeviceId);
                                    this.updateDeviceProp(isInAuthId, 'isInAuth', false);
                                    this.updateDeviceProp(isInAuthId, 'isTrust', true);
                                } else {
                                    this.addDevice(trustDeviceId,trustDevice);
                                }
                                this.addTrustDevice(trustDeviceId,trustDevice);
                            }
                        }
                    });
                }
                this.updateDeviceIdList();
            });
        } catch (err) {
            debugLog('getTrustedDeviceList errCode:' + err.code + ',errMessage:' + err.message);
        }
    }
    // 发布设备
    publishDeviceDiscovery(){
        this.getPublishId();
        let publishInfo: deviceManager.PublishInfo = {
            publishId: this.publishId,
            mode: 0x55, // 主动模式
            freq: 2, // 高频率
            ranging: true // 支持发现时测距
        };
        try {
            this.deviceManager?.publishDeviceDiscovery(publishInfo); // 当有发布结果时，通过回调通知给应用程序

        } catch (err) {
            debugLog('publishDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    unPublishDeviceDiscovery(){

        try {

            this.deviceManager?.unPublishDeviceDiscovery(this.publishId);

        } catch (err) {
            debugLog('unPublishDeviceDiscovery try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    authenticateDevice(deviceInfo: Object, authParam: AuthParam) {
        let candidate = deviceInfo as DeviceInfo;
        let deviceId = candidate.deviceId;
        let device: DistributedManagerDeviceInfo | undefined = this.deviceMap.get(deviceId);
        if (!device) {
            return;
        }
        device.isInAuth = true;
        //        update
        try {
            let authDeviceInfo: deviceManager.DeviceInfo = {
                deviceId: candidate.deviceId,
                deviceName: candidate.deviceName,
                deviceType: candidate.deviceType,
                networkId: candidate.networkId,
                range: candidate.range,
                authForm: 1
            };
            this.deviceManager?.authenticateDevice(authDeviceInfo, authParam, (_err: Object, _data: Object) => {
                let currentDevice = this.deviceMap.get(deviceId);
                if (!currentDevice) {
                    return;
                }
                currentDevice.isInAuth = false;




                currentDevice.pinToken = AppStorage.get<number>('inputToken') ?? -1;
                currentDevice.updateTime = new Date().getTime() - 1000 * 100 * 1;

                this.getTrustedDeviceList();









                this.updateDeviceIdList();

            });
        } catch (err) {
            let currentDevice = this.deviceMap.get(deviceId);
            if (currentDevice) {
                currentDevice.isInAuth = false;
            }
            debugLog('authenticateDevice try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }
    unAuthenticateDevice(deviceInfo:DistributedManagerDeviceInfo) {
        let deviceId = deviceInfo.deviceId;
        let device: DistributedManagerDeviceInfo | undefined = this.deviceMap.get(deviceId);
        if (!device) {
            return;
        }
        device.isInAuth = true;
        try {

            let trustDevice:deviceManager.DeviceInfo = {
                deviceId: device.trustDeviceId ? device.trustDeviceId : '',
                deviceName: device.deviceName,
                deviceType: device.deviceType,
                networkId: device.networkId,
                range: device.range,
                authForm:1
            }
            this.deviceManager?.unAuthenticateDevice(trustDevice);
            if (device.trustDeviceId) {
                this.trustDeviceMap.delete(device.trustDeviceId);
            }
            if(deviceId == device.trustDeviceId){
                this.deviceMap.delete(deviceId);
            } else {
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
        } catch (err) {
            debugLog('authenticateDevice try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }

    addDevice(deviceId:string, data:DistributedManagerDeviceInfo){
        if(!this.deviceIdList.includes(deviceId)){
            this.deviceIdList.push(deviceId);
        }
        this.deviceMap.set(deviceId, data);
    }

    addTrustDevice(deviceId:string, data:DistributedManagerDeviceInfo){
        if(!this.trustIdList.includes(deviceId)){
            this.trustIdList.push(deviceId);
        }
        this.trustDeviceMap.set(deviceId, data);
    }
    // 更新设备
    updateDeviceIdList(){
        let deviceList: DistributedManagerDeviceInfo[] = [];
        let time = new Date().getTime();
        let sp = 1000 * 60 * 1;
        this.deviceIdList.forEach((id,i)=>{
            let device = this.deviceMap.get(id);
            if (device && device.updateTime !== undefined) {
                let overTime = time - device.updateTime;
                if (overTime < sp) {
                    deviceList.push(device);
                }
            }
        });
        this.deviceList = deviceList;
        if('function' == objType(this.deviceListChange)){
            this.deviceListChange(deviceList)
        }
    }

    updateDeviceProp(deviceId: string, key: string, value: Object | string | number | boolean){
        let device = this.deviceMap.get(deviceId);
        if(device){
            if (key == 'action') {
                device.action = value as DeviceStateChangeAction;
            } else if (key == 'updateTime') {
                device.updateTime = value as number;
            } else if (key == 'networkId') {
                device.networkId = value as string;
            } else if (key == 'trustDeviceId') {
                device.trustDeviceId = value as string;
            } else if (key == 'isInAuth') {
                device.isInAuth = value as boolean;
            } else if (key == 'isTrust') {
                device.isTrust = value as boolean;
            } else if (key == 'transferLoading') {
                device.transferLoading = value as boolean;
            } else if (key == 'isInTransfer') {
                device.isInTransfer = value as boolean;
            }
            let trustDeviceId = device.trustDeviceId;
            if (trustDeviceId) {
                let trustDevice = this.trustDeviceMap.get(trustDeviceId);
                if (trustDevice) {
                    if (key == 'action') {
                        trustDevice.action = value as DeviceStateChangeAction;
                    } else if (key == 'updateTime') {
                        trustDevice.updateTime = value as number;
                    } else if (key == 'networkId') {
                        trustDevice.networkId = value as string;
                    } else if (key == 'trustDeviceId') {
                        trustDevice.trustDeviceId = value as string;
                    } else if (key == 'isInAuth') {
                        trustDevice.isInAuth = value as boolean;
                    } else if (key == 'isTrust') {
                        trustDevice.isTrust = value as boolean;
                    } else if (key == 'transferLoading') {
                        trustDevice.transferLoading = value as boolean;
                    } else if (key == 'isInTransfer') {
                        trustDevice.isInTransfer = value as boolean;
                    }
                }
            }
        }
    }


    deleteDeviceId(deviceId:string, newId?:string){
        let ind = this.deviceIdList.indexOf(deviceId);
        if(ind > -1){



            let device = this.deviceMap.get(deviceId);
            if (device) {
                device.isDelete = true;
            }
        }
    }

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
            this.deviceManager?.release();
        } catch (err) {
            console.error('release try catch errCode:' + err.code + ',errMessage:' + err.message);
        }
    }
}
