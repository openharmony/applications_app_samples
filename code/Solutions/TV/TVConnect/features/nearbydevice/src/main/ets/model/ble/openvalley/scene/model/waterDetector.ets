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

import { Callback } from '@ohos.base';
import { InfDeviceState, Logger } from '@ohos/common';
import { CoapServerManager } from '@ohos/connect_wifi/Index';
import BusinessManager from '../../../../../viewmodel/BusinessManager';
import InfWaterDetectorDevice from './InfWaterDetectorDevice';

/**
 * 湿度传感器
 */
export default class WaterDetectorSKH {
  public static WATER_DETECTOR_TAG: string = 'WATER_DETECTOR';
  public callback: Callback<boolean> | null = null;

  /**
   * 设备连接
   * @param index
   */
  async startConnect(): Promise<boolean> {
    Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG, `WaterDetectorSKH connectWaterDetector begin!`);
    const businessManager = new BusinessManager();
    try {
      const result: InfDeviceState[] =
        await businessManager.queryDeviceState(new InfWaterDetectorDevice(), ['cust.waterDetector']);
      Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG,
        `WaterDetectorSKH startConnect success! result=${JSON.stringify(result)}`);
      return true;
    } catch (err) {
      Logger.error(`WaterDetectorSKH startConnect error! ${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * 设备状态查询
   * @param index
   */
  async queryState(): Promise<boolean> {
    Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG, `WaterDetectorSKH queryState begin!`);
    const businessManager = new BusinessManager();
    try {
      const result: InfDeviceState[] =
        await businessManager.queryDeviceState(new InfWaterDetectorDevice(), ['cust.waterDetector']);
      if (result.length > 0) {
        Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG,
          `WaterDetectorSKH queryState success! result=${JSON.stringify(result)}`);
        return result[0].data['cust.waterDetector'] == 1;
      } else {
        Logger.error(`WaterDetectorSKH queryState result is empty!`);
      }
    } catch (err) {
      Logger.error(`WaterDetectorSKH queryState startConnect error! ${JSON.stringify(err)}`);
    }
    return false;
  }

  /**
   * 设备注册
   * @param index
   */
  registerStateChange(callback: Callback<boolean>): void {
    Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG, `WaterDetectorSKH registerWaterDetector begin!`);
    CoapServerManager.getInstance().startServer();
    this.queryState();
    this.callback = callback;
    CoapServerManager.getInstance()
      .registerMessageReceiver('WATER_DETECTOR', (msg: InfDeviceState[]) => this.onStateChange(msg));
  }

  /**
   * 规避coap可能接受不到的情况，这个会3秒触发一次
   * @param msg
   * @returns
   */
  async onStateChange(msg: InfDeviceState[]): Promise<boolean> {
    Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG, `WaterDetectorSKH onStateChange begin!`);
    if (msg[0].sid == 'cust.waterDetector') {
      if (this.callback) {
        let state: boolean = false;
        if (msg[0].data['cust.waterDetector'] == 1) {
          state = true;
        }
        this.callback(state);
        return true;
      }
    }
    return false;
  }

  /**
   * 设备断连接
   * @param index
   */
  async stopConnect(): Promise<boolean> {
    Logger.debug(WaterDetectorSKH.WATER_DETECTOR_TAG, `WaterDetectorSKH stopConnect begin!`);
    CoapServerManager.getInstance().unRegisterMessageReceiver('WATER_DETECTOR');
    CoapServerManager.getInstance().stopServer();
    return true;
  }
};