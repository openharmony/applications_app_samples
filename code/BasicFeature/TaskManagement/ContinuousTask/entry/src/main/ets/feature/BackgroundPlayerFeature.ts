/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import media from '@ohos.multimedia.media'
import fileIo from '@ohos.fileio'
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
  public playerIndex: number
  public player: media.AudioPlayer
  public statusChangedListener
  public playingProgressListener
  public intervalID = undefined
  public currentTimeMs: number = 0 // Current time

  constructor() {
    Logger.info(TAG, `createAudioPlayer start`)
    this.player = media.createAudioPlayer()
    Logger.info(TAG, `createAudioPlayer end and initAudioPlayer`)
    this.initAudioPlayer()
    Logger.info(TAG, `createAudioPlayer= ${this.player}`)
  }

  initAudioPlayer(): void {
    Logger.info(TAG, 'initAudioPlayer begin')
    this.player.on('error', () => {
      Logger.error(TAG, `player error`)
    })
    this.player.on('finish', () => {
      Logger.info(TAG, `finish() callback is called`)
      this.seekTimeMs(0)
      this.notifyPlayingStatus(false)
    })
    this.player.on('timeUpdate', () => {
      Logger.info(TAG, `timeUpdate() callback is called`)
    })
    Logger.info(TAG, `initAudioPlayer end`)
  }

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

  setOnStatusChangedListener(callback: (isPlay: boolean) => void): void {
    this.statusChangedListener = callback
  }

  setOnPlayingProgressListener(callback: (currentTimeMs: number) => void): void {
    this.playingProgressListener = callback
  }

  // notify status
  notifyPlayingStatus(isPlaying: boolean): void {
    this.isPlaying = isPlaying
    this.statusChangedListener(this.isPlaying)
    Logger.info(TAG, `notifyPlayingStatus isPlaying= ${isPlaying} intervalId= ${this.intervalID}`)
    if (isPlaying) {
      if (typeof (this.intervalID) === 'undefined') {
        this.intervalID = setInterval(() => {
          if (typeof (this.playingProgressListener)) {
            let timeMs = this.player.currentTime
            this.currentTimeMs = timeMs
            if (typeof (timeMs) === 'undefined') {
              timeMs = 0
            }
            Logger.info(TAG, `player.currentTime= ${timeMs}`)
            this.playingProgressListener(timeMs)
          }
        }, 500)
        Logger.info(TAG, `set update interval ${this.intervalID}`)
      }
    } else {
      this.cancelTimer()
    }
  }

  cancelTimer(): void {
    if (typeof (this.intervalID) !== 'undefined') {
      Logger.info(TAG, `clear update interval ${this.intervalID}`)
      clearInterval(this.intervalID)
      this.intervalID = undefined
    }
  }

  preLoad(index: number, callback: () => void): number {
    Logger.info(TAG, `preLoad ${index}/${this.playlist.audioFiles.length}`)
    if (index < 0 || index >= this.playlist.audioFiles.length) {
      Logger.error(TAG, `preLoad ignored`)
      return 0
    }
    this.playerIndex = index
    let uri = this.playlist.audioFiles[index].fileUri
    fileIo.open(uri, (err, fdNumber) => {
      let fdPath = 'fd://'
      let source = fdPath + fdNumber
      Logger.info(TAG, `preLoad source ${source}`)
      if (typeof (source) === 'undefined') {
        Logger.error(TAG, `preLoad ignored source= ${source}`)
        return
      }
      Logger.info(TAG, `preLoad ${source} begin`)
      Logger.info(TAG, `state= ${this.player.state}`)

      if (source === this.player.src && this.player.state !== 'idle') {
        Logger.info(TAG, `preLoad finished. src not changed`)
        callback()
      } else {
        this.notifyPlayingStatus(false)
        this.cancelTimer()
        Logger.info(TAG, `player.reset`)
        this.player.reset()
        Logger.info(TAG, `player.reset done, state= ${this.player.state}`)
        this.player.on('dataLoad', () => {
          Logger.info(TAG, `dataLoad callback, state= ${this.player.state}`)
          callback()
        })
        Logger.info(TAG, `player.src= ${source}`)
        this.player.src = source
      }
      Logger.info(TAG, `preLoad ${source} end`)
    })
  }

  getDuration(): number {
    Logger.info(TAG, `getDuration playerIndex= ${this.playerIndex}`)
    if (this.playlist.audioFiles[this.playerIndex].duration > 0) {
      return this.playlist.audioFiles[this.playerIndex].duration
    }
    Logger.info(TAG, `getDuration state= ${this.player.state}`)
    this.playlist.audioFiles[this.playerIndex].duration = Math.min(this.player.duration, 97615) // 97615表示预置时间
    Logger.info(TAG, `getDuration player.src= ${this.player.src} player.duration= ${this.playlist.audioFiles[this.playerIndex].duration} `)
    return this.playlist.audioFiles[this.playerIndex].duration
  }

  getCurrentMs(): number {
    return this.currentTimeMs
  }

  playMusic(seekTo: number, startPlay: boolean): void {
    Logger.info(TAG, `playMusic seekTo= ${seekTo} startPlay= ${startPlay}`)
    this.notifyPlayingStatus(startPlay)
    if (startPlay) {
      if (seekTo < 0 && this.currentTimeMs > 0) {
        Logger.info(TAG, `pop seekTo= ${this.currentTimeMs}`)
        seekTo = this.currentTimeMs
      }
      let player: PlayerModel = new PlayerModel()
      this.player.on('play', () => {
        Logger.info(TAG, `play() callback entered, player.state= ${player.player.state}`)
        if (seekTo > 0) {
          player.seekTimeMs(seekTo)
        }
      })
      this.player.play()
      Logger.info(TAG, `player.play called player.state= ${this.player.state}`)
    } else if (seekTo > 0) {
      this.playingProgressListener(seekTo)
      this.currentTimeMs = seekTo
      Logger.info(TAG, `stash seekTo= ${this.currentTimeMs}`)
    }
  }

  pauseMusic(): boolean {
    if (!this.isPlaying) {
      Logger.info(TAG, `pauseMusic ignored, isPlaying= ${this.isPlaying}`)
      return
    }
    this.notifyPlayingStatus(false)
    Logger.info(TAG, `call player.pauseMusic`)
    this.player.pause()
    Logger.info(TAG, `player.pause called, player.state= ${this.player.state}`)
  }

  seekTimeMs(time: number): void {
    this.currentTimeMs = time
    if (this.isPlaying) {
      Logger.info(TAG, `player.seek= ${time}`)
      this.player.seek(time)
    } else {
      Logger.info(TAG, `stash seekTo= ${time}`)
    }
  }

  stopMusic(): boolean {
    if (!this.isPlaying) {
      Logger.info(TAG, `stopMusic ignored, isPlaying= ${this.isPlaying}`)
      return
    }
    this.notifyPlayingStatus(false)
    Logger.info(TAG, `call player.stop`)
    this.player.stop()
    Logger.info(TAG, `player.stop called, player.state= ${this.player.state}`)
  }
}

export default new PlayerModel()