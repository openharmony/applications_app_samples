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

// @ts-nocheck
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import media from '@ohos.multimedia.media'
import Logger from '../model/Logger'

const TAG = 'myMedia:'

export class myMedia {
  resourceAddress: mediaLibrary.FileAsset = undefined
  fileName: string = undefined
  totalDuration: number = 0
  private playStatus: string
  private playMode: string
  private currentNode: string
  format: string
  mediaType: number
  private media: media.AudioPlayer | media.VideoPlayer
  private surfaceId: string = ''
  private isLoop: boolean
  private audioData: Array<mediaLibrary.FileAsset>
  private videoData: Array<mediaLibrary.FileAsset>
  private fileIndex: number = 0
  private mediaDataLen: number
  private uri:string = undefined
  getAudioData(audioData) {
    this.audioData = audioData
  }

  getVideoData(videoData) {
    this.videoData = videoData
  }

  prev(surfaceId) {
    if (this.fileIndex > 0) {
      this.fileIndex -= 1
    } else {
      this.fileIndex = this.mediaDataLen - 1
    }
    if (this.resourceAddress.mediaType == mediaLibrary.MediaType.AUDIO) {
      this.resourceAddress = this.audioData[this.fileIndex]
      this.init(this.resourceAddress)
    } else if (this.resourceAddress.mediaType == mediaLibrary.MediaType.VIDEO) {
      this.resourceAddress = this.videoData[this.fileIndex]
      this.init(this.resourceAddress, surfaceId)
    }
  }

  next(surfaceId?) {
    if (this.fileIndex < this.mediaDataLen - 1) {
      this.fileIndex += 1
    } else {
      this.fileIndex = 0
    }
    if (this.resourceAddress.mediaType == mediaLibrary.MediaType.AUDIO) {
      this.resourceAddress = this.audioData[this.fileIndex]
      this.init(this.resourceAddress)
    } else if (this.resourceAddress.mediaType == mediaLibrary.MediaType.VIDEO) {
      this.resourceAddress = this.videoData[this.fileIndex]
      this.init(this.resourceAddress, surfaceId)
    }
  }

  getFileIndex(data) {
    data.forEach((file, index) => {
      if (file.id === this.resourceAddress.id) {
        this.fileIndex = index
      }
    })
  }

  getResourceAddress() {
    return this.resourceAddress
  }

  async httpInit(url, surfaceId?) {
    this.uri = url
    if (surfaceId) {
      this.surfaceId = surfaceId.toString()
      Logger.info(TAG, `surfaceId success: ${surfaceId}`)
    }
    await this.stop()
    await this.release()
    this.media = await media.createVideoPlayer()
    await this.setVideoCallBack(this.media)
    this.media.url = url
    await this.media.setDisplaySurface(this.surfaceId).then(() => {
      Logger.info(TAG, `httpInit success`)
    }).catch((error) => {
      Logger.info(TAG, `httpInit setDisplaySurface fali error:${error.message}`)
    })
    await this.media.prepare()
    this.totalDuration = this.media.duration
    this.fileName = 'Http'
    this.media.play()
  }

  async init(resourceAddress: mediaLibrary.FileAsset, surfaceId?) {
    Logger.info(TAG, `init state}`)
    if (surfaceId) {
      this.surfaceId = surfaceId.toString()
      Logger.info(TAG, `surfaceId success: ${surfaceId}`)
    }
    this.stop()
    this.release()
    this.resourceAddress = resourceAddress
    Logger.info(TAG, `resourceAddress success: ${this.resourceAddress}`)
    this.fileName = resourceAddress.displayName
    Logger.info(TAG, `fileName success: ${this.fileName}`)
    this.totalDuration = resourceAddress.duration
    Logger.info(TAG, `totalDuration success: ${this.totalDuration}`)
    this.resourceAddress.open('r').then(async (fd) => {
      Logger.info(TAG, `fd success: ${fd}`)
      if (this.resourceAddress.mediaType == mediaLibrary.MediaType.AUDIO) {
        Logger.info(TAG, `AUDIO success`)
        this.getFileIndex(this.audioData)
        this.mediaDataLen = this.audioData.length
        this.media = media.createAudioPlayer()
        Logger.info(TAG, `AUDIO success: ${this.media}`)
        this.setAudioCallBack(this.media)
        this.media.src = 'fd://' + fd
      } else if (this.resourceAddress.mediaType == mediaLibrary.MediaType.VIDEO) {
        Logger.info(TAG, `VIDEO success`)
        this.getFileIndex(this.videoData)
        this.mediaDataLen = this.videoData.length
        this.media = await media.createVideoPlayer()
        await this.setVideoCallBack(this.media)
        this.media.url = 'fd://' + fd
        await this.media.setDisplaySurface(this.surfaceId)
        await this.media.prepare()
        Logger.info(TAG, `VIDEO end`)
      }
      this.getPlay()
      this.getPlayMode(this.isLoop)
    })
  }

  setAudioCallBack(audioPlayer) {
    audioPlayer.on('dataLoad', () => {
      Logger.info(TAG, `AUDIO case dataLoad called`)
      Logger.info(TAG, `AUDIO audioPlayer.duration : ${audioPlayer.duration}`)
    })
    audioPlayer.on('pause', () => {
      Logger.info(TAG, `AUDIO case pause called`)
    })
    audioPlayer.on('play', () => {
      Logger.info(TAG, `AUDIO case play called`)
    })
    audioPlayer.on('stop', () => {
      Logger.info(TAG, `AUDIO case stop called`)
    })
    audioPlayer.on('finish', () => {
      Logger.info(TAG, `AUDIO case finish called`)
      this.release()
      if(this.resourceAddress && this.resourceAddress.mediaType){
        this.next()
      }
    })
    audioPlayer.on('error', (err) => {
      Logger.info(TAG, ` AUDIO audioPlayer error called : ${err}`)
    })
  }

  setVideoCallBack(videoPlayer) {
    videoPlayer.on('prepare', () => {
      Logger.info(TAG, 'VIDEO start')
      Logger.info(TAG, `VIDEO videoPlayer duration `)
    })

    videoPlayer.on('playing', () => {
      Logger.info(TAG, `VIDEO playing finish`)
    })
    videoPlayer.on('paused', () => {
      Logger.info(TAG, `VIDEO paused finish`)
    })
    videoPlayer.on('stopped', () => {
      Logger.info(TAG, `VIDEO stopped finish`)
    })
    videoPlayer.on('error', (err) => {
      Logger.info(TAG, `VIDEO error : ${err}`)
    })
    videoPlayer.on('playbackCompleted', () => {
      Logger.info(TAG, `VIDEO playbackCompleted finish`)
      this.release()
      if(this.resourceAddress && this.resourceAddress.mediaType){
        this.next()
      }
    })

  }

  setIsLoopCallBack(boole) {
    this.isLoop = boole
  }

  private getPlayStatus() {
    return this.media.state
  }

  getPlayMode(boole) {
    Logger.info(TAG, `getPlayMode state : ${boole}`)
    if (boole) {
      this.media.loop = true
    } else {
      this.media.loop = false
    }
  }

  getPlay() {
    if (typeof (this.media) != 'undefined') {

      Logger.info(TAG, `getPlay success`)
      this.media.play()
    }
  }

  stop() {
    if (typeof (this.media) != 'undefined') {
      this.media.stop()
    }
  }

  release() {
    if (typeof (this.media) != 'undefined') {
      this.media.release()
    }
  }

  reset() {
    if (typeof (this.media) != 'undefined') {
      this.media.reset()
    }
  }

  getPause() {
    if (typeof (this.media) != 'undefined') {
      this.media.pause()
    }
  }

  getCurrentTime() {
    if (typeof (this.media) != 'undefined') {
      return this.media.currentTime
    }
    return 0
  }

  setSpeed(speed) {
    if (typeof (this.media) != 'undefined') {
      this.media.setSpeed(speed, (err) => {
        if (typeof (err) == 'undefined') {
          Logger.info(TAG, `setSpeed success`)
        } else {
          Logger.info(TAG, `setSpeed fail!!`)
        }
      })
    }
  }

  async seek(time) {
    if (typeof (this.media) != 'undefined') {
      await this.media.seek(time)
    }
  }

  getFormat() {
    return this.resourceAddress.mimeType
  }
}