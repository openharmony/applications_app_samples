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

import fileIo from '@ohos.fileio'
import media from '@ohos.multimedia.media'
import Logger from './Logger'

const AUDIO_TIME: number = 10000
const TAG: string = 'AudioPlayer'

export class AudioPlayer {
  async getAudioID(musicSrc: string, delayTime: number) {
    let audio: media.AudioPlayer = media.createAudioPlayer()
    this.setAudio(audio)
    let fdPath = 'fd://'
    let fdValue = await fileIo.open(musicSrc)
    fdPath = fdPath + '' + fdValue
    let audioID: number = setTimeout(function () {
      audio.src = fdPath // Set the src property and trigger the 'dataLoad' event callback
    }, delayTime)
    return audioID
  }

  private setAudio(audio: media.AudioPlayer) {
    audio.on('dataLoad', () => { // Set the 'dataLoad' event callback, which is triggered after the src attribute is set successfully
      Logger.info(TAG, 'audio set source success')
      audio.play() // Call the play method to start playing, triggering the 'play' event callback
    })
    audio.on('play', () => { // Set the 'play' event callback
      Logger.info(TAG, 'audio play success')
      setTimeout(function () {
        audio.stop()
      }, AUDIO_TIME)
    })
    audio.on('stop', () => { // Set the 'stop' event callback
      Logger.info(TAG, 'audio stop success')
      audio.release() // The audioPlayer resource is destroyed
      audio = undefined
    })
  }
}

export default new AudioPlayer()