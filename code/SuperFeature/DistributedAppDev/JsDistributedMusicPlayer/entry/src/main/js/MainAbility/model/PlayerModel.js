/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import fileIO from '@ohos.fileio'
import { logger } from '../model/Logger'

const TAG = 'PlayModel'

export
class Playlist {
  constructor() {
  }

  audioFiles = []
}

export
class Song {
  constructor(name, fileUri, duration) {
    this.name = name
    this.fileUri = fileUri
    this.duration = duration
  }
}

export default class PlayerModel {
  isPlaying = false
  playlist = new Playlist
  index
  #player
  #statusChangedListener
  #playingProgressListener
  #intervalID
  #currentTimeMs = 0

  constructor() {
    this.#player = media.createAudioPlayer()
    this.initAudioPlayer()
    logger.debug(TAG, `createAudioPlayer=${this.#player}`)
  }

  initAudioPlayer() {
    logger.info(TAG, `initAudioPlayer begin`)
    this.#player.on('error', () => {
      logger.error(TAG, `player error`)
    })
    let self = this
    this.#player.on('finish', () => {
      logger.info(TAG, `finish callback is called`)
      self.seek(0)
      self.notifyPlayingStatus(false)
    })
    this.#player.on('timeUpdate', () => {
      logger.info(TAG, `timeUpdate callback is called`)
    })
    logger.info(TAG, `initAudioPlayer end`)
  }

  release() {
    if (typeof (this.#player) !== 'undefined') {
      logger.info(TAG, `player.release begin`)
      this.#player.release()
      logger.info(TAG, `player.release end`)
      this.#player = undefined
    }
  }

  restorePlayingStatus(status, callback) {
    logger.debug(TAG, `restorePlayingStatus ${JSON.stringify(status)}`)
    for (var i = 0; i < this.playlist.audioFiles.length; i++) {
      if (this.playlist.audioFiles[i].fileUri === status.uri) {
        logger.debug(TAG, `restore to index ${i}`)
        this.preLoad(i, () => {
          this.play(status.seekTo, status.isPlaying)
          logger.info(TAG, `restore play status`)
          callback(i)
        })
        return
      }
    }
    logger.warn(TAG, `restorePlayingStatus failed`)
    callback(-1)
  }

  getPlaylist(callback) {
    // generate play list
    logger.info(TAG, `generatePlayList`)
    let self = this
    logger.info(TAG, `getAudioAssets begin`)
    self.playlist = new Playlist()
    self.playlist.audioFiles = []
    self.playlist.audioFiles[0] = new Song('dynamic.wav', 'system/etc/dynamic.wav', 0)
    self.playlist.audioFiles[1] = new Song('demo.wav', 'system/etc/demo.wav', 0)
    callback()
    logger.info(TAG, `getAudioAssets end`)
  }

  setOnStatusChangedListener(callback) {
    this.#statusChangedListener = callback
  }

  setOnPlayingProgressListener(callback) {
    this.#playingProgressListener = callback
  }

  notifyPlayingStatus(isPlaying) {
    this.isPlaying = isPlaying
    this.#statusChangedListener(this.isPlaying)
    logger.info(TAG, `notifyPlayingStatus isPlaying=${isPlaying} intervalId=${this.#intervalID}`)
    if (isPlaying) {
      if (typeof (this.#intervalID) === 'undefined') {
        let self = this
        this.#intervalID = setInterval(() => {
          if (typeof (self.#playingProgressListener) !== "undefined" && self.#playingProgressListener !== null && typeof (self.#player) !== "undefined") {
            var timeMs = self.#player.currentTime
            this.#currentTimeMs = timeMs
            if (typeof (timeMs) === 'undefined') {
              timeMs = 0
            }
            logger.info(TAG, `player.currentTime=${timeMs}`)
            self.#playingProgressListener(timeMs)
          }
        }, 500)
        logger.info(TAG, `set update interval ${this.#intervalID}`)
      }
    } else {
      this.cancelTimer()
    }
  }

  cancelTimer() {
    if (typeof (this.#intervalID) !== 'undefined') {
      logger.info(TAG, `clear update interval ${this.#intervalID}`)
      clearInterval(Number(this.#intervalID))
      this.#intervalID = undefined
    }
  }

  preLoad(index, callback) {
    logger.debug(TAG, `preLoad ${index}/${this.playlist.audioFiles.length}`)
    if (index < 0 || index >= this.playlist.audioFiles.length) {
      logger.error(TAG, `preLoad ignored`)
      return 0
    }
    this.index = index
    let uri = this.playlist.audioFiles[index].fileUri
    fileIO.open(uri, function(err, fdNumber){
      let fdPath = 'fd://'
      let source = fdPath + fdNumber
      logger.debug(TAG, `preLoad source ${source}`)
      if (typeof (source) === 'undefined') {
        logger.error(TAG, `preLoad ignored, source=${source}`)
        return
      }
      logger.debug(TAG, `preLoad ${source} begin state= ${this.#player.state}`)
      let self = this
      if (source === this.#player.src && this.#player.state !== 'idle') {
        logger.info(TAG, `preLoad finished. src not changed`)
        callback()
      } else {
        this.notifyPlayingStatus(false)
        this.cancelTimer()
        logger.info(TAG, `player.reset`)
        self.#player.reset()
        logger.debug(TAG, `player.reset done, state=${self.#player.state}`)
        self.#player.on('dataLoad', () => {
          logger.debug(TAG, `dataLoad callback, state=${self.#player.state}`)
          callback()
        })
        logger.debug(TAG, `player.src=${source}`)
        self.#player.src = source
      }
      logger.debug(TAG, `preLoad ${source} end`)
    }.bind(this))
  }

  getDuration() {
    logger.debug(TAG, `getDuration index=${this.index}`)
    if (this.playlist.audioFiles[this.index].duration > 0) {
      return this.playlist.audioFiles[this.index].duration
    }
    logger.debug(TAG, `getDuration state=${this.#player.state}`)
    this.playlist.audioFiles[this.index].duration = Math.min(this.#player.duration, 97615)
    logger.debug(TAG, `getDuration src=${this.#player.src} duration=${this.playlist.audioFiles[this.index].duration}`)
    return this.playlist.audioFiles[this.index].duration
  }

  getCurrentMs() {
    return this.#currentTimeMs
  }

  play(seekTo, startPlay) {
    logger.debug(TAG, `play seekTo=${seekTo}, startPlay=${startPlay}`)
    this.notifyPlayingStatus(startPlay)
    if (startPlay) {
      if (seekTo < 0 && this.#currentTimeMs > 0) {
        logger.debug(TAG, `pop seekTo=${this.#currentTimeMs}`)
        seekTo = this.#currentTimeMs
      }
      let self = this
      this.#player.on('play', (err, action) => {
        if (err) {
          logger.error(TAG, `error returned in play callback`)
          return
        }
        logger.info(TAG, `play() callback entered, player.state=${self.#player.state}`)
        if (seekTo > 0) {
          self.seek(seekTo)
        }
      })
      logger.info(TAG, `call player.play`)
      this.#player.play()
      logger.debug(TAG, `player.play called player.state=${this.#player.state}`)
    } else if (seekTo > 0) {
      this.#playingProgressListener(seekTo)
      this.#currentTimeMs = seekTo
      logger.debug(TAG, `stash seekTo=${this.#currentTimeMs}`)
    }
  }

  pause() {
    if (!this.isPlaying) {
      logger.debug('MusicPlayer[PlayerModel] pause ignored, isPlaying=' + this.isPlaying)
      return
    }
    this.notifyPlayingStatus(false)
    logger.info('MusicPlayer[PlayerModel] call player.pause')
    this.#player.pause()
    logger.debug('MusicPlayer[PlayerModel] player.pause called, player.state=' + this.#player.state)
  }

  seek(ms) {
    this.#currentTimeMs = ms
    if (this.isPlaying) {
      logger.debug('MusicPlayer[PlayerModel] player.seek ' + ms)
      this.#player.seek(ms)
    } else {
      logger.debug('MusicPlayer[PlayerModel] stash seekTo=' + ms)
    }
  }

  stop() {
    if (!this.isPlaying) {
      logger.debug('MusicPlayer[PlayerModel] stop ignored, isPlaying=' + this.isPlaying)
      return
    }
    this.notifyPlayingStatus(false)
    logger.info('MusicPlayer[PlayerModel] call player.stop')
    this.#player.stop()
    logger.debug('MusicPlayer[PlayerModel] player.stop called, player.state=' + this.#player.state)
  }
}