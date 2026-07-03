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
import { InfAccessManagerBluetooth, InfDevice, Logger } from '@ohos/common';
import Point from '../../../../viewmodel/Point';

import { ControllerItem } from '../entity/ControllerItem';
import { PayloadDevInfo } from '../model/payload/PayloadDevInfo';
import { ControllerDevReq, DevControlInformation } from '../model/req/ControllerDevReq';
import OpenValleyDevicesConnector from '../OpenValleyDevicesConnector';
import OpenValleyDevicesController from '../OpenValleyDevicesController';
import OpenValleyDevice from '../OpenValleyDevice';
import { GlobalStore } from '../util/GlobalStore';
import TunnelSceneModel, {
  getControlInformation,
  getTunnelDeviceName,
  getTunnelDeviceTypeByType,
  isSensing,
  TunnelDevice,
  TunnelDeviceType,
  TunnelSlot
} from './model/TunnelSceneModel';
import WaterDetectorSKH from './model/waterDetector';
import TunnelPointModel from './model/TunnelPointModel';

/**
 * 发现该设备后，直接连接
 */
const TEST_DEVICE_NAME = 'ccBle-E3D23A';
const TAG = 'TunnelScanManager';

export default class TunnelScanManager {
  private constructor() {
    this.pointModel = TunnelPointModel.getInstance();
    this.pointModel.init();
  }

  private static instance: TunnelScanManager;

  public static getInstance(): TunnelScanManager {
    if (TunnelScanManager.instance == null) {
      TunnelScanManager.instance = new TunnelScanManager();
    }
    return TunnelScanManager.instance;
  }

  public controller: OpenValleyDevicesController = new OpenValleyDevicesController();
  public bleManager: InfAccessManagerBluetooth = new InfAccessManagerBluetooth();
  public connectingDevice: InfDevice | undefined;
  public model: TunnelSceneModel | undefined;
  public pointModel: TunnelPointModel;
  //场景是否设置
  public isSceneSet: boolean = false;
  //浸水传感器
  public waterDetector: WaterDetectorSKH = new WaterDetectorSKH();
  //是否初始化浸水器
  public hasInitWaterDetector: boolean = false;
  //浸水器状态
  public waterDetectorState: boolean = false;
  //当前执行状态
  public currentInvokeState: boolean = false;

  getModel(): TunnelSceneModel {
    if (!this.model) {
      this.model = new TunnelSceneModel();
    }
    return this.model;
  }

  getSceneSetState(): boolean {
    return this.isSceneSet;
  }

  setSceneSetState(b: boolean) {
    this.isSceneSet = b;
    if (this.model) {
      this.model.isSetFinish = b;
    }
  }

  release() {
    this.controller.discover.stopScan();
    if (this.connectingDevice) {
      this.controller.connector.stopConnect(this.connectingDevice);
      this.connectingDevice = undefined;
    }
    this.model?.reset();
    this.pointModel.init();
  }

  /**
   * 开始扫描，发现控制器和子设备
   */
  async startScan(context: Context) {
    this.initWaterDetector();
    if (await this.bleManager.isEnable()) {
      this.scanAction();
    } else {
      const result = await this.bleManager.applyAccess(context);
      if (result) {
        this.scanAction();
      }
    }
  }

  async initWaterDetector() {
    if (!this.hasInitWaterDetector) {
      const result: boolean = await this.waterDetector.startConnect();
      if (result) {
        this.hasInitWaterDetector = true;
        Logger.debug(TAG, '浸水传感器可用');
        this.addWaterDetectorDevice();
        const state: boolean = await this.waterDetector.queryState();
        Logger.debug(TAG, '当前浸水器状态：' + state);
        this.waterDetectorState = state;
        this.onWaterDetectorStateChange(state);
        this.waterDetector.registerStateChange((state: boolean) => {
          Logger.debug(TAG, '浸水器状态改变：' + state);
          this.onWaterDetectorStateChange(state);
        });
      } else {
        Logger.debug(TAG, '浸水传感器当前不可用');
      }
    }
  }

  addWaterDetectorDevice() {
    const device: TunnelDevice | null = this.generateDevice(TunnelDeviceType.Sensing);
    if (device) {
      this.model?.addDevice(device);
    }
  }

  /**
   * 当浸水器状态变化,state:是否浸水
   */
  onWaterDetectorStateChange(state: boolean, isFirstSet: boolean = false) {
    this.waterDetectorState = state;
    Logger.debug(TAG, `onWaterDetectorStateChange() ${!this.isSceneSet}`);
    if (!this.isSceneSet) {
      return;
    }
    this.invokeAction(state, isFirstSet);
  }

  scanAction() {
    this.controller.discover.startScan(null, (device: InfDevice) => {
      const openValleyDevice: OpenValleyDevice = device as OpenValleyDevice;
      //发现指定控制器，就停止扫描
      if (openValleyDevice.getDeviceName() == TEST_DEVICE_NAME && !this.connectingDevice) {
        Logger.debug(TAG, '发现指定控制器，准备连接');
        this.connectingDevice = device;
        this.controller.discover.stopScan();
        this.startConnect(device);
      }
    });
  }

  stopScan() {
    this.controller.discover.stopScan();
  }

  async startConnect(device: InfDevice) {
    const result = await this.controller.connector.connect(device);
    if (result) {
      Logger.debug(TAG, '设备连接成功');
      const connector: OpenValleyDevicesConnector = this.controller.connector as OpenValleyDevicesConnector;
      connector.registerDevFindCallback((device) => {
        this.onDevFind(device);
      });
      connector.pre(device);
    }
  }

  onDevFind(devInfo: PayloadDevInfo) {
    if (this.model && devInfo.type) {
      const type: TunnelDeviceType = getTunnelDeviceTypeByType(devInfo.type);
      const device: TunnelDevice | null = this.generateDevice(type, devInfo.sn!);
      if (device != null) {
        this.model.addDevice(device);
      }
    }
  }


  /**
   * 生成一个device
   * @param type
   * @param sn
   */
  generateDevice(type: TunnelDeviceType, sn?: string): TunnelDevice | null {
    let device: TunnelDevice | null = null;
    if (this.model) {
      const isSensingB: boolean = isSensing(type);
      let point: Point | null = this.pointModel.getTopOrBottomPoint(isSensingB);
      if (isSensingB && point) {
        device = new TunnelDevice('TunnelDeviceType.Sensing', getTunnelDeviceName(type), type, point!,
          ['TunnelDeviceType.Sensing']);
      } else if (sn && point) {
        device = new TunnelDevice(sn, getTunnelDeviceName(type), type, point, [sn]);
      }
    }
    return device;
  }

  getAllControllerDevice(): Array<TunnelDevice> {
    const arr: TunnelDevice[] = [];
    if (this.model) {
      const controllers: TunnelSlot[] = this.model.controlDeviceSlots;
      for (let i = 0; i < controllers.length; i++) {
        const slot: TunnelSlot = controllers[i];
        if (slot.device) {
          arr.push(slot.device);
        }
      }
    }
    return arr;
  }

  /**
   * 执行或者停止场景
   */
  invokeOrStopScene(isSet: boolean) {
    this.setSceneSetState(isSet);
    if (isSet) {
      this.onWaterDetectorStateChange(this.waterDetectorState, true);
      //停止场景时，关闭子设备
    } else if (!isSet) {
      this.invokeAction(false);
    }
  }

  invokeAction(onOrOff: boolean, isFirstSet: boolean = false) {
    if (this.currentInvokeState != onOrOff || isFirstSet) {
      Logger.debug(TAG, '在鸿控制器执行动作：' + onOrOff);
      const arr: TunnelDevice[] = this.getAllControllerDevice();
      this.execute(arr, onOrOff);
      this.currentInvokeState = onOrOff;
    }
  }

  /**
   * 打开所有设备
   */
  execute(arr: Array<TunnelDevice>, onOrOff: boolean) {
    if (!arr || arr.length == 0) {
      return;
    }
    const id: string | null = this.getLocalId();
    if (id) {
      const devArray: DevControlInformation[] = [];
      for (let i = 0; i < arr.length; i++) {
        const tunnelDevice: TunnelDevice = arr[i];
        for (let j = 0; j < tunnelDevice.snList.length; j++) {
          const information: DevControlInformation =
            new DevControlInformation(tunnelDevice.snList[j], getControlInformation(onOrOff, tunnelDevice.type));
          devArray.push(information);
        }
      }
      const connector: OpenValleyDevicesConnector = this.controller.connector as OpenValleyDevicesConnector;
      const req: ControllerDevReq = new ControllerDevReq(id, id, devArray);
      connector.invokeMsg(JSON.stringify(req));
    }
  }

  getLocalId(): string | null {
    const item: ControllerItem | null = GlobalStore.getInstance().getLocalControllerItem();
    if (item) {
      return item.id;
    }
    return null;
  }
};