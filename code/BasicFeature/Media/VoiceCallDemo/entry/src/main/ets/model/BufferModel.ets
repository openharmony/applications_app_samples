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
import Logger from '../utils/Logger';
import IpUtils from '../utils/IpUtils';
import TimerUtil from '../utils/TimerUtil';
import { Observer } from '../utils/TimerUtil';
import SocketImpl from '../net/SocketImpl';
import wifiManager from '@ohos.wifiManager';
import worker, { MessageEvents } from '@ohos.worker';
import Constants from '../Constants';

const TAG = 'BufferModel';
const IP: string = 'xxx.xxx.xx.xx'; // 设置自己的服务器IP地址,同步修改服务端py代码
const PORT = 8979;
const RETRY_INTERVAL = 3; // 重试间隔s

/**
 * 负责录制和渲染的worker管理
 * 负责socket服务器的连接与数据传输
 */
class BufferModel {
  private mSocketImpl: SocketImpl | null = null;
  private mCapturerWorker: worker.ThreadWorker | null = null;
  private mRendererWorker: worker.ThreadWorker | null = null;
  private lastConnected = false;
  private onDisconnectedCallback: (() => void) | null = null;
  private observer: Observer | null = null;

  public init(callback: () => void): void {
    this.connect();
    try {
      this.mCapturerWorker = new worker.ThreadWorker('entry/ets/workers/CapturerWorker.ts');
      this.mRendererWorker = new worker.ThreadWorker('entry/ets/workers/RendererWorker.ts');
      // 处理来自worker线程的消息
      this.mCapturerWorker.onmessage = (message: MessageEvents) => {
        this.onMessage(message);
      };
      this.onDisconnectedCallback = callback;
    } catch (err) {
      Logger.error(TAG, `init failed ${JSON.stringify(err)}`);
    }
  }

  private onMessage(message: MessageEvents): void {
    let messageId: number = message.data.code;
    if (messageId === Constants.WORK_MESSAGE_CAPTURER_SEND) {
      let buffer: ArrayBuffer = message.data.buffer;
      this.send(buffer);
    }
  }

  /**
   * 确认服务端和AudioCapturer以及AudioRenderer都正常后，就可以正常通话了
   */
  public startWorkTask(): void {
    try {
      if (this.mCapturerWorker && this.mRendererWorker) {
        this.mCapturerWorker.postMessage({ 'code': Constants.WORK_MESSAGE_CAPTURER_START });
        this.mRendererWorker.postMessage({ 'code': Constants.WORK_MESSAGE_RENDERER_START });
      }
    } catch (err) {
      Logger.error(TAG, `startWorkTask failed ${JSON.stringify(err)}`);
    }
  }

  public stopWorkTask(): void {
    try {
      if (this.mCapturerWorker) {
        this.mCapturerWorker.postMessage({ 'code': Constants.WORK_MESSAGE_CAPTURER_STOP });
      }
      if (this.mRendererWorker) {
        this.mRendererWorker.postMessage({ 'code': Constants.WORK_MESSAGE_RENDERER_STOP });
      }
    } catch (err) {
      Logger.error(TAG, `stopWorkTask failed ${JSON.stringify(err)}`);
    }
  }

  public destroy(): void {
    if (this.mSocketImpl) {
      this.mSocketImpl.closeSocket();
      this.mSocketImpl = null;
    }
    //停止线程
    try {
      if (this.mCapturerWorker) {
        this.mCapturerWorker.terminate();
      }
    } catch (err) {

    }
    try {
      if (this.mRendererWorker) {
        this.mRendererWorker.terminate();
      }
    } catch (err) {

    }
    if (this.observer) {
      TimerUtil.getInstance().removeObserver(this.observer);
    }
  }

  // TimerUtil回调，大概3秒一次检查socket连接
  private timerCallback(count: number): void {
    if (count % RETRY_INTERVAL === 0) {
      this.socketConnTask();
    }
  }

  // 使用 TimerUtil 全程序共用一个setInterval
  private connect(): void {
    Logger.log(TAG, ` >>>>>>>>>>>>>>>>>>>>>> start connect `);
    this.socketConnTask();
    this.observer = TimerUtil.getInstance().registerObserver((count: number) => {
      this.timerCallback(count);
    });
  }

  //连接断开时的回调，返回控制层处理断连逻辑
  private onDisconnected(): void {
    Logger.log(TAG, ` <<<<<<<<<<<<<<<<<<<<<< onDisconnected `);
    if (this.onDisconnectedCallback) {
      this.onDisconnectedCallback();
    }
  }

  /**
   * socket连接任务
   *
   * 1、未连接则尝试连接
   * 2、已连接，socket状态正常，wifi状态正常，则任务执行完毕
   * 3、已连接，socket状态不正常或wifi状态不正常，则回调连接已断开
   * 这些逻辑是为了解决 网络断开后 socket onError或onClose 方法无回调或getState状态错误的问题
   */
  private async socketConnTask(): Promise<void> {
    if (this.mSocketImpl == null) {
      this.mSocketImpl = new SocketImpl();
    }
    let wifiState: boolean = await this.checkWifiState();
    let socketConnected: boolean = await this.isConnected();
    Logger.log(TAG, `socketConnTask wifiState = ${wifiState}  socketConnected = ${socketConnected} lastConnected = ${this.lastConnected}`);
    if (!wifiState) {
      if (this.lastConnected) { //已连接，wifi断开了
        this.onDisconnected();
      }
      //wifi 断开了就都不处理了
      return;
    }
    if (this.lastConnected && !socketConnected) { ///已连接，socket断开了
      this.onDisconnected();
      return;
    }
    if (!socketConnected) { // 尝试首次
      // 首次连接
      let ret: boolean = await this.connectToAp();
      Logger.log(TAG, `socketConnTask connectToAp ${ret}`);
      if (ret) {
        this.setSocketListener();
      }
      return;
    }
    //已连接
    this.lastConnected = socketConnected;
  }

  async checkWifiState(): Promise<boolean> {
    let linkInfo = await wifiManager.getLinkedInfo();
    Logger.log(TAG, `checkWifiState ${linkInfo.ssid} : state=${linkInfo.connState}`);
    if (linkInfo.connState !== wifiManager.ConnState.CONNECTED) {
      return false;
    }
    return true;
  }

  private async setSocketListener(): Promise<void> {
    if (this.mSocketImpl == null) {
      return;
    }
    this.mSocketImpl.setOnMessageReceivedListener((result: ArrayBuffer) => {
      this.receiveData(result);
    });
    this.mSocketImpl.setOnErrorListener(() => {
      // 连接后 出错了
      if (this.lastConnected) {
        this.onDisconnected();
      }
    });
    this.mSocketImpl.setOnCloseListener(() => {
      // 连接后 close了
      if (this.lastConnected) {
        this.onDisconnected();
      }
    });
  }

  private async isConnected(): Promise<boolean> {
    if (this.mSocketImpl == null) {
      return false;
    }
    return await this.mSocketImpl.isConnected();
  }

  // 发起连接
  private async connectToAp(): Promise<boolean> {
    try {
      if (this.mSocketImpl == null) {
        return false;
      }
      let ipInfo: wifiManager.IpInfo = wifiManager.getIpInfo();
      let ipAddress: number = ipInfo.ipAddress;
      let gateway: number = ipInfo.gateway;

      if (ipAddress === 0 || gateway === 0) {
        return false;
      }
      let localIp: string = IpUtils.getIpAddress(ipAddress);
      let serverIp: string = IpUtils.getIpAddress(gateway);
      let ret: boolean = await this.mSocketImpl.createSocket(localIp, PORT);
      if (!ret) {
        return false;
      }
      // 根据自己情况选择IP
      // 服务端在pc启动，并且设备连接了pc的热点
      ret = await this.mSocketImpl.connectSocket(serverIp, PORT);
      if (!ret) {
        return false;
      }
      return true;
    } catch (e) {

    }
    return false;
  }

  // 收到音频流后直接送到 renderer 进行播放
  private async receiveData(buffer: ArrayBuffer): Promise<void> {
    Logger.log(TAG, `TCP onReceive: `);
    if (this.mRendererWorker) {
      this.mRendererWorker.postMessage({
        'code': Constants.WORK_MESSAGE_RENDERER_RECV,
        'buffer': buffer
      }, [buffer]);
    }
  }

  // 采集到的音频流直接发送到socket服务端
  private async send(buffer: ArrayBuffer): Promise<void> {
    Logger.info(TAG, `send buffer`);
    if (this.mSocketImpl) {
      await this.mSocketImpl.sendData(buffer);
    }
  }
}


let mModel = new BufferModel();

export default mModel as BufferModel;