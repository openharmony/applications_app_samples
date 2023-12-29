/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import rpc from '@ohos.rpc';
import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import Logger from '../model/Logger';
import {
  APPLICATION_BUNDLE_NAME,
  APPLICATION_ABILITY_NAME,
  APPLICATION_SERVICE_NAME,
  MusicSharedEventCode,
  MusicConnectEvent
} from '../common/MusicSharedDefinition';

const TAG: string = 'ServiceAbility'
const CONNECT_REMOTE_TIMEOUT = 10000

let remoteProxy: rpc.RemoteProxy = null;

class DistributedMusicServiceExtension extends rpc.RemoteObject {
  private context

  constructor(des, context) {
    super(des)
    this.context = context
  }

  startServiceAbility(want): void {
    try {
      let connectOptions = {
        onConnect(elementName, remote): void {
          Logger.info(TAG, `Start remote service has been succeeded, elementName= ${JSON.stringify(elementName)}, remote= ${JSON.stringify(remote)}`)
          if (remote === null) {
            Logger.info(TAG, 'Remote is null')
          }
          remoteProxy = remote as rpc.RemoteProxy;
          clearTimeout(timeoutId)
          let remoteServiceExtensionConnectEvent = AppStorage.get('remoteServiceExtensionConnectEvent');
          if (remoteServiceExtensionConnectEvent === undefined) {
            Logger.info(TAG, `Connect remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
        },
        onDisconnect(elementName): void {
          Logger.info(TAG, `ServiceExtension has onDisconnected,elementName= ${JSON.stringify(elementName)}`)
          clearTimeout(timeoutId)
          remoteProxy = null;
          let remoteServiceExtensionConnectEvent = AppStorage.get('remoteServiceExtensionConnectEvent');
          if (remoteServiceExtensionConnectEvent === undefined) {
            Logger.info(TAG, `Disconnect remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
        },
        onFailed(code): void {
          Logger.info(TAG, `ServiceExtension has onFailed, code= ${JSON.stringify(code)}`)
          clearTimeout(timeoutId)
          remoteProxy = null;
          let remoteServiceExtensionConnectEvent = AppStorage.get('remoteServiceExtensionConnectEvent');
          if (remoteServiceExtensionConnectEvent === undefined) {
            Logger.info(TAG, `Failed remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
            return;
          }
          AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
        }
      }

      this.context.connectServiceExtensionAbility(want, connectOptions)
      let timeoutId = setTimeout(() => {
        Logger.info(TAG, 'Connect remote service extension timeout')
        let remoteServiceExtensionConnectEvent = AppStorage.get('remoteServiceExtensionConnectEvent');
        if (remoteServiceExtensionConnectEvent === undefined) {
          Logger.info(TAG, `Timeout remote service callback is ${JSON.stringify(remoteServiceExtensionConnectEvent)}`);
          return;
        }
        AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', !remoteServiceExtensionConnectEvent);
      }, CONNECT_REMOTE_TIMEOUT)
    } catch (err) {
      Logger.info(TAG, `ConnectServiceExtensionAbility has failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`)
    }
  }

  stopServiceAbility(want): void {
    this.context.stopServiceExtensionAbility(want).then(() => {
      Logger.info(TAG, `Stop service has been succeeded, want= ${JSON.stringify(want)}`)
    }).catch((err) => {
      Logger.info(TAG, `Stop service has been failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`)
    })
  }

  onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, options: rpc.MessageOption): boolean {
    if (code === MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE) {
      let deviceId = data.readString()
      let stringJson: string = data.readString()
      let jsonData = JSON.parse(stringJson)
      let params = {
        uri: jsonData.uri,
        seekTo: jsonData.seekTo,
        isPlaying: jsonData.isPlaying,
        flag: 'START_REMOTE_DISTRIBUTED_MUSIC_SERVICE'
      }
      let want = {
        deviceId: deviceId,
        bundleName: APPLICATION_BUNDLE_NAME,
        abilityName: APPLICATION_SERVICE_NAME,
        parameters: params
      }
      this.startServiceAbility(want)
    } else if (code === MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE) {
      let deviceId = data.readString()
      let want = {
        deviceId: deviceId,
        bundleName: APPLICATION_BUNDLE_NAME,
        abilityName: APPLICATION_SERVICE_NAME
      }
      this.stopServiceAbility(want)
    } else if (code === MusicSharedEventCode.PLAY_MUSIC_SERVICE) {
      if (remoteProxy === null) {
        Logger.info(TAG, 'Play local is null')
        return false
      }
      let option = new rpc.MessageOption()
      let data = new rpc.MessageParcel()
      let reply = new rpc.MessageParcel()
      remoteProxy.sendRequest(MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE, data, reply, option);
    } else if (code === MusicSharedEventCode.PAUSE_MUSIC_SERVICE) {
      if (remoteProxy === null) {
        Logger.info(TAG, 'Pause local is null')
        return false
      }
      let option = new rpc.MessageOption()
      let data = new rpc.MessageParcel()
      let reply = new rpc.MessageParcel()
      remoteProxy.sendRequest(MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE, data, reply, option);
    } else if (code === MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE) {
      let musicPlay = AppStorage.get('musicPlay');
      if (musicPlay === undefined) {
        Logger.error(TAG, 'get play callback form app storage falied');
        return false;
      }
      AppStorage.setOrCreate('musicPlay', !musicPlay);
    } else if (code === MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE) {
      let musicPause = AppStorage.get('musicPause');
      if (musicPause === undefined) {
        Logger.error(TAG, 'get pause callback form app storage falied');
        return false;
      }
      AppStorage.setOrCreate('musicPause', !musicPause);
    } else if (code === MusicSharedEventCode.STOP_LOCAL_SERIVCE) {
      this.context.terminateSelf().then(() => {
        Logger.info(TAG, 'TerminateSelf service extension has been succeeded')
      }).catch((err) => {
        Logger.info(TAG, `TerminateSelf service extension has been failed err= ${JSON.stringify(err)}`)
      })
    } else {
      Logger.info(TAG, 'Invalid instruction')
      return false
    }
    return true
  }
}

export default class ServiceAbility extends ServiceExtensionAbility {
  onCreate(want): void {
    if (want.parameters.flag === 'START_REMOTE_DISTRIBUTED_MUSIC_SERVICE') {
      let localwant = {
        bundleName: APPLICATION_BUNDLE_NAME,
        abilityName: APPLICATION_ABILITY_NAME,
        parameters: want.parameters
      }
      this.context.startAbility(localwant).then(() => {
        Logger.info(TAG, 'StartUIAbility has been succeeded')
      }).catch((err) => {
        Logger.info(TAG, `StartUIAbility has been failed, err= ${JSON.stringify(err)}`)
      })
    }
  }

  onDestroy(): void {
    Logger.info(TAG, 'ServiceAbility onDestroy')
  }

  onRequest(want, startId): void {
    Logger.info(TAG, 'ServiceAbility onRequest')
  }

  onConnect(want): rpc.RemoteObject {
    Logger.info(TAG, 'ServiceAbility onConnect')
    if (this.context === null && this.context === undefined) {
      Logger.error(TAG, 'ServiceAbility context does not exist or is empty')
      return
    }
    return new DistributedMusicServiceExtension('ohos.samples.distributedMusicServiceExtension', this.context)
  }

  onDisconnect(want): void {
    Logger.info(TAG, 'ServiceAbility onDisconnect')
  }

  onReconnect(want): void {
    Logger.info(TAG, 'ServiceAbility onReconnect')
  }

  onConfigurationUpdate(newConfig): void {
    Logger.info(TAG, 'ServiceAbility onConfigurationUpdate')
  }

  onDump(params: Array<string>): Array<string> {
    Logger.info(TAG, 'ServiceAbility onDump')
    return params
  }
}