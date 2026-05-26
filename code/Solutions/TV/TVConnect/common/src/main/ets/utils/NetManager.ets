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
import { connection } from '@kit.NetworkKit';
import { Logger } from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';

const NET_TAG = 'NetManager';

enum NetStatus {
  NET_AVAILABLE = 'NET_AVAILABLE',
  NET_VALIDATED = 'NET_VALIDATED',
  NET_INVALID = 'NET_INVALID',
  NET_LOST = 'NET_LOST',
}

export class NetManager {
  private static instance: NetManager | undefined = undefined;
  private mNetConnection: connection.NetConnection | undefined = undefined;
  private isInit: boolean = false;
  private mCurNetStatus = NetStatus.NET_INVALID;
  private mNetObserver: Set<NetObserver> = new Set();

  public static getInstance(): NetManager {
    if (NetManager.instance == undefined) {
      NetManager.instance = new NetManager();
    }
    return NetManager.instance;
  }

  public static hasNetConnection(): boolean {
    try {
      let netHandle = connection.getDefaultNetSync();
      // 0-100 为系统预留的连接
      if (!netHandle || netHandle.netId < 100) {
        Logger.warn(NET_TAG, `netHandle is undefined or netHandle.netId < 100`);
        return false;
      }
      // 获取连接的属性
      let netCapability = connection.getNetCapabilitiesSync(netHandle);
      let cap = netCapability.networkCap;
      if (!cap) {
        Logger.warn(NET_TAG, `networkCap is undefined`);
        return false;
      }
      for (let em of cap) {
        if (connection.NetCap.NET_CAPABILITY_VALIDATED === em) {
          return true;
        }
      }
    } catch (error) {
      Logger.error(NET_TAG, `hasNetConnection error ${error?.message}`);
    }
    Logger.warn(NET_TAG, `hasNetConnection return fasle`);
    return false;
  }

  public initNetConnection() {
    if (this.isInit) {
      Logger.warn(NET_TAG, `NetManager is init`);
      return;
    }
    this.mNetConnection = connection.createNetConnection();
    this.mNetConnection.register((error: BusinessError) => {
      Logger.warn(NET_TAG, `connection register error ${error?.message}`);
    });
    this.mNetConnection.on('netAvailable', (data) => {
      Logger.info(NET_TAG, `NetManager netAvailable ${data.netId}`);
      this.mCurNetStatus = NetStatus.NET_AVAILABLE;
      this.notifyObserver();
    });
    this.mNetConnection.on('netLost', (data) => {
      Logger.warn(NET_TAG, `NetManager netLost ${data.netId}`);
      this.mCurNetStatus = NetStatus.NET_LOST;
      this.notifyObserver();
    });
    this.mNetConnection.on('netCapabilitiesChange', (data) => {
      Logger.warn(NET_TAG, `NetManager netCapabilitiesChange `);
      let networkCaps = data?.netCap.networkCap;
      let isNetConnect = networkCaps?.includes(connection.NetCap.NET_CAPABILITY_VALIDATED) || false;
      Logger.warn(NET_TAG, `NetManager netCapabilitiesChange NetConnect= ${isNetConnect}`);
      if (isNetConnect) {
        this.mCurNetStatus = NetStatus.NET_VALIDATED;
      } else {
        this.mCurNetStatus = NetStatus.NET_INVALID;
      }
      this.notifyObserver();
    });
  }

  public releaseNetConnection() {
    this.mNetConnection?.unregister((error: BusinessError) => {
      Logger.warn(NET_TAG, `connection unregister error ${error?.message}`);
    });
    this.mNetObserver.clear();
    this.mNetConnection = undefined;
    this.isInit = false;
    NetManager.instance = undefined;
  }

  public registerNetObserver(observer: NetObserver, isNotify: boolean = true) {
    this.mNetObserver.add(observer);
    if (isNotify) {
      this.notifyObserver(observer);
    }
  }

  public unRegisterNetObserver(observer: NetObserver) {
    this.mNetObserver.delete(observer);
  }

  private notifyNetStatus(observer: NetObserver) {
    switch (this.mCurNetStatus) {
      case NetStatus.NET_INVALID:
        observer.onNetInvalid();
        break;
      case NetStatus.NET_VALIDATED:
        observer.onNetValidated();
        break;
      case NetStatus.NET_AVAILABLE:
        observer.onNetAvailable();
        break;
      case NetStatus.NET_LOST:
        observer.onNetLost();
        break;
      default:
        break;
    }
  }

  private notifyObserver(observer?: NetObserver) {
    Logger.warn(NET_TAG, `NetManager notifyObserver CurNetStatus =${this.mCurNetStatus}`);
    if (observer == undefined) {
      this.mNetObserver.forEach((element): void => this.notifyNetStatus(element));
    } else {
      this.notifyNetStatus(observer);
    }
  }
}

export interface NetObserver {
  /**
   * 当前有网络连接，但是无法正常访问网络
   */
  onNetInvalid: () => void;

  /**
   * 当前有网络连接，可以正常访问网络
   */
  onNetValidated: () => void;

  /**
   * 连接上某一网络（有网络）
   */
  onNetAvailable: () => void;

  /**
   * 网络丢失（无网络）
   */
  onNetLost: () => void;
}