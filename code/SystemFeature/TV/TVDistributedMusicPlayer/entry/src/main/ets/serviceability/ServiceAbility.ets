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

import { rpc } from '@kit.IPCKit';
import { ShareExtensionAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import logger from '../utils/Logger';
// 暂时注释掉AppStorage导入，使用全局变量替代
// import { AppStorageV2 as AppStorage } from '@kit.ArkUI';
import {
  APPLICATION_BUNDLE_NAME,
  APPLICATION_ABILITY_NAME,
  APPLICATION_SERVICE_NAME,
  MusicSharedEventCode,
} from '../common/MusicSharedDefinition';
import { App, promptAction } from '@kit.ArkUI';
import { DistributedManager } from '../model/RemoteDeviceModel';

// 全局变量替代AppStorage
let remoteServiceExtensionConnectEvent = false;
let musicPlay = false;
let musicPause = false;
let changePlayFlag = '';

const TAG: string = 'ServiceAbility';
const CONNECT_REMOTE_TIMEOUT = 100;

let remoteProxy: rpc.RemoteProxy | null = null;
let transferManager: DistributedManager | null = null;

// 定义接口
interface ConnectOptions {
  onConnect: (elementName: object, remote: rpc.RemoteProxy) => void;
  onDisconnect: (elementName: object) => void;
  onFailed: (code: number) => void;
}

interface JsonData {
  uri: string;
  seekTo: number;
  isPlaying: boolean;
}

interface Params {
  uri: string;
  seekTo: number;
  isPlaying: boolean;
  flag: string;
}

interface WantParams {
  deviceId: string;
  bundleName: string;
  abilityName: string;
  parameters?: Params;
}

interface ServiceContext {
  connectServiceExtensionAbility?: (want: WantParams, options: ConnectOptions) => void;
  stopServiceExtensionAbility?: (want: WantParams) => Promise<void>;
  terminateSelf?: () => Promise<void>;
}

class DistributedMusicServiceExtension extends rpc.RemoteObject {
  private context: ServiceContext;

  constructor(des: string, context: ServiceContext) {
    super(des);
    this.context = context;
  }

  // 启动远程服务能力，用于设备流转
  // 建立与远程设备的连接，传递音乐播放状态
  startServiceAbility(want: WantParams): void {
    try {
      let connectOptions: ConnectOptions = {
        onConnect: (elementName: object, remote: rpc.RemoteProxy): void => {
          logger.info(TAG, `Start remote service has been succeeded, elementName= ${JSON.stringify(elementName)}, remote= ${JSON.stringify(remote)}`);
          // 显示流转成功提示
          promptAction.showToast({
            message: '流转成功',
            duration: 3000
          });
          // 更新设备状态为流转中
          transferManager?.updateDeviceProp(want.deviceId, 'transferLoading', false);
          transferManager?.updateDeviceProp(want.deviceId, 'isInTransfer', true);
          if (remote === null) {
            logger.info(TAG, 'Remote is null');
          }
          // 保存远程代理对象，用于后续通信
          remoteProxy = remote;
          // 清除连接超时定时器
          clearTimeout(timeoutId);
          // 通知客户端连接成功
          if (remoteServiceExtensionConnectEvent === undefined) {
            logger.info(TAG, `Connect remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          remoteServiceExtensionConnectEvent = !remoteServiceExtensionConnectEvent;
        },
        onDisconnect: (elementName: object): void => {
          logger.info(TAG, `ServiceExtension has onDisconnected,elementName= ${JSON.stringify(elementName)}`);
          // 清除连接超时定时器
          clearTimeout(timeoutId);
          // 清空远程代理对象
          remoteProxy = null;
          // 通知客户端连接断开
          if (remoteServiceExtensionConnectEvent === undefined) {
            logger.info(TAG, `Disconnect remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          remoteServiceExtensionConnectEvent = !remoteServiceExtensionConnectEvent;
        },
        onFailed: (code: number): void => {
          logger.info(TAG, `ServiceExtension has onFailed, code= ${JSON.stringify(code)}`);
          // 更新设备状态为非加载中
          transferManager?.updateDeviceProp(want.deviceId, 'transferLoading', false);
          // 显示流转失败提示
          promptAction.showToast({
            message: '流转失败',
            duration: 3000
          });
          // 清除连接超时定时器
          clearTimeout(timeoutId);
          // 清空远程代理对象
          remoteProxy = null;
          // 通知客户端连接失败
          if (remoteServiceExtensionConnectEvent === undefined) {
            logger.info(TAG, `Failed remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          remoteServiceExtensionConnectEvent = !remoteServiceExtensionConnectEvent;
        }
      }
      // 发起服务连接
      if (this.context.connectServiceExtensionAbility) {
        this.context.connectServiceExtensionAbility(want, connectOptions);
      }
      // 设置连接超时定时器
      let timeoutId = setTimeout(() => {
        logger.info(TAG, 'Connect remote service extension timeout');
        // 通知客户端连接超时
        if (remoteServiceExtensionConnectEvent === undefined) {
            logger.info(TAG, `Timeout remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          remoteServiceExtensionConnectEvent = !remoteServiceExtensionConnectEvent;
      }, CONNECT_REMOTE_TIMEOUT)
    } catch (err) {
      logger.info(TAG, `ConnectServiceExtensionAbility has failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`)
    }
  }

  // 停止远程服务能力，结束设备流转
  // 清理远程连接，更新设备状态
  stopServiceAbility(want: WantParams): void {
    if (this.context.stopServiceExtensionAbility) {
      // 停止远程服务
      this.context.stopServiceExtensionAbility(want)
        .then(() => {
          logger.info(TAG, `Stop service has been succeeded, want= ${JSON.stringify(want)}`);
          // 更新设备状态为非流转中
          transferManager?.updateDeviceProp(want.deviceId, 'transferLoading', false);
          transferManager?.updateDeviceProp(want.deviceId, 'isInTransfer', false);
        }).catch((err: BusinessError) => {
        logger.info(TAG, `Stop service has been failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`);
        // 无论成功失败，都更新设备状态
        transferManager?.updateDeviceProp(want.deviceId, 'transferLoading', false);
        transferManager?.updateDeviceProp(want.deviceId, 'isInTransfer', false);
      })
    }
  }

  // 处理远程消息请求，是服务与客户端通信的核心函数
  // 根据不同的消息代码执行相应的操作，如设备流转、音乐控制等
  onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    options: rpc.MessageOption): boolean {
    console.log(`${TAG} onRemoteMessageRequest code:${code}, data:${JSON.stringify(data)}` +
      ` reply:${reply} options:${options}`);
    if (code === MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE) {
      // 处理开始分布式音乐服务请求
      let deviceId = data.readString();
      let stringJson: string = data.readString();
      try {
        let jsonData: JsonData = JSON.parse(stringJson);
        logger.info(TAG, `onRemoteRequest jsonData: ${JSON.stringify(jsonData)}`);
        // 构建流转参数
        let params: Params = {
          uri: jsonData.uri,
          seekTo: jsonData.seekTo,
          isPlaying: jsonData.isPlaying,
          flag: 'START_REMOTE_DISTRIBUTED_MUSIC_SERVICE'
        }
        let want: WantParams = {
          deviceId: deviceId,
          bundleName: APPLICATION_BUNDLE_NAME,
          abilityName: APPLICATION_SERVICE_NAME,
          parameters: params
        }
        // 启动远程服务
        this.startServiceAbility(want);
      } catch (error) {
        logger.error(TAG, `JSON text error`);
      }
    } else if (code === MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE) {
      // 处理停止分布式音乐服务请求
      let deviceId = data.readString();
      let want: WantParams = {
        deviceId: deviceId,
        bundleName: APPLICATION_BUNDLE_NAME,
        abilityName: APPLICATION_SERVICE_NAME
      }
      // 停止远程服务
      this.stopServiceAbility(want)
    } else if (code === MusicSharedEventCode.PLAY_MUSIC_SERVICE) {
      // 处理播放音乐请求
      if (remoteProxy === null) {
        logger.info(TAG, 'Play local is null');
        return false
      }
      let sendOption = new rpc.MessageOption();
      let sendData = new rpc.MessageSequence();
      let sendReply = new rpc.MessageSequence();
      // 转发播放请求到远程设备
      remoteProxy.sendMessageRequest(MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if (code === MusicSharedEventCode.PAUSE_MUSIC_SERVICE) {
      // 处理暂停音乐请求
      if (remoteProxy === null) {
        logger.info(TAG, 'Pause local is null');
        return false
      }
      let sendOption = new rpc.MessageOption();
      let sendData = new rpc.MessageSequence();
      let sendReply = new rpc.MessageSequence();
      // 转发暂停请求到远程设备
      remoteProxy.sendMessageRequest(MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if (code === MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE) {
      // 处理远程播放音乐回调
      if (musicPlay === undefined) {
        logger.error(TAG, 'get play callback form app storage falied');
        return false;
      }
      // 切换播放状态标志
      musicPlay = !musicPlay;
    } else if (code === MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE) {
      // 处理远程暂停音乐回调
      if (musicPause === undefined) {
        logger.error(TAG, 'get pause callback form app storage falied');
        return false;
      }
      // 切换暂停状态标志
      musicPause = !musicPause;
    } else if (code === MusicSharedEventCode.STOP_LOCAL_SERIVCE) {
      // 处理停止本地服务请求
      if (this.context.terminateSelf) {
        this.context.terminateSelf().then(() => {
          logger.info(TAG, 'TerminateSelf service extension has been succeeded');
        }).catch((err: BusinessError) => {
          logger.info(TAG, `TerminateSelf service extension has been failed err= ${JSON.stringify(err)}`);
        })
      }
    } else if(code === MusicSharedEventCode.PRE_MUSIC_SERVICE){
      // 处理上一曲请求
      if (remoteProxy === null) {
        logger.info(TAG, 'PRE local is null');
        return false
      }
      let sendOption = new rpc.MessageOption();
      let sendData = new rpc.MessageSequence();
      let sendReply = new rpc.MessageSequence();
      // 转发上一曲请求到远程设备
      remoteProxy.sendMessageRequest(MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if(code === MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE){
      // 处理远程上一曲回调
      if (changePlayFlag === undefined) {
        logger.error(TAG, 'get changePlayFlag callback form app storage falied');
        return false;
      }
      console.log('HmLog--> sendMessageRequest PRE_MUSIC_SERVICE_REMOTE');
      // 设置上一曲标志
      changePlayFlag = 'PRE';
    } else if(code === MusicSharedEventCode.NEXT_MUSIC_SERVICE){
      // 处理下一曲请求
      if (remoteProxy === null) {
        logger.info(TAG, 'changePlayFlag local is null');
        return false
      }
      let sendOption = new rpc.MessageOption();
      let sendData = new rpc.MessageSequence();
      let sendReply = new rpc.MessageSequence();
      // 转发下一曲请求到远程设备
      remoteProxy.sendMessageRequest(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if(code === MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE){
      // 处理远程下一曲回调
      if (changePlayFlag === undefined) {
        logger.error(TAG, 'get changePlayFlag callback form app storage falied');
        return false;
      }
      console.log('HmLog--> sendMessageRequest NEXT_MUSIC_SERVICE_REMOTE');
      // 设置下一曲标志
      changePlayFlag = 'NEXT';
    } else {
      // 处理无效指令
      logger.info(TAG, 'Invalid instruction');
      return false
    }
    return true
  }
}

export default class ServiceAbility extends ShareExtensionAbility {
  // 服务创建时初始化
  // 记录服务创建事件，便于调试和问题定位
  onCreate(): void {
    logger.info(TAG, 'ServiceAbility onCreate');
  }

  // 服务销毁时的清理工作
  // 记录服务销毁事件，便于调试和问题定位
  onDestroy(): void {
    logger.info(TAG, 'ServiceAbility onDestroy');
  }

  // 处理服务请求
  // 记录服务请求事件，便于调试和问题定位
  onRequest(want: Want, startId: number): void {
    logger.info(TAG, 'ServiceAbility onRequest');;
  }

  // 处理客户端连接请求
  // 创建并返回分布式音乐服务扩展实例，用于与客户端通信
  onConnect(want: Want): rpc.RemoteObject {
    logger.info(TAG, 'ServiceAbility onConnect');
    // 创建分布式音乐服务扩展实例，传递服务上下文
    return new DistributedMusicServiceExtension('ohos.samples.distributedMusicServiceExtension', this as ServiceContext);
  }

  // 处理客户端断开连接
  // 记录断开连接事件，便于调试和问题定位
  onDisconnect(want: Want): void {
    logger.info(TAG, 'ServiceAbility onDisconnect');
  }

  // 处理客户端重新连接
  // 记录重新连接事件，便于调试和问题定位
  onReconnect(want: Want): void {
    logger.info(TAG, 'ServiceAbility onReconnect');
  }

  // 处理配置更新事件
  // 当系统配置变化时（如主题、屏幕旋转等）被调用
  onConfigurationUpdate(newConfig: object): void {
    logger.info(TAG, 'ServiceAbility onConfigurationUpdate');
  }

  // 处理服务状态导出请求
  // 用于调试和问题定位，返回服务的当前状态信息
  onDump(params: Array<string>): Array<string> {
    logger.info(TAG, 'ServiceAbility onDump');
    return params
  }
}