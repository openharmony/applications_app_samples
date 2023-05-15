/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
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

import AVSessionManager from '@ohos.multimedia.avsession';
import Log from '../common/Logger';
import bundle from '@ohos.bundle';

const TAG = "ControllerComponent";

export default class control {
  private isPlaying: boolean = false;
  private isLyric: boolean = false;
  private bundleNameMap: Map<string, string> = new Map();
  private controllerMap: Map<string, AVSessionManager.AVSessionController> = new Map();
  private metaDataMap: Map<string, AVSessionManager.AVMetadata> = new Map();
  private playStateMap: Map<string, AVSessionManager.AVMetadata> = new Map();
  private queueTitleMap: Map<string, string> = new Map();
  private queueItemsMap: Map<string, Array<AVSessionManager.AVQueueItem>> = new Map();
  private lyricMap: Map<string, string> = new Map();
  private sessionArray: Array<string> = new Array();
  private isPlayingLink = undefined;
  private isLyricLink = undefined;
  private bundleNameMapLink = undefined;
  private metaDataMapLink = undefined;
  private playStateMapLink = undefined;
  private queueTitleMapLink = undefined;
  private queueItemsMapLink = undefined;
  private lyricMapLink = undefined;
  private sessionArrayLink = undefined;

  constructor() {
    Log.info(TAG, 'constructor');
    this.initLink();
    Log.info(TAG, 'constructor done');
    this.interval();
  }

  async initLink(): Promise<void> {
    Log.info(TAG, 'initLink');
    this.isPlayingLink = AppStorage.SetAndLink('isPlaying', undefined);
    this.isLyricLink = AppStorage.SetAndLink('isLyric', undefined);
    this.bundleNameMapLink = AppStorage.SetAndLink('bundleNameMap', undefined);
    this.metaDataMapLink = AppStorage.SetAndLink('metaDataMap', undefined);
    this.playStateMapLink = AppStorage.SetAndLink('playStateMap', undefined);
    this.queueItemsMapLink = AppStorage.SetAndLink('queueItemsMap', undefined);
    this.queueTitleMapLink = AppStorage.SetAndLink('queueTitleMap', undefined);
    this.lyricMapLink = AppStorage.SetAndLink('lyricMap', undefined);
    this.sessionArrayLink = AppStorage.SetAndLink('sessionArray', undefined);
    Log.info(TAG, 'initLink done');
  }

  async startControl(): Promise<void> {
    Log.info(TAG, 'startControl');
    let sessionDesList: Array<AVSessionManager.AVSessionDescriptor> = await AVSessionManager.getAllSessionDescriptors();
    Log.info(TAG, 'session des length : ' + sessionDesList.length);
    for (let i = 0; i < sessionDesList.length; i++) {
      let descriptor: AVSessionManager.AVSessionDescriptor = sessionDesList[i];
      let sessionId: string = descriptor.sessionId;
      Log.info(TAG, 'session des sessionId : ' + sessionId);
      let controller: AVSessionManager.AVSessionController = await AVSessionManager.createController(sessionId);
      await this.getBundleName(descriptor);
      Log.info(TAG, 'getBundleName done : ' + sessionId);
      await this.makeListener(controller);
      Log.info(TAG, 'makeListener done : ' + sessionId);
      await this.getMetaData(controller);
      Log.info(TAG, 'makeListener done : ' + sessionId);
      this.sessionArray[i] = sessionId;
      this.controllerMap[sessionId] = controller;
    }
    let hisSessionDesList: Array<AVSessionManager.AVSessionDescriptor> =
      await AVSessionManager.getHistoricalSessionDescriptors();
    Log.info(TAG, 'historical session des length : ' + hisSessionDesList.length);
    for (let j = 0; j < hisSessionDesList.length; j++) {
      let descriptor: AVSessionManager.AVSessionDescriptor = hisSessionDesList[j];
      let sessionId: string = descriptor.sessionId;
      Log.info(TAG, 'historical session des sessionId : ' + sessionId);
      if (this.sessionArray.indexOf(sessionId) >= 0) {
        Log.info(TAG, 'historical session already exist quit :  sessionId : ' + sessionId);
        continue;
      }
      await this.getBundleName(descriptor);
      this.sessionArray.push(sessionId);
      this.metaDataMap[sessionId] = {
        title: '未在播放',
        artist: '',
        assetId: ''
      }
    }
    this.isPlayingLink.set(this.isPlaying);
    Log.info(TAG, 'session info done to link isPlaying');
    this.metaDataMapLink.set(this.metaDataMap);
    Log.info(TAG, 'session info done to link metaDataMap');
    this.playStateMapLink.set(this.playStateMap);
    Log.info(TAG, 'session info done to link playStateMap');
    this.queueItemsMapLink.set(this.queueItemsMap);
    Log.info(TAG, 'session info done to link queueItemsMap');
    this.queueTitleMapLink.set(this.queueTitleMap);
    Log.info(TAG, 'session info done to link queueTitleMap');
    this.bundleNameMapLink.set(this.bundleNameMap);
    Log.info(TAG, 'session info done to link bundleNameMap');
    this.lyricMapLink.set(this.lyricMap);
    Log.info(TAG, 'session info done to link lyricMap');
    this.sessionArrayLink.set(this.sessionArray);
    Log.info(TAG, 'session info done to link sessionArray');
    Log.info(TAG, 'startControl done ');
  }

  async getBundleName(descriptor: AVSessionManager.AVSessionDescriptor): Promise<void> {
    Log.info(TAG, 'getBundleName sessionId  : ' + descriptor.sessionId);
    let bundleAppName: string = await bundle.getAbilityLabel(descriptor.elementName.bundleName,
      descriptor.elementName.abilityName);
    Log.info(TAG, 'getBundleName name : ' + bundleAppName);
    this.bundleNameMap[descriptor.sessionId] = '来自 ' + bundleAppName;
    Log.info(TAG, 'getBundleName name finished');
  }

  async getMetaData(controller: AVSessionManager.AVSessionController): Promise<void> {
    let that = this;
    let sessionId: string = controller.sessionId;
    let metadata: AVSessionManager.AVMetadata = await controller.getAVMetadata();
    that.metaDataMap[sessionId] = metadata;
    Log.info(TAG, 'get metadata  : ' + metadata.title + ' for session :' + sessionId);
    let queueTitle: string = await controller.getAVQueueTitle();
    Log.info(TAG, 'get queue queueTitle  : ' + queueTitle);
    that.queueTitleMap[sessionId] = queueTitle;
    let queueItems: Array<AVSessionManager.AVQueueItem> = await controller.getAVQueueItems();
    Log.info(TAG, 'get queue items  : ' + queueItems.length);
    that.queueItemsMap[sessionId] = queueItems;
    let avPlayState: AVSessionManager.AVPlaybackState = await controller.getAVPlaybackState();
    let playState: AVSessionManager.PlaybackState = avPlayState.state;
    that.playStateMap[sessionId] = playState;
    that.isPlaying = (playState == AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY);
    Log.info(TAG, 'get playState  : ' + that.isPlaying);
  }

  async makeListener(controller: AVSessionManager.AVSessionController): Promise<void> {
    let that = this;
    let sessionId: string = controller.sessionId;
    controller.on('metadataChange', 'all', (metadata: AVSessionManager.AVMetadata) => {
      Log.info(TAG, 'get metadata: ' + metadata.title + ' for session :' + sessionId);
      let dataMap = that.metaDataMapLink.get();
      dataMap[sessionId] = metadata;
      that.metaDataMapLink.set(dataMap);
    });
    controller.on('playbackStateChange', 'all', async (playState: AVSessionManager.AVPlaybackState) => {
      Log.info(TAG, 'get playbackState: ' + playState.state + ' for session:' + sessionId);
      that.playStateMap[sessionId] = playState.state;
      that.isPlaying = (playState.state == AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY);
      that.isPlayingLink.set(that.isPlaying);
      that.playStateMapLink.set(that.playStateMap);
    });
    controller.on('queueItemsChange', (items: Array<AVSessionManager.AVQueueItem>) => {
      Log.info(TAG, 'get queueItems: ' + items.length + ' for session :' + sessionId);
      that.queueItemsMap[sessionId] = items;
      that.queueItemsMapLink.set(that.queueItemsMap);
    });
    controller.on('queueTitleChange', (title: string) => {
      Log.info(TAG, 'get queueTitle  : ' + title + ' for session :' + sessionId);
      that.queueTitleMap[sessionId] = title;
      that.queueTitleMapLink.set(that.queueTitleMap);
    });
    controller.on('sessionEvent', async (sessionEvent: string, args: { [key: string]: Object }) => {
      let lyricStruct = await controller.getExtras();
      let lyricLineNum: number = Number(lyricStruct.lyricsLineNumber);
      that.lyricMap[sessionId] = String(lyricLineNum + ' : ' + args.lyrics);
      that.lyricMapLink.set(that.lyricMap);
    });
  }

  async play(sessionId: string): Promise<void> {
    let command: AVSessionManager.AVControlCommand = {
      command: 'play',
      parameter: undefined
    }
    let controller: AVSessionManager.AVSessionController = this.controllerMap[sessionId];
    await controller.sendControlCommand(command);
  }

  async pause(sessionId: string): Promise<void> {
    let command: AVSessionManager.AVControlCommand = {
      command: 'pause',
      parameter: undefined
    }
    let controller: AVSessionManager.AVSessionController = this.controllerMap[sessionId];
    await controller.sendControlCommand(command);
  }

  async next(sessionId: string): Promise<void> {
    let command: AVSessionManager.AVControlCommand = {
      command: 'playNext',
      parameter: undefined
    }
    let controller: AVSessionManager.AVSessionController = this.controllerMap[sessionId];
    await controller.sendControlCommand(command);
  }

  async previous(sessionId: string): Promise<void> {
    let command: AVSessionManager.AVControlCommand = {
      command: 'playPrevious',
      parameter: undefined
    }
    let controller: AVSessionManager.AVSessionController = this.controllerMap[sessionId];
    await controller.sendControlCommand(command);
  }

  async skip(sessionId: string, itemId: number): Promise<void> {
    let controller: AVSessionManager.AVSessionController = this.controllerMap[sessionId];
    Log.info(TAG, 'on skip to : ' + controller + ' | ' + itemId)
    await controller.skipToQueueItem(itemId);
  }

  async getLyric(sessionId: string): Promise<void> {
    let controller: AVSessionManager.AVSessionController = this.controllerMap[sessionId];
    this.isLyric = !this.isLyric;
    this.isLyricLink.set(this.isLyric);
    let paramStruct = {
      'lyrics': this.isLyric
    };
    await controller.sendCommonCommand('lyrics', paramStruct);
  }

  async interval(): Promise<void> {
    setInterval(async () => {
      let paramStruct = {
        'lyrics': this.isLyric
      };
      await this.controllerMap[this.sessionArray[0]].sendCommonCommand('lyrics', paramStruct);
    }, 1000)
  }
}