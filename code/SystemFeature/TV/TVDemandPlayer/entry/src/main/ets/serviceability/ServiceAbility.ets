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
import { ServiceExtensionAbility } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { Logger } from '@ohos/utilslibrary';
import { DistributedEventCode } from '../const/DistributedEventCode';
import { common, Want } from '@kit.AbilityKit';

const TAG: string = 'ServiceAbility'
const CONNECT_REMOTE_TIMEOUT = 10000

let remoteProxy: rpc.RemoteProxy | null = null;
let remoteWant: Want | null = null
let interactiveProxy: rpc.RemoteProxy | null = null

interface ServiceParams {
  startBy: string;
  videoIndex: number;
  url: string;
  currentTime: number;
  videoList: string;
  stopTransfer: boolean;
  flag: string;
  isPlay: boolean;
  sourceDeviceId: string;
}

interface StartPayload {
  startBy: string;
  videoIndex: number;
  url: string;
  currentTime: number;
  videoList: string;
  stopTransfer: boolean;
  isPlay: boolean;
}

interface ErrorLike {
  code?: number;
  message?: string;
  name?: string;
}

interface ConnectOptionsLike {
  onConnect: (elementName: Object, remote: rpc.RemoteObject) => void;
  onDisconnect: (elementName: Object) => void;
  onFailed: (code: number) => void;
}

interface ServiceExtensionContextLike {
  connectServiceExtensionAbility: (want: Want, options: ConnectOptionsLike) => void;
  stopServiceExtensionAbility: (want: Want) => Promise<void>;
}

class DistributedMusicServiceExtension extends rpc.RemoteObject {
  private context: ServiceExtensionContextLike

  private createConnectOptions(timeoutId: number): ConnectOptionsLike {
    return {
      onConnect: (elementName: Object, remote: rpc.RemoteObject): void => {
        Logger.info(TAG,
          `Start remote service has been succeeded, elementName= ${JSON.stringify(elementName)}, remote= ${JSON.stringify(remote)}`)
        promptAction.showToast({
          message: '流转成功',
          duration: 3000
        });
        remoteProxy = remote as rpc.RemoteProxy;
        clearTimeout(timeoutId)
        let remoteServiceExtensionConnectEvent = AppStorage.get<boolean>('remoteServiceExtensionConnectEvent');
        if (remoteServiceExtensionConnectEvent === undefined) {
          Logger.info(TAG, `Connect remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
          return;
        }
        AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
      },
      onDisconnect: (elementName: Object): void => {
        Logger.info(TAG, `ServiceExtension has onDisconnected,elementName= ${JSON.stringify(elementName)}`)
        clearTimeout(timeoutId)
        remoteProxy = null;
        let remoteServiceExtensionConnectEvent = AppStorage.get<boolean>('remoteServiceExtensionConnectEvent');
        if (remoteServiceExtensionConnectEvent === undefined) {
          Logger.info(TAG,
            `Disconnect remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
          return;
        }
        AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
      },
      onFailed: (code: number): void => {
        Logger.info(TAG, `ServiceExtension has onFailed, code= ${JSON.stringify(code)}`);
        promptAction.showToast({
          message: '流转失败',
          duration: 3000
        })
        clearTimeout(timeoutId)
        remoteProxy = null;
        let remoteServiceExtensionConnectEvent = AppStorage.get<boolean>('remoteServiceExtensionConnectEvent');
        if (remoteServiceExtensionConnectEvent === undefined) {
          Logger.info(TAG, `Failed remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
          return;
        }
        AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
      }
    };
  }

  constructor(des: string, context: ServiceExtensionContextLike) {
    super(des)
    this.context = context
  }


  startServiceAbility(want: Want): void {
    try {
      let timeoutId = setTimeout(() => {
        Logger.info(TAG, 'Connect remote service extension timeout')
        let remoteServiceExtensionConnectEvent = AppStorage.get<boolean>('remoteServiceExtensionConnectEvent');
        if (remoteServiceExtensionConnectEvent === undefined) {
          Logger.info(TAG, `Timeout remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
          return;
        }
        AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
      }, CONNECT_REMOTE_TIMEOUT)
      let connectOptions: ConnectOptionsLike = this.createConnectOptions(timeoutId);
      this.context.connectServiceExtensionAbility(want, connectOptions)
    } catch (err) {
      Logger.info(TAG,
        `ConnectServiceExtensionAbility has failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`)
    }
  }

  stopServiceAbility(want: Want): void {
    this.context.stopServiceExtensionAbility(want)
      .then(() => {
        Logger.info(TAG, `Stop service has been succeeded, want= ${JSON.stringify(want)}`);
      }).catch((err: ErrorLike) => {
      Logger.info(TAG, `Stop service has been failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`);
    })
  }


  onRemoteMessageRequest(code: number,
    data: rpc.MessageSequence, reply: rpc.MessageSequence, options: rpc.MessageOption): boolean {
    console.log('code：'+code)
    if (code === DistributedEventCode.START_DISTRIBUTED_PLAYER_SERVICE) {   //START
      let localDeviceId: string = data.readString()
      let deviceId: string = data.readString()
      console.log('666666devicedid:'+deviceId)
      let stringJson: string = data.readString()
      try {
        let jsonData = JSON.parse(stringJson) as StartPayload;
        Logger.info(TAG, `666666onRemoteRequest jsonData: ${JSON.stringify(jsonData)}`);
        let params: ServiceParams = {
          startBy: jsonData.startBy,
          videoIndex: jsonData.videoIndex,
          url: jsonData.url,
          currentTime: jsonData.currentTime,
          videoList: jsonData.videoList,
          stopTransfer: jsonData.stopTransfer,
          flag: 'START_REMOTE_DISTRIBUTED_MUSIC_SERVICE',
          isPlay: jsonData.isPlay,
          sourceDeviceId:localDeviceId
        }
        let want: Want = {
          deviceId: deviceId,
          bundleName: 'com.ohos.demandplayer',
          abilityName: 'ServiceAbility',
          parameters: params as Object as Record<string, Object>
        }
        remoteWant = want
        this.startServiceAbility(want);
      } catch (error) {

      }
    } else if (code === DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE) {   //STOP
      if (remoteProxy === null) {
        Logger.info(TAG, 'Play local is null')
        return false
      }
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      remoteProxy.sendMessageRequest(DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE_REMOTE,
        sendData, sendReply, sendOption);
      if (remoteWant) {
        this.stopServiceAbility(remoteWant)
      }
    }else if (code === DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE_REMOTE){
      (globalThis.abilityContext as  common.UIAbilityContext).terminateSelf() // UIAbilityContext
    } else if (code === DistributedEventCode.PLAY_PLAYER_SERVICE) {  //PLAY
      if (remoteProxy === null) {
        Logger.info(TAG, 'Play local is null')
        return false
      }
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      remoteProxy.sendMessageRequest(DistributedEventCode.PLAY_PLAYER_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if (code === DistributedEventCode.PAUSE_PLAYER_SERVICE) {   //PAUSE
      if (remoteProxy === null) {
        Logger.info(TAG, 'Pause local is null')
        return false
      }
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      remoteProxy.sendMessageRequest(DistributedEventCode.PAUSE_PLAYER_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if (code === DistributedEventCode.PLAY_PLAYER_SERVICE_REMOTE) {   //remote play
      let videoPlay = AppStorage.get<string>('videoPlayFlag');
      if (videoPlay === undefined) {
        return false;
      }
      console.log('onRemoteMessageRequest Play remote');
      AppStorage.setOrCreate('videoPlayFlag','play');
    } else if (code === DistributedEventCode.PAUSE_PLAYER_SERVICE_REMOTE) {    //remote pause
      let videoPause = AppStorage.get<string>('videoPauseFlag');
      if (videoPause === undefined) {
        return false;
      }
      AppStorage.setOrCreate('videoPauseFlag','pause');
    } else if (code === DistributedEventCode.PRE_PLAYER_SERVICE) { // PRE
      if (remoteProxy === null) {
        Logger.info(TAG, 'Pause local is null')
        return false
      }
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      remoteProxy.sendMessageRequest(DistributedEventCode.PRE_PLAYER_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if (code === DistributedEventCode.PRE_PLAYER_SERVICE_REMOTE) { // remote PRE
      let changePlayFlag = AppStorage.get<string>('changePlayFlag');
      if (changePlayFlag === undefined) {
        Logger.err(TAG, 'get changePlayFlag callback form app storage falied');
        return false;
      }
      AppStorage.setOrCreate('changePlayFlag','PRE');
    }else if (code === DistributedEventCode.NEXT_PLAYER_SERVICE) { // NEXT
      if (remoteProxy === null) {
        Logger.info(TAG, 'Pause local is null')
        return false
      }
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      remoteProxy.sendMessageRequest(DistributedEventCode.NEXT_PLAYER_SERVICE_REMOTE, sendData, sendReply, sendOption);
    } else if (code === DistributedEventCode.NEXT_PLAYER_SERVICE_REMOTE) { // remote PRE
      let changePlayFlag = AppStorage.get<string>('changePlayFlag');
      if (changePlayFlag === undefined) {
        Logger.err(TAG, 'get changePlayFlag callback form app storage falied');
        return false;
      }
      AppStorage.setOrCreate('changePlayFlag','NEXT');
    }else if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE){
      console.log('HmLog-->SYNC_PLAYER_TIME_SERVICE');
      if (globalThis.interactiveProxy === null) {
        Logger.info(TAG, 'interactiveProxy is null')
        return false
      }
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      globalThis.interactiveProxy.sendMessageRequest(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REMOTE,
        sendData, sendReply, sendOption);
    }else if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REMOTE){
      console.log('HmLog-->SYNC_PLAYER_TIME_SERVICE_REMOTE');
      //获取seek时间
      let getSeekTime = AppStorage.get<string>('getSeekTimeFlag');
      if (getSeekTime === undefined) {
        Logger.err(TAG, 'get changePlayFlag callback form app storage falied');
        return false;
      }
      AppStorage.setOrCreate('getSeekTimeFlag','get');
    }else if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REPLAY){
      //回复seek时间
      console.log('HmLog-->SYNC_PLAYER_TIME_SERVICE_REPLAY');
      remoteProxy?.sendMessageRequest(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_SET_TIME,data,reply,options)
    } else if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_SET_TIME){
      //设置seek时间
      console.log('HmLog-->SYNC_PLAYER_TIME_SERVICE_SET_TIME');
      let setSeekTime = AppStorage.get<string>('setSeekTimeFlag');
      if (setSeekTime === undefined) {
        Logger.err(TAG, 'get changePlayFlag callback form app storage falied');
        return false;
      }
      let seekTime = data.readString()
      console.log('HmLog-->seekTime',seekTime);
      AppStorage.setOrCreate('setSeekTimeFlag',seekTime);
    }else {
      Logger.info(TAG, 'Invalid instruction')
      return false
    }
    return true
  }
}

export default class ServiceAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    console.log('StartUIAbility has been')
    if (want.parameters?.flag === 'START_REMOTE_DISTRIBUTED_MUSIC_SERVICE') {
      let localwant: Want = {
        bundleName: 'com.ohos.demandplayer',
        abilityName: 'MainAbility',
        parameters: want.parameters
      }
      this.context.startAbility(localwant).then(() => {
        Logger.info(TAG, 'StartUIAbility has been succeeded')
      }).catch((err: ErrorLike) => {
        Logger.info(TAG, `StartUIAbility has been failed, err= ${JSON.stringify(err)}`)
      })
    }
  }

  onDestroy(): void {
    Logger.info(TAG, 'ServiceAbility onDestroy')
  }

  onRequest(_want: Want, _startId: number): void {
    Logger.info(TAG, 'ServiceAbility onRequest')
  }

  onConnect(_want: Want): rpc.RemoteObject {
    Logger.info(TAG, 'ServiceAbility onConnect')
    return new DistributedMusicServiceExtension(
      'ohos.samples.distributedMusicServiceExtension',
      this.context as ServiceExtensionContextLike
    )
  }

  onDisconnect(_want: Want): void {
    Logger.info(TAG, 'ServiceAbility onDisconnect')
  }

  onReconnect(_want: Want): void {
    Logger.info(TAG, 'ServiceAbility onReconnect')
  }

  onConfigurationUpdate(_newConfig: Object): void {
    Logger.info(TAG, 'ServiceAbility onConfigurationUpdate')
  }

  onDump(params: Array<string>): Array<string> {
    Logger.info(TAG, 'ServiceAbility onDump')
    return params
  }
}
