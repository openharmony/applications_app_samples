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
import socket from '@ohos.net.socket';
import Socket from '../model/Socket';
import Logger from '../utils/Logger';

const TAG = 'Socket UdpSocket';

export default class UdpSocket implements Socket {
  private udpSocket?: socket.UDPSocket;

  /**
   * 创建Socket
   * @param localIp
   * @param port
   */
  async createSocket(localIp: string, port: number): Promise<boolean> {
    Logger.info(`${TAG} tls bind localIp: ${localIp}`);
    try {
      if (this.udpSocket) {
        await this.closeSocket();
      }

      this.udpSocket = socket.constructUDPSocketInstance();

      await this.udpSocket.bind({
        address: localIp,
        port: port,
        family: 1,
      });
      Logger.info(`${TAG} tls bind sucess`);
      return true;
    } catch (e) {
      Logger.error(`${TAG} tls bind error ${JSON.stringify(e)}}`);
    }
    return false;
  }

  /**
   * 关闭Socket
   */
  async closeSocket(): Promise<void> {
    if (!this.udpSocket) {
      return;
    }
    await this.udpSocket.close();
    this.udpSocket.off('message');
    this.udpSocket = undefined;
  }

  /**
   * 发送数据
   * @param data
   * @param address
   * @param port
   */
  async sendData(data: string, address: string, port: number): Promise<void> {
    let options: socket.UDPSendOptions = {
      address: {
        address: address,
        port: port,
        family: 1,
      },
      data: data,
    };

    if (!this.udpSocket) {
      return;
    }
    Logger.info(`${TAG} tls sendData data ${JSON.stringify(data)}`);
    try {
      await this.udpSocket.send(options);
    } catch (e) {
      Logger.error(`${TAG} tls sendData error ${JSON.stringify(e)}}`);
    }
  }

  /**
   * 订阅消息
   * @param callback
   */
  setOnMessageReceivedListener(callback: (buffer: ArrayBuffer) => void): void {
    if (!this.udpSocket) {
      return;
    }

    this.udpSocket.on('message', (data) => {
      Logger.info(`${TAG} TLS data: ` + JSON.stringify(data));
      let buffer = data.message;
      callback(buffer);
    });
  }

  /**
   * 空实现
   * @param address
   * @param port
   */
  async connectSocket(address: string, port: number): Promise<boolean> {
    return false;
  }

  /**
   * 空实现
   */
  async isConnected(): Promise<boolean> {
    return false;
  }

  /**
   * 空实现
   */
  setOnCloseListener(): void {
  }
}
