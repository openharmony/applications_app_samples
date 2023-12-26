/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import Logger from '../utils/Logger';
import { SocketType } from '../model/Socket';
import Socket from '../model/Socket';
import SocketFactory from '../model/SocketFactory';
import wifiManager from '@ohos.wifiManager';
import { BusinessError } from '@ohos.base';

const TAG = '[SocketController_] ';


export default class SocketController {
  private mSocket?: Socket;

  constructor(socketType: SocketType, localIp: string, port: number) {
    Logger.info(TAG, ` mSocket constructor ${JSON.stringify(socketType)}`);
    // 创建相应协议的Socket对象
    this.mSocket = SocketFactory.createSocket(socketType);
    this.mSocket.createSocket(localIp, port);
  }

  /**
   * 连接Socket
   * @param oppositeAddress
   * @param oppositePort
   * @param callback
   */
  public connectSocket(oppositeAddress: string, oppositePort: number, callback: (data: string) => void): void {
    Logger.info(TAG, ` mSocket connect ing ${JSON.stringify(this.mSocket)}`);
    this.mSocket?.connectSocket(oppositeAddress, oppositePort).then(res => {
      Logger.info(TAG, ` mSocket connect success ${JSON.stringify(res)}`);
      // 连接成功订阅消息回调
      this.onMessage(callback);
      // 连接成功首先发送一条消息
      this.sendData('connect success');
    }).catch((rej: BusinessError) => {
      Logger.info(TAG, ` mSocket connect fail ${JSON.stringify(rej)}`);
    });
  }

  /**
   * 订阅消息
   * @param callback
   */
  public onMessage(callback: (data: string) => void): void {
    this.mSocket?.setOnMessageReceivedListener((buffer: ArrayBuffer) => {
      // 获取数据 解析
      let data = this.decodeMsg(buffer);
      callback(data);
    });
  }

  /**
   * 关闭事件订阅
   * @param callback
   */
  public onClose(callback: () => void): void {
    this.mSocket?.setOnCloseListener(callback);

    this.onWifiDisconnect(callback);
  }

  public onWifiDisconnect(callback: () => void): void {
    Logger.info(TAG, 'onWifiDisconnect begin ');
    wifiManager.on('wifiConnectionChange', (data) => {
      Logger.info(TAG, `onWifiDisconnect wifiConnectionChange data = ${data}}`);
      if (data === 0) {
        callback();
      }
    });
    wifiManager.on('wifiStateChange', (data) => {
      Logger.info(TAG, `onWifiDisconnect wifiStateChange data = ${data}}`);
      if (data === 0) {
        callback();
      }
    });
  }

  /**
   * TCP 和 TLS发送消息
   * @param data
   */
  public sendData(data: string): void {
    this.mSocket?.sendData(data);
  }

  /**
   * UDP发送消息
   * @param data
   * @param oppositeAddress
   * @param oppositePort
   */
  public udpSendData(data: string, oppositeAddress: string, oppositePort: number): void {
    this.mSocket?.sendData(data, oppositeAddress, oppositePort);
  }

  /**
   * 关闭Socket
   */
  public closeSocket(): void {
    this.mSocket?.closeSocket();
  }

  public async isConnected(): Promise<boolean> {
    return await this.mSocket?.isConnected() as boolean;
  }

  /**
   * 解析二进制数据转为字符串
   * @param buffer
   */
  private decodeMsg(buffer: ArrayBuffer): string {
    Logger.info(TAG, `buffer type = ${typeof buffer}`);
    Logger.info(TAG, `buffer = ${buffer}`);
    let dataView = new Uint8Array(buffer);
    Logger.info(TAG, `length = ${dataView.byteLength}`);
    let data = '';
    for (let i = 0; i < dataView.byteLength; ++i) {
      let c = String.fromCharCode(dataView[i]);
      if (c !== '\n') {
        data += c;
      }
    }
    return data;
  }
}