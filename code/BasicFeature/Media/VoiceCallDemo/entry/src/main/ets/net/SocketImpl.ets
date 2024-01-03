/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import socket from '@ohos.net.socket';
import Logger from '../utils/Logger';

const TAG = 'SocketImpl';

/**
 * socket 封装类
 */
export default class SocketImpl {
  private tcpSocket: socket.TCPSocket | null = null;

  async createSocket(localIp: string, port: number): Promise<boolean> {
    Logger.info(TAG,`tcp bind localIp: ${localIp}`);
    try {
      if (this.tcpSocket) {
        this.tcpSocket.close();
        this.tcpSocket = null;
      }
      this.tcpSocket = socket.constructTCPSocketInstance();
      await this.tcpSocket.bind({
        address: localIp, port: port, family: 1
      });
      Logger.info(TAG,`tcp bind sucess`);
      return true;
    } catch (e) {
      Logger.error(TAG,`tcp bind error ${JSON.stringify(e)}`);
    }
    return false;
  }

  async connectSocket(address: string, port: number): Promise<boolean> {
    Logger.info(TAG,`tcp connectSocket address: ${address}`);
    try {
      if (!this.tcpSocket) {
        return false;
      }
      if (await this.isConnected()) {
        Logger.info(TAG,`tcp connectSocket sucess`);
        return true;
      }
      await this.tcpSocket.connect({
        address: {
          address: address,
          port: port,
          family: 1
        },
        timeout: 6000
      });
      await this.tcpSocket.setExtraOptions({});
      Logger.info(TAG,`tcp connectSocket sucess`);
      return true;
    } catch (e) {
      Logger.error(TAG,`tcp connectSocket error ${JSON.stringify(e)}`);
    }
    return false;
  }

  async closeSocket(): Promise<void> {
    if (!this.tcpSocket) {
      return;
    }
    await this.tcpSocket.close();
    this.tcpSocket.off('connect');
    this.tcpSocket.off('message');
    this.tcpSocket = null;
  }


  async sendData(data: ArrayBuffer): Promise<void> {

    if (!this.tcpSocket) {
      return;
    }
    Logger.info(TAG,`tcp sendData data `);
    try {
      await this.tcpSocket.send({
        data: data
      });
    } catch (e) {
      Logger.error(TAG,`tcp sendData error ${JSON.stringify(e)}`);
    }
  }

  async isConnected(): Promise<boolean> {
    if (!this.tcpSocket) {
      return false;
    }

    try {
      let state = await this.tcpSocket.getState();
      if (state.isConnected) {
        return true;
      }
    } catch (e) {
      Logger.error(TAG,`tcp getState error ${JSON.stringify(e)}`);
    }
    return false;
  }

  setOnMessageReceivedListener(callback: (data: ArrayBuffer) => void): void {
    if (!this.tcpSocket) {
      return;
    }

    this.tcpSocket.on('message', (data) => {
      Logger.log(TAG,`TCP data: ` + JSON.stringify(data));
      let buffer: ArrayBuffer = data.message;
      callback(buffer);
    });
  }

  setOnErrorListener(callback: () => void): void {
    if (!this.tcpSocket) {
      return;
    }

    this.tcpSocket.on('error', (err) => {
      Logger.log(TAG,`TCP error: ` + JSON.stringify(err));
      callback();
    });
  }

  setOnCloseListener(callback: () => void): void {
    if (!this.tcpSocket) {
      return;
    }

    this.tcpSocket.on('close', () => {
      Logger.log(TAG,`TCP close: `);
      callback();
    });
  }
}