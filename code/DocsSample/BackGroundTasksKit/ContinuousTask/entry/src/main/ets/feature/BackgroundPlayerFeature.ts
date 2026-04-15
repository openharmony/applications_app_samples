/*
 * Copyright (c) 2023-2026 Huawei Device Co., Ltd.
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

import { avSession } from '@kit.AVSessionKit';
import { common } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit'
import { fileIo } from '@kit.CoreFileKit'
import Logger from '../util/Logger'
import { SONG_List } from '../mock/BackgroundPlayerData'

const TAG: string = 'BackgroundPlayerFeature'

class PlayList {
  public audioFiles: Array<Song> = []
}

class Song {
  public name: string
  public fileUri: string
  public duration: number

  constructor(name, fileUri, duration) {
    this.name = name
    this.fileUri = fileUri
    this.duration = duration
  }
}

class PlayerModel {
  public isPlaying: boolean = false
  public playlist: PlayList = new PlayList()
  public playerIndex: number = 0;
  public player: media.AVPlayer
  public avSession: avSession.AVSession

  constructor() {
    Logger.info(TAG, `createAVPlayer start`)
    media.createAVPlayer().then((player: media.AVPlayer) => {
      Logger.info(TAG, `createAVPlayer end and initAVPlayer`)
      this.player = player
      this.initAVPlayer()
      Logger.info(TAG, `createAVPlayer= ${this.player}`)
    }).catch((err: Error) => {
      Logger.error(TAG, `createAVPlayer failed: ${err.message}`)
    })
  }

  initAVPlayer(): void {
    Logger.info(TAG, 'initAVPlayer begin')
    this.player.on('error', (err: Error) => {
      Logger.error(TAG, `player error: ${err.message}`)
    })
    this.player.on('stateChange', (state: string) => {
      Logger.info(TAG, `stateChange() callback is called, state: ${state}`)
    })
    this.player.on('seekDone', (time: number) => {
      Logger.info(TAG, `seekDone() callback is called, time: ${time}`)
    })
    Logger.info(TAG, `initAVPlayer end`)
  }

  createAVSession(context: common.UIAbilityContext): void {
    Logger.debug(TAG, 'createAVSession begin');
    try {
      avSession.createAVSession(context, 'player', 'audio').then((data) => {
        Logger.debug(TAG, 'createAVSession succeed');
        this.avSession = data;
      }).catch((err: Error) => {
        Logger.error(TAG, `createAVSession failed: ${err.message}`);
      });
    } catch (error) {
      Logger.error(TAG, `createAVSession exception: ${(error as Error).message}`);
    }
  };

  destroyAVSession(): void {
    Logger.debug(TAG, 'destroyAVSession begin');
    try {
      this.avSession?.destroy().catch((err: Error) => {
        Logger.error(TAG, `destroyAVSession failed: ${err.message}`);
      });
    } catch (error) {
      Logger.error(TAG, `destroyAVSession exception: ${(error as Error).message}`);
    }
  };

  getPlaylist(callback: () => void): void {
    // generate play list
    Logger.info(TAG, `getAudioAssets begin`)
    this.playlist = new PlayList()
    this.playlist.audioFiles = []
    this.playlist.audioFiles[0] = new Song(SONG_List[0].name, SONG_List[0].fileUri, SONG_List[0].duration)
    this.playlist.audioFiles[1] = new Song(SONG_List[1].name, SONG_List[1].fileUri, SONG_List[1].duration)
    callback()
    Logger.info(TAG, `getAudioAssets end`)
  }

  preLoad(index: number, callback: () => void): number {
    Logger.info(TAG, `preLoad ${index}/${this.playlist.audioFiles.length}`)
    if (index < 0 || index >= this.playlist.audioFiles.length) {
      Logger.error(TAG, `preLoad ignored`)
      return 0
    }
    if (!this.player) {
      Logger.error(TAG, `preLoad ignored, player not initialized`)
      return 0
    }
    this.playerIndex = index
    let uri = this.playlist.audioFiles[index].fileUri
    fileIo.open(uri, (err, fdNumber) => {
      if (err) {
        Logger.error(TAG, `preLoad open file error: ${err.message}`)
        return
      }
      let fdPath = 'fd://'
      let source = fdPath + fdNumber
      Logger.info(TAG, `preLoad source ${source}`)
      if (typeof (source) === 'undefined') {
        Logger.error(TAG, `preLoad ignored source= ${source}`)
        return
      }
      Logger.info(TAG, `preLoad ${source} begin`)
      Logger.info(TAG, `state= ${this.player.state}`)

      if (source === this.player.url && this.player.state !== 'idle') {
        Logger.info(TAG, `preLoad finished. url not changed`)
        callback()
      } else {
        Logger.info(TAG, `player.reset`)
        this.player.reset().then(() => {
          Logger.info(TAG, `player.reset done, state= ${this.player.state}`)
          this.player.url = source
          this.player.on('stateChange', (state: string) => {
            if (state === 'prepared') {
              Logger.info(TAG, `dataLoad callback, state= ${this.player.state}`)
              callback()
            }
          })
        }).catch((err: Error) => {
          Logger.error(TAG, `player.reset failed: ${err.message}`)
        })
      }
      Logger.info(TAG, `preLoad ${source} end`)
    })
    return 0
  }

  getDuration(): number {
    Logger.info(TAG, `getDuration playerIndex= ${this.playerIndex}`)
    if (!this.player) {
      return 0
    }
    if (this.playlist.audioFiles[this.playerIndex].duration > 0) {
      return this.playlist.audioFiles[this.playerIndex].duration
    }
    Logger.info(TAG, `getDuration state= ${this.player.state}`)
    this.playlist.audioFiles[this.playerIndex].duration = Math.min(this.player.duration, 97615)
    Logger.info(TAG, `getDuration player.url= ${this.player.url} player.duration= ${this.playlist.audioFiles[this.playerIndex].duration} `)
    return this.playlist.audioFiles[this.playerIndex].duration
  }

  playMusic(flag: number, startPlay: boolean, context: common.UIAbilityContext): void {
    Logger.info(TAG, `playMusic flag= ${flag} startPlay= ${startPlay}`);
    if (!this.player) {
      Logger.error(TAG, `playMusic ignored, player not initialized`)
      return
    }
    if (startPlay) {
      this.player.play().then(() => {
        Logger.info(TAG, `player.play called player.state= ${this.player.state}`);
      }).catch((err: Error) => {
        Logger.error(TAG, `player.play failed: ${err.message}`)
      })
      this.createAVSession(context);
    }
  }

  pauseMusic(): void {
    if (!this.isPlaying) {
      Logger.info(TAG, `pauseMusic ignored, isPlaying= ${this.isPlaying}`)
      return
    }
    if (!this.player) {
      Logger.error(TAG, `pauseMusic ignored, player not initialized`)
      return
    }
    Logger.info(TAG, `call player.pauseMusic`)
    this.player.pause().then(() => {
      Logger.info(TAG, `player.pause called, player.state= ${this.player.state}`)
    }).catch((err: Error) => {
      Logger.error(TAG, `player.pause failed: ${err.message}`)
    })
  }

  stopMusic(): void {
    if (!this.isPlaying) {
      Logger.info(TAG, `stopMusic ignored, isPlaying= ${this.isPlaying}`);
      return;
    }
    if (!this.player) {
      Logger.error(TAG, `stopMusic ignored, player not initialized`)
      return
    }
    Logger.info(TAG, 'call player.stop');
    this.player.stop().then(() => {
      this.destroyAVSession();
      Logger.info(TAG, `player.stop called, player.state= ${this.player.state}`);
    }).catch((err: Error) => {
      Logger.error(TAG, `player.stop failed: ${err.message}`)
    })
  };
}

export default new PlayerModel()