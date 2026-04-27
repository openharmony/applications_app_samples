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

import { common, wantAgent } from '@kit.AbilityKit';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { MediaTools } from './MediaTools';
import { SongItem } from '../../../viewmodel/SongData';
import Logger from '../Logger';
import { firstSongSinger, firstSongTitle, MusicPlayMode } from '../../constants/PlayerConstants';
import { PreferencesUtil } from '../PreferencesUtil';
import { MediaControlCenter } from './MediaControlCenter';

const TAG = 'AVSessionController';

export class AVSessionController {
  private context: common.UIAbilityContext | undefined = undefined;
  private avSession: avSession.AVSession | undefined = undefined;
  private songList: SongItem[] = [];
  private musicIndex: number | undefined = 0;
  private mediaControlCenter: MediaControlCenter | undefined = undefined;
  private static avSessionController: AVSessionController;
  private isSessionInitialized: boolean = false;

  constructor() {
    let list: SongItem[] | undefined = AppStorage.get('songList');
    if (list) {
      this.songList = list;
    }
  }

  public static getInstance(): AVSessionController {
    if (!AVSessionController.avSessionController) {
      AVSessionController.avSessionController = new AVSessionController();
    }
    return AVSessionController.avSessionController;
  }

  // [Start initAVSession]
  public async initAVSession() {
    if (this.isSessionInitialized && this.avSession) {
      Logger.info(TAG, `session already initialized: sessionId : ${this.avSession.sessionId}`);
      await this.setAVMetadata();
      return;
    }

    this.context = AppStorage.get('context');
    if (!this.context) {
      Logger.info(TAG, `session create failed, conext is undefined`);
      return;
    }
    this.mediaControlCenter = MediaControlCenter.getInstance();
    this.avSession = await avSession.createAVSession(this.context, 'PLAY_AUDIO', 'audio');
    await this.avSession.activate();
    this.isSessionInitialized = true;
    Logger.info(TAG, `session create successed : sessionId : ${this.avSession.sessionId}`);
    await this.setAVMetadata();
    this.setLaunchAbility();
    this.setListenerForMesFromController();
    if (this.musicIndex !== undefined) {
      this.getAndUpdateFavoriteState(this.musicIndex.toString());
    }
  }

  // [End initAVSession]

  // [Start setLaunchAbility]
  // Set LaunchAbility.
  private setLaunchAbility() {
    if (!this.context) {
      return;
    }
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: this.context.abilityInfo.bundleName,
          abilityName: this.context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };
    wantAgent.getWantAgent(wantAgentInfo).then((agent) => {
      if (this.avSession) {
        this.avSession.setLaunchAbility(agent);
      }
    })
      .catch((err: BusinessError) => {
        Logger.error(TAG, `getWantAgent failed: code: ${err.code}, message: ${err.message}`);
      });
  }

  // [End setLaunchAbility]

  private getDuration() {
    let duration: number | undefined = AppStorage.get('totalMsTime');
    if (!duration) {
      Logger.error(TAG, 'get duration failed');
      return;
    }
    return duration;
  }

  // [Start setAVMetadata]
  // Set metadata
  public async setAVMetadata() {
    this.musicIndex = AppStorage.get('selectIndex') ? AppStorage.get('selectIndex') : 0;
    Logger.info(TAG, 'current musicIndex is:' + this.musicIndex);
    if (this.musicIndex === undefined) {
      this.musicIndex = 0;
    }
    try {
      if (this.context) {
        let mediaImage = await MediaTools.getPixelMapFromResource(this.context,
          this.songList[this.musicIndex].label as resourceManager.Resource);
        Logger.info(TAG, 'getPixelMapFromResource success' + JSON.stringify(mediaImage));
        let title = '';
        let artist = '';
        if (this.context) {
          if (this.songList[this.musicIndex].title !== undefined) {
            title = this.context.resourceManager.getStringSync(this.songList[this.musicIndex].title!.id);
          }
          if (this.songList[this.musicIndex].singer !== undefined) {
            artist = this.context.resourceManager.getStringSync(this.songList[this.musicIndex].singer!.id);
          }
        } else {
          title = firstSongTitle;
          artist = firstSongSinger;
        }
        let metadata: avSession.AVMetadata = {
          assetId: `${this.musicIndex}`,
          title: title,
          artist: artist,
          mediaImage: mediaImage,
          duration: this.getDuration(),
          avQueueName: 'OHAudioQueue',
          avQueueId: 'OHAudioQueueQueueId',
          avQueueImage: mediaImage
        };
        let lrc = await MediaTools.getLrcFromRawFile(this.context, this.songList[this.musicIndex].lyric);
        if (lrc) {
          metadata.lyric = lrc;
        }
        if (this.avSession) {
          this.avSession.setAVMetadata(metadata).then(() => {
            Logger.info(TAG, 'SetAVMetadata successfully');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `SetAVMetadata BusinessError: code: ${err.code}, message: ${err.message}`);
          });
        }
      }
    } catch (error) {
      Logger.error(TAG, `SetAVMetadata faile, code: ${(error as BusinessError).code}`);
    }
  }

  // [End setAVMetadata]

  // [Start setListenerForMesFromController]
  // Set listening events
  async setListenerForMesFromController() {
    if (!this.avSession) {
      return;
    }
    this.avSession.on('play', this.onPlay);
    this.avSession.on('pause', this.onPause);
    this.avSession.on('playNext', this.onPlayNext);
    this.avSession.on('playPrevious', this.onPlayPrevious);
    this.avSession.on('seek', this.onSeek);
    this.avSession.on('setLoopMode', this.onSetLoopMode);
    this.avSession.on('toggleFavorite', this.onToggleFavorite);
  }

  // [End setListenerForMesFromController]

  // Set playback listening
  private onPlay: () => void = () => {
    Logger.info(TAG, `on play , do play task`);
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in onPlay');
      return;
    }
    this.mediaControlCenter.play()
  }
  // Set pause listening
  private onPause: () => void = () => {
    Logger.info(TAG, `on pause , do pause task`);
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in onPause');
      return;
    }
    this.mediaControlCenter.pause();
  }
  // Set play next song listening.
  private onPlayNext: () => void = () => {
    Logger.info(TAG, `on playNext , do playNext task`);
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in onPlayNext');
      return;
    }
    this.mediaControlCenter.playNext();
  }
  // Set play previous song listening.
  private onPlayPrevious: () => void = () => {
    Logger.info(TAG, `on playPrevious , do playPrevious task`);
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in onPlayPrevious')
      return;
    }
    this.mediaControlCenter.playPrevious();
  }
  // Set seek listening.
  private onSeek: (curMs: number) => void = (curMs: number) => {
    Logger.info(TAG, `on seek , do seek task`);
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in onSeek');
      return;
    }
    this.mediaControlCenter.seek(curMs);
  }
  // Set set loopMode listening.
  private onSetLoopMode: (loopMode: avSession.LoopMode) => void = (loopMode: avSession.LoopMode) => {
    Logger.info(TAG, `on setLoopMode , do loopMode task`);
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in onSetLoopMode');
      return;
    }
    switch (loopMode) {
      case avSession.LoopMode.LOOP_MODE_SINGLE:
        this.mediaControlCenter.setPlayModel(MusicPlayMode.ORDER);
        break;
      case avSession.LoopMode.LOOP_MODE_SEQUENCE:
        this.mediaControlCenter.setPlayModel(MusicPlayMode.RANDOM);
        break;
      case avSession.LoopMode.LOOP_MODE_SHUFFLE:
        this.mediaControlCenter.setPlayModel(MusicPlayMode.SINGLE_CYCLE);
        break;
      default:
        break;
    }
  }
  // Set favorite state listening.
  private onToggleFavorite: (assetId: string) => void = (assetId: string) => {
    Logger.info(TAG, `on toggleFavorite , do toggleFavorite task`);
    let isFavorite: boolean | undefined = AppStorage.get('isFavorite');
    this.updateFavoriteState(assetId, isFavorite ? !isFavorite : true);
  }

  // Set play mode listening.
  public setPlayModeToAVSession(currentPlayMode: MusicPlayMode) {
    if (!this.mediaControlCenter) {
      Logger.error(TAG, 'mediaControlFunction is undefined in setPlayModeToAVSession');
      return;
    }
    let avSessionLoopMode: avSession.LoopMode = avSession.LoopMode.LOOP_MODE_SEQUENCE;
    switch (currentPlayMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        avSessionLoopMode = avSession.LoopMode.LOOP_MODE_SINGLE;
        break;
      case MusicPlayMode.ORDER:
        avSessionLoopMode = avSession.LoopMode.LOOP_MODE_SEQUENCE;
        break;
      case MusicPlayMode.RANDOM:
        avSessionLoopMode = avSession.LoopMode.LOOP_MODE_SHUFFLE;
        break;
      default:
        break;
    }
    this.setLoopModeState(avSessionLoopMode);
  }

  // [Start setPlayState]
  // Set favorite state.
  private setFavoriteState(isFavorite: boolean) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({ isFavorite }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `setFavoriteState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'setFavoriteState successfully');
        }
      });
    }
  }

  // Set progress state.
  public setProgressState(ms: number) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({
        position: {
          elapsedTime: ms,
          updateTime: new Date().getTime()
        }
      }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `setProgressState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'setProgressState successfully');
        }
      });
    }
  }

  // Set play state.
  public setPlayState(isPlay: boolean) {
    if (!this.avSession) {
      Logger.error(TAG, 'avSession is undefined');
      return;
    }
    this.avSession.setAVPlaybackState({
      state: isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
    }, (err: BusinessError) => {
      if (err) {
        Logger.error(TAG, `setPlayState BusinessError: code: ${err.code}, message: ${err.message}`);
      } else {
        Logger.info(TAG, 'setPlayState successfully');
      }
    });
  }
  // [End setPlayState]

  public async updateFavoriteState(assetId: string, isFavorite: boolean) {
    if (!this.context) {
      return;
    }
    PreferencesUtil.getInstance().preferencesPut(assetId, isFavorite);
    AppStorage.setOrCreate('isFavorite', isFavorite);
    this.setFavoriteState(isFavorite);
  }

  public async getAndUpdateFavoriteState(assetId: string) {
    let isFavorite = false;
    if (!this.context) {
      return;
    }
    let isHas: boolean = PreferencesUtil.getInstance().preferencesHas(assetId);
    Logger.info(TAG, `isHas: ${isHas}, assetId:${assetId}`)
    if (isHas) {
      isFavorite = PreferencesUtil.getInstance().getValue(assetId) as boolean;
      Logger.info(TAG, `isFavorite: ${isFavorite}`)
    }
    AppStorage.setOrCreate('isFavorite', isFavorite);
    this.setFavoriteState(isFavorite);
  }

  // Set loopMode state.
  public async setLoopModeState(avSessionLoopMode: avSession.LoopMode) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({ loopMode: avSessionLoopMode }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `setLoopModeState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'setLoopModeState successfully');
        }
      });
    }
  }

  async unregisterSessionListener() {
    if (!this.avSession) {
      return;
    }
    this.avSession.off('play');
    this.avSession.off('pause');
    this.avSession.off('playNext');
    this.avSession.off('playPrevious');
    this.avSession.off('setLoopMode');
    this.avSession.off('seek');
    this.avSession.off('toggleFavorite');
    this.avSession.destroy();
  }
}
