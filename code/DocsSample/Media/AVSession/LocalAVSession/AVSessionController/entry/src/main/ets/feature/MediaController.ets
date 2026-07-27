/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start getAVSessionDescriptorsInfo]
import { avSession } from '@kit.AVSessionKit';
// [StartExclude getAVSessionDescriptorsInfo]
import Log from '../common/Logger';

const TAG = "ControllerComponent";

export default class control {
  private currentController: avSession.AVSessionController | undefined = undefined;
  private currentControllerLink: SubscribedAbstractProperty<avSession.AVSessionController> | undefined = undefined;
  private metaDataLink: SubscribedAbstractProperty<avSession.AVMetadata> | undefined = undefined;
  private playbackStateLink: SubscribedAbstractProperty<avSession.PlaybackState> | undefined = undefined;
  private queueItemsLink: SubscribedAbstractProperty<avSession.AVQueueItem[]> | undefined = undefined;
  private isSupportedLyric: boolean | undefined = undefined;
  private isSupportedLyricLink: SubscribedAbstractProperty<boolean> | undefined = undefined;
  private isLyricVisibleLink: SubscribedAbstractProperty<boolean> | undefined = undefined;
  private validCommandsLink: SubscribedAbstractProperty<avSession.AVControlCommandType[]> | undefined = undefined;

  constructor() {
    Log.info(TAG, 'constructor');
    this.currentControllerLink = AppStorage.setAndLink<avSession.AVSessionController>('currentController', undefined);
    this.metaDataLink = AppStorage.setAndLink<avSession.AVMetadata>('metaData', undefined);
    this.playbackStateLink = AppStorage.setAndLink<avSession.PlaybackState>('playbackState', avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
    this.queueItemsLink = AppStorage.setAndLink<avSession.AVQueueItem[]>('queueItems', undefined);
    this.isSupportedLyricLink = AppStorage.setAndLink<boolean>('isSupportedLyric', false);
    this.isLyricVisibleLink = AppStorage.setAndLink<boolean>('isLyricVisible', false);
    this.validCommandsLink = AppStorage.setAndLink<avSession.AVControlCommandType[]>('validCommands', undefined);
    Log.info(TAG, 'constructor done');
  }

  async startControl(): Promise<void> {
    Log.info(TAG, 'startControl');
    await this.getAVSessionDescriptorsInfo();
    await this.listenAVSessionDestroy();
    Log.info(TAG, 'startControl done');
  }
  // [EndExclude getAVSessionDescriptorsInfo]

  // 获取媒体会话描述符及媒体会话控制器。
  async getAVSessionDescriptorsInfo(): Promise<void> {
    try {
      // 获取所有设置过媒体信息且注册过控制回调的会话的描述符信息。
      avSession.getAllSessionDescriptors().then(async (descriptors: avSession.AVSessionDescriptor[]) => {
        Log.info(TAG, 'Succeeded in getting all session descriptors, length: ' + descriptors.length);
        if (descriptors.length > 0) {
          avSession.createController(descriptors[0].sessionId).then(
            async (controller: avSession.AVSessionController) => {
            this.currentController = controller;
            this.currentControllerLink?.set(controller);
            await this.getControllerInfo();
            await this.listenControllerInfo();
            await this.getAVSessionValidCommands();
          });
        }
      });

      // 监听最新播放会话变更的事件。
      avSession.onTopSessionChange(async (descriptor: avSession.AVSessionDescriptor) => {
        Log.info(TAG, 'on topSessionChange : sessionTag: ' + descriptor.sessionTag);
        avSession.createController(descriptor.sessionId).then(async (controller: avSession.AVSessionController) => {
          this.currentController = controller;
          this.currentControllerLink?.set(controller);
          await this.getControllerInfo();
          await this.listenControllerInfo();
          await this.getAVSessionValidCommands();
        });
      });

      // 监听会话创建事件。
      avSession.onSessionCreate((descriptor: avSession.AVSessionDescriptor) => {
        Log.info(TAG, 'on sessionCreate: sessionTag: ' + descriptor.sessionTag);
      });

      // 监听会话的销毁事件。
      avSession.onSessionDestroy((descriptor: avSession.AVSessionDescriptor) => {
        Log.info(TAG, 'on sessionDestroy: ' + descriptor.sessionTag);
      });
    } catch (error) {
      if (error) {
        console.error(`avSession Error: Code: ${error.code}, message: ${error.message}`);
      }
    }
  }
  // [End getAVSessionDescriptorsInfo]

  // [Start getControllerInfo]
  async getControllerInfo(): Promise<void> {
    // 获取会话元数据。
    this.currentController?.getAVMetadata((error: BusinessError, metadata: avSession.AVMetadata) => {
      if (error) {
        Log.info(TAG, 'Failed to get AV metadata, code: ' + error.code + ', message: ' + error.message);
        return;
      }
      Log.info(TAG, 'Succeeded in getting AV metadata, assetId: ' + metadata.assetId);
      if (metadata?.mediaImage && metadata?.title && metadata?.artist) {
        this.metaDataLink?.set(metadata);
      }
    });

    // 获取播放状态。
    this.currentController?.getAVPlaybackState((error: BusinessError, state: avSession.AVPlaybackState) => {
      if (error) {
        Log.info(TAG, 'Failed to get AV playback state, code: ' + error.code + ', message: ' + error.message);
        return;
      }
      Log.info(TAG, 'Succeeded in getting AV playback state.');
      this.playbackStateLink?.set(state?.state);
    });

    // [StartExclude getControllerInfo]
    // 获取当前会话播放列表相关信息。
    this.currentController?.getAVQueueItems((error: BusinessError, items: avSession.AVQueueItem[]) => {
      if (error) {
        Log.info(TAG, 'Failed to get AV queue items, code: ' + error.code + ', message: ' + error.message);
        return;
      }
      Log.info(TAG, 'Succeeded in getting AV queue items, length: ' + items.length);
      this.queueItemsLink?.set(items);
    });

    try {
      // 查询是否启用桌面歌词功能。
      this.isSupportedLyric = await this.currentController?.isDesktopLyricEnabled();
      this.isSupportedLyricLink?.set(this.isSupportedLyric);

      // 查询当前会话桌面歌词的显示状态。
      if (this.isSupportedLyric) {
        let isLyricVisible: boolean | undefined = await this.currentController?.isDesktopLyricVisible();
        this.isLyricVisibleLink?.set(isLyricVisible);
      }
    } catch (error) {
      if (error) {
        console.error(`DesktopLyric Error: Code: ${error.code}, message: ${error.message}`);
      }
    }
    // [EndExclude getControllerInfo]
  }
  // [End getControllerInfo]

  // [Start listenControllerInfo]
  async listenControllerInfo(): Promise<void> {
    try {
      // 设置元数据变化的监听事件。
      this.currentController?.on('metadataChange', 'all', (metadata: avSession.AVMetadata) => {
        Log.info(TAG, 'on metadataChange assetId: ' + metadata.assetId);
        if (metadata?.mediaImage && metadata?.title && metadata?.artist) {
          this.metaDataLink?.set(metadata);
        }
      });

      // 设置播放状态变化的监听事件。
      this.currentController?.on('playbackStateChange', ['state'], (playbackState: avSession.AVPlaybackState) => {
        Log.info(TAG, 'on playbackStateChange state: ' + playbackState.state);
        this.playbackStateLink?.set(playbackState.state);
      });

      // [StartExclude listenControllerInfo]
      // 媒体控制器设置会话自定义播放列表变化的监听器。
      this.currentController?.on('queueItemsChange', (items: avSession.AVQueueItem[]) => {
        Log.info(TAG, 'OnQueueItemsChange, items length is ' + items.length);
        this.queueItemsLink?.set(items);
      });

      // 桌面歌词功能启用状态变更的监听事件。
      this.currentController?.onDesktopLyricEnabled((enabled: boolean) => {
        Log.info(TAG, 'desktop lyric enabled state: ' + enabled);
        this.isSupportedLyric = enabled;
        this.isSupportedLyricLink?.set(enabled);
        if (this.isSupportedLyric) {
          // 显示桌面歌词状态变更的监听事件。
          this.currentController?.onDesktopLyricVisibilityChanged((visible: boolean) => {
            Log.info(TAG, 'desktop lyric visible state: ' + visible);
            this.isLyricVisibleLink?.set(visible);
          });
        }
      })
      // [EndExclude listenControllerInfo]
    } catch (error) {
      if (error) {
        console.error(`listenControllerInfo Error: Code: ${error.code}, message: ${error.message}`);
      }
    }
  }
  // [End listenControllerInfo]

  // [Start getAVSessionValidCommands]
  async getAVSessionValidCommands(): Promise<void> {
    try {
      // 获取会话支持的有效命令。
      this.currentController?.getValidCommands((error: BusinessError,
        validCommands: avSession.AVControlCommandType[]) => {
        if (error) {
          Log.info(TAG, 'Failed to get valid commands, code: ' + error.code + ', message: ' + error.message);
          return;
        }
        Log.info(TAG, 'Succeeded in getting valid commands, size: ' + validCommands.length);
        this.validCommandsLink?.set(validCommands);
      });

      // 会话支持的有效命令变化监听事件。
      this.currentController?.on('validCommandChange', (validCommands: avSession.AVControlCommandType[]) => {
        Log.info(TAG, 'Succeeded in valid command change, size: ' + validCommands.length);
        this.validCommandsLink?.set(validCommands);
      });
    } catch (error) {
      if (error) {
        console.error(`validCommand Error: Code: ${error.code}, message: ${error.message}`);
      }
    }
  }
  // [End getAVSessionValidCommands]

  // [Start listenAVSessionDestroy]
  async listenAVSessionDestroy(): Promise<void> {
    try {
      // 注册会话销毁监听。
      this.currentController?.on('sessionDestroy', () => {
        Log.info(TAG, 'on sessionDestroy: SUCCESS');
        this.currentController?.destroy(() => { // 销毁当前控制器，销毁后当前控制器不可再用。
          Log.info(TAG, 'Succeeded in destroying.');
        });
      });
    } catch (error) {
      if (error) {
        console.error(`destroy Error: Code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  stopControl() {
    Log.info(TAG, 'stopControl');
    avSession.offSessionCreate();
    avSession.offTopSessionChange();
    Log.info(TAG, 'stopControl done');
  }
  // [End listenAVSessionDestroy]
}