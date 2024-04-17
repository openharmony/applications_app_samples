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

import avSession from '@ohos.multimedia.avsession';
import media from '@ohos.multimedia.media';
import promptAction from '@ohos.promptAction';
import CommonUtils from '../common/CommonUtils';
import common from '@ohos.app.ability.common';
import AudioUtils from '../common/AudioUtils';
import connection from '@ohos.net.connection';
import wantAgent from '@ohos.app.ability.wantAgent';
import Constants from '../common/Constants';
import AVCastPicker from '@ohos.multimedia.avCastPicker';
import audio from '@ohos.multimedia.audio';
import fs from '@ohos.file.fs';
import util from '@ohos.util';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import Log from '../common/Log';
import deviceInfo from '@ohos.deviceInfo';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State outputDevice: avSession.OutputDeviceInfo = {devices: []};
  @State outputDeviceInfo: avSession.OutputDeviceInfo = {devices: []};
  @State castController: avSession.AVCastController | undefined = undefined;
  @State castControllerSession: avSession.AVSessionController | undefined = undefined;
  @State session: avSession.AVSession | undefined = undefined;
  @State controller: avSession.AVSessionController | undefined = undefined;
  @State albumImage: image.PixelMap | undefined = undefined;
  @State playType: 'local' | 'cast' = 'local';
  @StorageLink('playState') playState: number = -1;
  @State isFavorMap: Map<string, boolean> = new Map();
  @State volume: number = 0 ;
  @State seedPosition: number = 0;
  @State duration: number = 0;
  @State private  currentIndex: number = 0;
  @State @Watch('playInfoUpdated') currentPlayInfo: avSession.AVMediaDescription | undefined = undefined;
  @State currentMediaId: string = '';
  @State currentLoopMode: number = 2;
  @State hasNetwork: boolean = false;
  @State isProgressSliding: boolean = false;
  @State audioType: 'url' | 'rawfile' | 'scan' | 'video' = 'url';
  @State avCastPickerColor:Color = Color.White;
  private audioUtils: AudioUtils = new AudioUtils();
  private avPlayer: media.AVPlayer | undefined = undefined;
  private audioVolumeGroupManager: audio.AudioVolumeGroupManager | undefined = undefined;
  private localAudioRation = 1;
  private audioManager: audio.AudioManager | undefined = undefined;
  private netCon?: connection.NetConnection;
  private sliderTimer?: number;
  private mXComponentController: XComponentController = new XComponentController();
  @State private songList: Array<avSession.AVMediaDescription> = [];
  private urlVideoList: Array<avSession.AVMediaDescription> = Constants.URL_VIDEO_LIST;

  async aboutToAppear() {
    Log.info('about to appear');
    this.songList = this.urlVideoList;
    this.audioType = 'video';
    this.currentPlayInfo = this.urlVideoList[0];
    this.avPlayer = await this.audioUtils.init();
    this.avPlayer?.on('audioInterrupt', (info: audio.InterruptEvent) => {
      Log.info('audioInterrupt success, and InterruptEvent info is: ' + info);
      if (this.avPlayer?.state === 'playing') {
        Log.info('audio interrupt, start pause');
        this.avPlayer?.pause();
        this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
        promptAction.showToast({ message: 'audio interrupt, pause done' });
      }
    })
    this.avPlayer?.on('timeUpdate', (time: number) => {
      Log.info('timeUpdate time: ' + time);
      if (!this.isProgressSliding) {
        if (this.duration == 0) {
          this.seedPosition = 0;
        } else {
          this.seedPosition = time / this.duration * 100;
        }
        const params: avSession.AVPlaybackState = {
          position: {
            elapsedTime: time,
            updateTime: new Date().getTime()
          },
        };
        this.session?.setAVPlaybackState(params);
      }
    })
    this.avPlayer?.on('durationUpdate', (duration: number) => {
      Log.info('durationUpdate duration: ' + duration);
      this.duration = duration;
      if (this.duration !== 0) {
        const playMetaData: avSession.AVMetadata = {
          assetId: this.currentPlayInfo?.assetId as string,  // origin assetId
          title: this.currentPlayInfo?.title as string,
          artist: this.currentPlayInfo?.artist as string,
          mediaImage: this.albumImage, // origin mediaImage
          album: this.currentPlayInfo?.albumTitle as string,
          duration: this.duration
        }
        this.session?.setAVMetadata(playMetaData);
      }

    })
    this.avPlayer?.on('videoSizeChange', (width: number, height: number) => {
      Log.info('videoSizeChange success, and width is: ' + width + ', height is: ' + height);
    })
    await this.setAudioManager();
    await this.autoStartAll(false);
    this.addNetworkListener();
    this.readLRCFile();
    Log.info('about to appear done: ' + !!this.avPlayer);
  }

  readLRCFile(): void {
    const context = getContext(this) as common.UIAbilityContext;
    context.resourceManager.getRawFileContent('test.lrc', (error: BusinessError, value: Uint8Array) => {
      if (error != null) {
        Log.info('error is: ' + error);
      } else {
        let rawFile = value;
        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        let retStr = textDecoder.decodeWithStream(rawFile, { stream: false });
        Log.info('get lrc file: ' + retStr);
      }
    });
  }

  addNetworkListener(): void {
    Log.info('start add Network Listener');
    this.netCon = connection.createNetConnection();
    this.netCon?.register((error: BusinessError) => {
      Log.error('network error: ' + JSON.stringify(error));
    })
    connection.getAllNets().then(data => {
      Log.info('get all network: ' + JSON.stringify(data));
      this.hasNetwork = data?.length > 0;
    })
    this.netCon?.on('netAvailable', data => {
      Log.info('network Available: ' + JSON.stringify(data));
      this.hasNetwork = true;
    })
    this.netCon?.on('netLost', data => {
      Log.info('network Lost: ' + JSON.stringify(data));
      connection.getAllNets().then(data => {
        Log.info('get all network: ' + JSON.stringify(data));
        this.hasNetwork = data?.length > 0;
      });
    })
  }

  onPageHide() {
    Log.info('indexPage onPAgeHide in.');
  }

  async playInfoUpdated() {
    Log.info('playInfoUpdated: ' + JSON.stringify(this.currentPlayInfo));
    this.currentMediaId = this.currentPlayInfo?.assetId as string;
    this.albumImage = this.currentPlayInfo?.mediaImage as image.PixelMap
    if (this.playType === 'local') {
      await this.setLocalMediaInfo();
    } else {
      await this.setRemoteMediaInfo();
    }
    Log.info('playInfoUpdate: done')
  }

  async setRemoteMediaInfo() {
    Log.info('set remote media info: ' + JSON.stringify(this.currentPlayInfo) + ', ' + this.currentIndex);
    let queueItem: avSession.AVQueueItem = {
      itemId: this.currentIndex,
      description: this.currentPlayInfo
    };

    await this.castController?.prepare(queueItem);
    const isPlaying = this.playState === avSession.PlaybackState.PLAYBACK_STATE_PLAY;
    if (isPlaying) {
      await this.castController?.start(queueItem);
      await this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
    }
    if (this.audioType === 'scan') {
      const playMetaData: avSession.AVMetadata = {
        assetId: this.currentPlayInfo?.assetId as string,  // origin assetId
        title: this.currentPlayInfo?.title as string,
        artist: this.currentPlayInfo?.artist as string,
        mediaImage: this.albumImage,  // origin mediaImage
        album: this.currentPlayInfo?.albumTitle as string,
        duration: this.duration,
      };
      Log.info('try set AV Metadata while cast for scan: ' + JSON.stringify(playMetaData));
      this.session?.setAVMetadata(playMetaData);
    }
    Log.info('set remote media info done');
  }

  async setLocalMediaInfo() {
    Log.info('set local media info: ' + JSON.stringify(this.currentPlayInfo));
    if (!this.session) {
      Log.info('set local media info: no session');
      return;
    }
    if (this.audioUtils) {
      const isPlaying = this.playState === avSession.PlaybackState.PLAYBACK_STATE_PLAY;
      this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE, this.currentPlayInfo?.assetId,
        !!this.isFavorMap[this.currentPlayInfo?.assetId as string]);
      Log.info('set play state pause');
      if (this.audioType === 'url' || this.audioType === 'video') {
        await this.audioUtils.loadFromNetwork(this.currentPlayInfo?.mediaUri as string);
      } else if (this.audioType === 'rawfile') {
        await this.audioUtils.loadFromNetwork(this.currentPlayInfo?.mediaUri as string);
      } else if (this.audioType === 'scan') {
        await this.audioUtils.loadFromSrcFd(this.currentPlayInfo?.fdSrc as media.AVFileDescriptor);
      }
      Log.info('local local audio done: ' + isPlaying + ', ' + this.playType + ', ' + this.avPlayer?.state);
      if (isPlaying) {
        this.audioUtils.on('prepared', () => {
          Log.info('AVPlayer state prepare, state play');
          if (this.playType === 'local') {
            this.localPlayOrPause();
          } else {
            this.remotePlayOrPause();
          }
        });
      }
    } else {
      Log.info('set local media fail: no audioUtils');
    }
    this.albumImage = this.currentPlayInfo?.mediaImage as image.PixelMap;
    const playMetaData: avSession.AVMetadata = {
      assetId: this.currentPlayInfo?.assetId as string,  // origin assetId
      title: this.currentPlayInfo?.title as string,
      artist: this.currentPlayInfo?.artist as string,
      mediaImage: this.albumImage,  // origin mediaImage
      album: this.currentPlayInfo?.albumTitle as string,
      duration: this.duration,
    };
    Log.info('try set AV Metadata: ' + JSON.stringify(playMetaData));
    this.session?.setAVMetadata(playMetaData);
    Log.info('set AV Metadata: ');
  }

  aboutToDisappear() {
    Log.info('about to disappear');
    if (this.controller) {
      this.controller.off('outputDeviceChange');
      this.controller.destroy();
    }
    if (this.castController) {
      this.castController?.off('playbackStateChange');
      this.castController?.off('error');
      this.castController?.off('playPrevious');
      this.castController?.off('playNext');
    }
    try {
      if (this.session) {
        this.session?.stopCasting();
        this.session?.destroy();
      }
    } catch (err) {
      Log.info( `err is: ${JSON.stringify(err)}`);
    }
    if (this.avPlayer) {
      this.avPlayer?.release();
    }
    // 使用unregister接口取消订阅
    this.netCon?.unregister((error) => {
      Log.info('error is: ' + JSON.stringify(error));
    })
  }

  async setAudioManager() {
    Log.info('try get audio manger');
    const audioManager = audio.getAudioManager();
    if (!audioManager) {
      Log.error('get audio manager fail: fail get audioManager');
      return;
    }
    this.audioManager = audioManager;
    const volumeManager = audioManager.getVolumeManager();
    if (!volumeManager) {
      Log.error('get audio manager fail: fail get volumeManager');
      return;
    }
    volumeManager.on('volumeChange', (volumeEvent) => {
      Log.info(`VolumeType of stream : ${JSON.stringify(volumeEvent)}`);
      let type: audio.AudioVolumeType = volumeEvent.volumeType;
      let num: number = volumeEvent.volume;
      if(type == audio.AudioVolumeType.MEDIA && this.playType === 'local') {
        this.volume = num / this.localAudioRation;
      }
    });
    this.audioVolumeGroupManager = await volumeManager.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
    if (!this.audioVolumeGroupManager) {
      Log.error('get audio manager fail: fail get audioVolumeGroupManager');
      return;
    }
    const maxVolume = await this.audioVolumeGroupManager.getVolume(audio.AudioVolumeType.MEDIA);
    const minVolume = await this.audioVolumeGroupManager.getVolume(audio.AudioVolumeType.MEDIA);
    const volume = await this.audioVolumeGroupManager.getVolume(audio.AudioVolumeType.MEDIA);
    this.localAudioRation = (maxVolume - minVolume) / 100;
    this.volume = volume / this.localAudioRation;
    Log.info('get audio manager done, ' + maxVolume + ', ' + minVolume + ', ' + this.localAudioRation);
  }

  async setPlayState(state?: number, id?: string, favor?: boolean, elapsedTime?: number) {
    if (!this.session) {
      Log.info('fail set state, session undefined');
      promptAction.showToast({ message: 'No Session' });
      return null;
    }
    const params: avSession.AVPlaybackState = {};
    if (typeof state !== 'undefined') {
      this.playState = state;
      params.state = state;
    }
    if (typeof id !== 'undefined') {
      this.isFavorMap[id] = favor;
      params.isFavorite = favor;
    }
    // 更新播放进度
    if (elapsedTime !== undefined) {
      params.position = {
        elapsedTime: elapsedTime,
        updateTime: new Date().getTime(),
      }
    }
    this.session?.setAVPlaybackState(params);
    Log.info('params test ' + JSON.stringify(params));
    Log.info('isFavorMap test, ' + id + ', ' + JSON.stringify(this.isFavorMap));
    return this.session?.setAVPlaybackState(params);
  }

  async setListenerForMesFromController() {
    Log.info('setListenerForMesFromController');
    this.session?.on('play', () => {
      Log.info('on play, do play test');
      if (this.avPlayer) {
        this.avPlayer?.play();
        this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
      }
    });
    this.session?.on('pause', () => {
      Log.info('on pause, do pause test');
      if (this.avPlayer) {
        this.avPlayer?.pause();
        this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
      }
    });
    this.session?.on('stop', () => {
      Log.info('on stop, do stop test');
      if (this.avPlayer) {
        this.avPlayer?.stop();
        this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_STOP);
      }
    });
    this.session?.on('playPrevious', () => {
      Log.info('on playPrevious, do playPrevious test');
      this.switchToPreviousByLoopMode();
    });
    this.session?.on('playNext', () => {
      Log.info('on playNext, do playNext test');
      this.switchToNextByLoopMode();
    });
    this.session?.on('toggleFavorite', (id) => {
      Log.info('on toggleFavorite session, do toggleFavorite test: ' + id);
      this.setPlayState(undefined, id, !this.isFavorMap[id]);
    });
    // 注册播放快退命令监听
    this.session?.on('rewind', (time?: number) => {
      time = time ? time : 0;
      let currentTime = this.avPlayer ? this.avPlayer.currentTime : 0;
      let timeMs: number = ((currentTime - time * 1000) <= 0) ? 0 : (currentTime - time *1000);
      this.avPlayer?.seek(timeMs);
      Log.info('rewind currentTime ' + timeMs);
      this.avPlayer?.play();
      this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
    });
    // 注册播放快进命令监听
    this.session?.on('fastForward', (time?: number) => {
      time = time ? time : 0;
      let currentTime = this.avPlayer ? this.avPlayer.currentTime : 0;
      let timeMs: number = ((time * 1000 + currentTime) > this.duration) ? this.duration : (time *1000 + currentTime);
      if (time * 1000 + currentTime > this.duration) {
        this.switchToNextByLoopMode();
      } else {
        this.avPlayer?.seek(timeMs);
        this.avPlayer?.play();
        this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
      }
    });
    this.session?.on('seek', (position) => {
      Log.info('on seek: seek test: ' + position);
      // 修改播放进度
      this.avPlayer?.seek(position);
      // 重新设置播放进度
      const params: avSession.AVPlaybackState = {
        position: {
          elapsedTime: position,
          updateTime: new Date().getTime(),
        },
      };
      this.session?.setAVPlaybackState(params);
    });
  }

  async unregisterSessionListener() {
    if (this.session) {
      this.session?.off('play');
      this.session?.off('pause');
      this.session?.off('stop');
      this.session?.off('playNext');
      this.session?.off('playPrevious');
      this.session?.off('seek');
      // 主动销毁已创建的session
      this.session?.destroy((err) => {
        if (err) {
          Log.info(`Destroy BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Log.info('Destroy: SUCCESS ');
        }
      });
    }
  }

  updateVolume(value: number) {
    Log.info('update volume: ' + this.playType + ', ' + value);
    if (this.volume === value) {
      Log.info('update volume: volume not change');
      return;
    }
    this.volume = value;
    if (this.playType === 'cast' && this.castController) {
      this.castController?.sendControlCommand({
        command: 'setVolume',
        parameter: value,
      });
    }
    if (this.playType === 'local' && this.audioManager) {
      Log.info('update local volume: ' + value);
      this.audioManager.setVolume(audio.AudioVolumeType.MEDIA, value * this.localAudioRation);
    }
  }

  async localPlayOrPause() {
    Log.info('start local play or pause' + this.avPlayer?.state);
    if (!this.avPlayer) {
      Log.error('no avplayer');
      return;
    }
    if (this.avPlayer?.state === 'playing') {
      Log.info('start pause');
      await this.avPlayer?.pause();
      await this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
      promptAction.showToast({message: 'pause done'});
    } else if (this.avPlayer?.state === 'stopped') {
      Log.info('start play from stopped');
      await this.avPlayer?.prepare();
      await this.avPlayer?.play();
      await this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
      promptAction.showToast({message: 'play done'});
    } else {
      Log.info('start play from stopped');
      await this.avPlayer?.play();
      await this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
      promptAction.showToast({message: 'play done'});
      Log.info('start play done');
    }
  }

  async remotePlayOrPause() {
    Log.info('start remote play or pause' + this.playState);
    if (!this.castController) {
      Log.error('no castController found');
      return;
    }
    if (this.playState === avSession.PlaybackState.PLAYBACK_STATE_INITIAL
      || this.playState === avSession.PlaybackState.PLAYBACK_STATE_PREPARE) {
      Log.info('start');
      let queueItem: avSession.AVQueueItem = {
        itemId: 0,
        description: this.currentPlayInfo
      };

      await this.castController?.start(queueItem);
      this.playState = avSession.PlaybackState.PLAYBACK_STATE_PLAY;
    } else if (this.playState === avSession.PlaybackState.PLAYBACK_STATE_PLAY) {
      Log.info('pause');
      this.castController?.sendControlCommand({
        command: 'pause',
      })
      this.playState = avSession.PlaybackState.PLAYBACK_STATE_PAUSE;
    } else {
      Log.info('play');
      this.castController?.sendControlCommand({
        command: 'play',
      })
      this.playState = avSession.PlaybackState.PLAYBACK_STATE_PLAY;
    }
  }

  async autoStartAll(needStart: boolean){
    Log.info('try auto start all');
    Log.info('create session');
    this.session = await avSession.createAVSession(getContext(), 'audiotestr', 'video');
    this.session?.setExtras({
      requireAbilityList: ['url-cast'],
    });
    const params: avSession.AVPlaybackState = {
      position: {
        elapsedTime: 0,
        updateTime: new Date().getTime()
      },
    };
    Log.info('try SET SESSION PLAYSTATE');
    this.session?.setAVPlaybackState(params);
    Log.info('create session res: ' + JSON.stringify(this.session));
    if (!this.session) {
      Log.error('fail to create session');
      return;
    }
    Log.info('create controller: ' + this.session?.sessionId);
    this.controller = await this.session?.getController();
    if (!this.controller) {
      Log.error('fail to create controller');
      return;
    }
    Log.info('create controller done: ' + this.controller.sessionId);

    Log.info('add outputDeviceChange listener');
    this.controller.on('outputDeviceChange', async (connectState: avSession.ConnectionState,
                                                    device: avSession.OutputDeviceInfo) => {
      this.outputDeviceInfo = device;
      promptAction.showToast({ message: 'output device changed: ' + connectState });
      if (connectState === avSession.ConnectionState.STATE_CONNECTING) {
        Log.info('connecting');
        return;
      }
      const isPlaying = this.avPlayer && this.avPlayer?.state === 'playing';
      Log.info('outputDeviceChange res: ' + JSON.stringify(device) + '|' + connectState + ',' + isPlaying);
      await this.processDeviceChange(connectState, device);
      Log.info(`process Device Change done, ${this.playType}, ${!!this.castController}`);
      if (this.playType === 'cast' && this.castController) {
        Log.info('prepare remote audio info ' + ', ' + isPlaying);
        const queueItem: avSession.AVQueueItem = {
          itemId: this.currentIndex,
          description: this.currentPlayInfo
        };
        Log.info(`try prepare info, ${JSON.stringify(queueItem)}`);

        await this.castController?.prepare(queueItem);
        if (isPlaying) {

          await this.castController?.start(queueItem);
        }
        await this.castController?.sendControlCommand({
          command: 'setLoopMode',
          parameter: this.currentLoopMode,
        });
      }
      Log.info('output device change processing finished');
    })
    Log.info('add outputDeviceChange Listener done');
    Log.info('try prepare local audio: ' + this.session?.sessionId);
    this.setListenerForMesFromController();
    await this.session?.activate();
    await this.setLocalMediaInfo();
    await this.setPlayState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
    if (needStart) {
      Log.info('start play local');
      setTimeout(() => {
        promptAction.showToast({ message: 'auto start done' });
        this.localPlayOrPause();
      }, 100);
    }
    wantAgent.getWantAgent({
      wants: [
        {
          bundleName: 'com.samples.videoplayer',
          abilityName: 'com.samples.videoplayer.EntryAbility'
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }).then((agent) => {
      this.session?.setLaunchAbility(agent);
    })
  }

  async switchToPreviousByLoopMode(){
    Log.info('switch to previous by loop mode: ' + this.currentLoopMode);
    if (this.currentLoopMode === avSession.LoopMode.LOOP_MODE_SINGLE) {
      this.playInfoUpdated();
      return;
    }
    if (this.currentLoopMode === avSession.LoopMode.LOOP_MODE_SINGLE) {
      const random = Math.floor((Math.random() * 100) + 1);
      const target = random % this.songList.length;
      if (target === this.currentIndex) {
        this.currentIndex = target === 0 ? this.songList.length - 1 : target - 1;
      } else {
        this.currentIndex = target;
      }
      this.updateCurrentPlayInfo(this.songList[this.currentIndex], this.audioType);
      return;
    }
    this.currentIndex = this.currentIndex === 0 ? this.songList.length - 1 : this.currentIndex - 1;
    this.updateCurrentPlayInfo(this.songList[this.currentIndex], this.audioType);
  }

  async switchToNextByLoopMode(){
    Log.info('switch to next by loop mode: ' + this.currentLoopMode);
    if (this.currentLoopMode === avSession.LoopMode.LOOP_MODE_SINGLE) {
      this.playInfoUpdated();
      return;
    }
    if (this.currentLoopMode === avSession.LoopMode.LOOP_MODE_SHUFFLE) {
      const random = Math.floor((Math.random() * 100) + 1);
      const target = random % this.songList.length;
      if (target === this.currentIndex) {
        this.currentIndex = target === this.songList.length - 1 ? 0 : target + 1;
      } else {
        this.currentIndex = target;
      }
      this.updateCurrentPlayInfo(this.songList[this.currentIndex], this.audioType);
      return;
    }
    this.currentIndex = this.currentIndex  === this.songList.length - 1 ? 0 : this.currentIndex + 1;
    this.updateCurrentPlayInfo(this.songList[this.currentIndex], this.audioType);
  }

  async updateCurrentPlayInfo(item: avSession.AVMediaDescription, audioType: string){
    const temp: avSession.AVMediaDescription = {
      assetId: item.assetId,
      title: item.title,
      artist: item.artist,
      mediaType: item.mediaType,
      mediaSize: item.mediaSize,
      startPosition: item.startPosition,
      duration: item.duration,
      mediaImage: item.mediaImage,
      albumTitle: item.albumTitle,
      appName: item.appName,
    };
    if (audioType === 'scan') {
      let fd = 0;
      await fs.open(item.mediaUri).then(async (file) => {
        Log.info('fs res: ' + file?.fd);
        fd = file?.fd
        if (fd != -1 && fd) {
          Log.info('open fd suc: '+ fd);
          temp.fdSrc = {
            fd,
          };
        }
      }).catch((err: BusinessError) => {
        Log.error('start local file cast: ' + JSON.stringify(err));
      })
    } else {
      temp.mediaUri = item.mediaUri;
    }
    this.currentPlayInfo = temp;
  }

  async processDeviceChange(connectState: avSession.ConnectionState, device: avSession.OutputDeviceInfo){
    if (device?.devices?.[0].castCategory === 0 || connectState === avSession.ConnectionState.STATE_DISCONNECTED) {
      this.playType = 'local';
      this.playState = avSession.PlaybackState.PLAYBACK_STATE_PAUSE;
      if (this.audioVolumeGroupManager) {
        const volume = await this.audioVolumeGroupManager.getVolume(audio.AudioVolumeType.MEDIA);
        this.volume = volume / this.localAudioRation;
      }
      await this.setLocalMediaInfo();
      return;
    }
    this.playType = 'cast';
    const isRefresh = !!this.castController;
    this.castController = await this.session?.getAVCastController();
    if (!this.castController) {
      Log.error('fail to get cast controller');
      return;
    }
    let avPlaybackState = await this.castController?.getAVPlaybackState();
    this.playState = avPlaybackState.state || 0;
    if (typeof avPlaybackState?.volume !== 'undefined' && avPlaybackState?.volume >= 0) {
      this.volume = avPlaybackState?.volume;
    }
    if (typeof avPlaybackState?.loopMode !== 'undefined') {
      this.currentLoopMode = avPlaybackState?.loopMode;
    }
    Log.info('get AVPlaybackState res: ' + JSON.stringify(avPlaybackState) + ', ' + isRefresh);
    if (this.avPlayer && this.avPlayer?.state === 'playing') {
      Log.info('stop avplayer');
      this.avPlayer?.stop();
    }
    Log.info('set on playbackStateChange listener: ' + connectState);
    this.castController?.on('playbackStateChange', 'all', (state) => {
      Log.info('play state change: ' + JSON.stringify(state));
      if (typeof state?.state !== 'undefined') {
        this.playState = state?.state;
      }
      if (typeof state?.volume !== 'undefined') {
        this.volume = state?.volume;
      }
      if (typeof state?.loopMode !== 'undefined') {
        this.currentLoopMode = state?.loopMode;
      }
      if (typeof state?.extras?.duration !== 'undefined') {
        this.duration = state?.extras?.duration as number;
      }
      if (typeof state?.position?.elapsedTime !== 'undefined' && !this.isProgressSliding) {
        this.seedPosition = (state?.position?.elapsedTime / this.duration) * 100;
      }
    });
    this.castController?.on('playPrevious', async (state) => {
      Log.info('playPrevious: ' + JSON.stringify(state));
      this.switchToPreviousByLoopMode()
    });
    this.castController?.on('playNext', async (state) => {
      Log.info('playNext: ' + JSON.stringify(state));
      this.switchToNextByLoopMode()
    });
    this.castController?.on('error', (err) => {
      Log.info('on command error: ' + JSON.stringify(err));
      promptAction.showToast({ message: 'error: ' + JSON.stringify(err) });
    });
    Log.info('set on playbackStateChange listener done')
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        // title
        Column() {
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Column() {
              Text($r('app.string.EntryAbility_title'))
                .fontWeight(FontWeight.Normal)
                .fontSize(24)
                .textAlign(TextAlign.Start)
                .width("100%")
                .fontColor(Color.White)
            }
            .width('70%')
            .height(24)

            Button() {
              if (deviceInfo.productModel === 'ohos') {
                Image($r('app.media.ohos_ic_public_cast_stream'))
                  .size({ width: '100%', height: '100%' })
                  .fillColor(Color.White)
                  .backgroundColor(Color.Black)
              } else {
                AVCastPicker({ normalColor: this.avCastPickerColor, activeColor: this.avCastPickerColor })
                  .size({ height: '100%', width: '100%' })
                  .backgroundColor(Color.Black)
                  .align(Alignment.Center);
              }
            }
            .width(24)
            .height(24)
            .backgroundColor(Color.Black)
          }
          .margin({ left: 24, right: 24, top: 12 })
        }
        .width('100%')
        .backgroundColor(Color.Transparent)

        // video
        if (this.playType === 'local') {
          Row() {
            Stack({ alignContent: Alignment.Bottom }) {
              XComponent({ id: '', type: 'surface', controller: this.mXComponentController })
                .onLoad(() => {
                  const surfaceId = this.mXComponentController.getXComponentSurfaceId();
                  Log.info('XComponent onLoad, surfaceId = ' + surfaceId);
                  this.audioUtils.surfaceId = surfaceId;
                })
            }
            .width('100%')
            .height(200)
          }
          .flexShrink(0)
          .width('100%')
        } else {
          Row() {
            Stack({ alignContent: Alignment.Center }) {
              Text($r('app.string.EntryAbility_sink'))
                .fontColor(Color.White)
                .fontSize(28)
            }
            .width('100%')
            .height(200)
            .backgroundColor(Color.Grey)
          }
          .flexShrink(0)
          .width('100%')
        }

        // control
        Row() {
          Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.SpaceAround,
            alignItems: ItemAlign.Center
          }){
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceEvenly,
              alignItems: ItemAlign.Center
            })
            {
              Button() {
                Image($r('app.media.music_last'))
                  .size({ width: '24vp', height: '24vp' })
                  .fillColor(Color.White)
                  .backgroundColor(Color.White)
              }
              .size({
                width: '48vp',
                height: '48vp'
              })
              .backgroundColor(Color.Black)
              .onClick(() => {
                Log.info('click play next');
                this.switchToPreviousByLoopMode();
              })
              .key('music_last')

              Button() {
                Image(this.playState === 2 ? $r('app.media.music_stop') : $r('app.media.music_play'))
                  .size({ width: '24vp', height: '24vp' })
                  .fillColor($r('sys.color.ohos_id_color_primary'))
                  .backgroundColor(Color.White)
              }
              .size({
                width: '48vp',
                height: '48vp'
              })
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                Log.info(`click play/pause:  ${this.playType} ,${this.session}, ${this.controller}`);
                if (!this.session && !this.controller) {
                  this.autoStartAll(true);
                } else if (this.playType === 'local') {
                  this.localPlayOrPause();
                } else {
                  this.remotePlayOrPause();
                }
              })
              .key('music_play_or_pause')

              Button() {
                Image($r('app.media.music_next'))
                  .size({ width: '24vp', height: '24vp' })
                  .fillColor($r('sys.color.ohos_id_color_primary'))
                  .backgroundColor(Color.White)
              }
              .size({
                width: '48vp',
                height: '48vp'
              })
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                Log.info('click play next');
                this.switchToNextByLoopMode();
              })
              .key('music_next')
            }

            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceEvenly,
              alignItems: ItemAlign.Center
            })
            {
              Text(`${CommonUtils.millSecond2Minutes(this.seedPosition / 100 * this.duration)}`)
                .fontWeight(FontWeight.Normal)
                .fontSize(12)
                .textAlign(TextAlign.Start)
                .fontColor('rgba(255,255,255,0.9)')

              Slider({
                value: this.seedPosition,
                min: 0,
                max: 100,
                style: SliderStyle.OutSet
              })
                .trackThickness(4)
                .blockColor('rgba(255,255,255,1)')
                .trackColor('rgba(255,255,255,0.3)')
                .selectedColor('rgba(255,255,255,0.9)')
                .showSteps(false)
                .showTips(false)
                .onChange((value: number, mode: SliderChangeMode) => {
                  Log.info('value: ' + value + 'mode: ' + mode.toString() )
                  if (mode === SliderChangeMode.End) {
                    if (this.playType === 'local') {
                      this.avPlayer?.seek(value / 100 * this.duration);
                      const params: avSession.AVPlaybackState = {
                        position: {
                          elapsedTime: Math.floor(value / 100 * this.duration),
                          updateTime: new Date().getTime(),
                        },
                      };
                      this.session?.setAVPlaybackState(params);
                      Log.info('params.position + ' + JSON.stringify((params.position)))
                    } else {
                      this.castController?.sendControlCommand({
                        command: 'seek',
                        parameter: value / 100 * this.duration,
                      });
                    }
                  }
                  this.seedPosition = value;
                })
                .width('70%')
                .opacity(1)
                .onTouch((event: TouchEvent) => {
                  Log.info('progress touch: ' + event.type)
                  if (event.type === TouchType.Up) {
                    this.sliderTimer = setTimeout(() => {
                      this.isProgressSliding = false;
                    }, 200);
                  } else {
                    clearTimeout(this.sliderTimer);
                    this.isProgressSliding = true;
                  }
                })
              Text(`${CommonUtils.millSecond2Minutes(this.duration)}`)
                .fontWeight(FontWeight.Normal)
                .fontSize(12)
                .textAlign(TextAlign.Start)
                .fontColor('rgba(255,255,255,0.9)')
            }
            .width('100%')
            .height(50)
            .padding({ left: 10, right: 10 })
          }
          .padding({ top: 8 })
        }
        .width('100%')
        .height(150)
        .padding({ bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}



