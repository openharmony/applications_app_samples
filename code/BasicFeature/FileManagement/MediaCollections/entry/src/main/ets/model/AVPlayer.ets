/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { BusinessError } from '@ohos.base'
import media from '@ohos.multimedia.media'
import audio from '@ohos.multimedia.audio'
import common from '@ohos.app.ability.common'
import Logger from '../model/Logger'
import DrmController, { drmInfo } from './DrmController'

const TAG = 'AVPlayer'

export class AVPlayer {
  resourceAddress: mediaLibrary.FileAsset = {} as mediaLibrary.FileAsset
  fileName: string = ''
  totalDuration: number = 0
  format: string = ''
  mediaType: number = 0
  ratio: number = 1.0
  isProgressMoving: boolean = false
  isLoading: boolean = false
  private media: media.AVPlayer = {} as media.AVPlayer
  private surfaceId: string = ''
  private isLoop: boolean = true
  private audioData: mediaLibrary.FileAsset[] = []
  private videoData: mediaLibrary.FileAsset[] = []
  private fileIndex: number = 0
  private mediaDataLen: number = 0
  private isVideo: boolean = true
  private isHttp: boolean = false
  private callbackComplete: () => void = () => {
  }
  private callbackTimeUpdate: (nol: number) => void = (nol: number) => {
  }
  private callbackBitrateUpdate: (bitrateList: number[]) => void = (bitrateList: number[]) => {
  }
  private callbackErrorUpdate: (error: string) => void = (error: string) => {
  }
  private fd: number = 0
  private fileDescriptor: media.AVFileDescriptor = {} as media.AVFileDescriptor
  private isCreate: boolean = false
  private context: Context = getContext(this) as common.UIAbilityContext
  // drm variable
  private drmController: DrmController = new DrmController()
  private drmUrl: string = ''
  private drmLicenseUrl: string = ''
  private drmInfoFirstUpdate: boolean = false

  getAudioData(audioData: mediaLibrary.FileAsset[]) {
    this.audioData = audioData
  }

  getVideoData(videoData: mediaLibrary.FileAsset[]) {
    this.videoData = videoData
  }

  setCompleteCallback(func: () => void) {
    this.callbackComplete = func
  }

  setTimeUpdateCallback(func: (nol: number) => void) {
    this.callbackTimeUpdate = func
  }

  setBitrateUpdateCallback(func: (bitrateList: number[]) => void) {
    this.callbackBitrateUpdate = func
  }

  setErrorCallback(func: (error: string) => void) {
    this.callbackErrorUpdate = func
  }

  async prev(surfaceId: string) {
    this.isHttp = false
    if (this.fileIndex > 0) {
      this.fileIndex -= 1
    } else {
      this.fileIndex = this.mediaDataLen - 1
    }
    await this.media.reset()
    await this.resourceAddress.close(this.fd)
    if (this.resourceAddress.mediaType == mediaLibrary.MediaType.AUDIO) {
      this.resourceAddress = this.audioData[this.fileIndex]
      this.isVideo = false
      this.playNext(this.resourceAddress)
    } else if (this.resourceAddress.mediaType == mediaLibrary.MediaType.VIDEO) {
      this.resourceAddress = this.videoData[this.fileIndex]
      this.isVideo = true
      this.playNext(this.resourceAddress)
    }
  }

  async next(surfaceId?: string) {
    this.isHttp = false
    if (this.fileIndex < this.mediaDataLen - 1) {
      this.fileIndex += 1
    } else {
      this.fileIndex = 0
    }
    await this.media.reset()
    await this.resourceAddress.close(this.fd)
    if (this.resourceAddress.mediaType == mediaLibrary.MediaType.AUDIO) {
      this.resourceAddress = this.audioData[this.fileIndex]
      this.isVideo = false
      this.playNext(this.resourceAddress)
    } else if (this.resourceAddress.mediaType == mediaLibrary.MediaType.VIDEO) {
      this.resourceAddress = this.videoData[this.fileIndex]
      this.isVideo = true
      this.playNext(this.resourceAddress)
    }
  }

  async playNext(fileAsset: mediaLibrary.FileAsset) {
    this.resourceAddress = fileAsset
    this.fileName = fileAsset.displayName
    this.totalDuration = fileAsset.duration
    this.fd = await this.resourceAddress.open('r')
    if (this.getPlayStatus() === 'idle') {
      this.media.url = `fd://${this.fd}`
    } else {
      Logger.info(TAG, 'this state is noe idle')
    }
  }

  getFileIndex(data: mediaLibrary.FileAsset[]) {
    data.forEach((file: mediaLibrary.FileAsset, index: number) => {
      if (file.id === this.resourceAddress.id) {
        this.fileIndex = index
      }
    })
  }

  getResourceAddress() {
    return this.resourceAddress
  }

  async drmInit(surfaceId: string, drmTitle: string, drmUrl: string, drmLicenseUrl: string) {
    this.isHttp = true
    this.surfaceId = surfaceId.toString()
    await this.release()
    this.media = await media.createAVPlayer()
    this.isCreate = true
    this.setSourceInfo()
    this.setStateChangeCallback()
    this.media.url = drmUrl
    this.drmUrl = drmUrl
    this.drmLicenseUrl = drmLicenseUrl
    this.fileName = drmTitle
  }

  async httpInit(url: string, surfaceId?: string) {
    this.isHttp = true;
    this.isVideo = true;
    if (surfaceId) {
      this.surfaceId = surfaceId.toString()
      Logger.info(TAG, `surfaceId success: ${surfaceId}`)
    }
    await this.release()
    this.media = await media.createAVPlayer()
    this.isCreate = true
    this.setSourceInfo()
    this.setStateChangeCallback()
    this.media.url = url
  }

  async openFileDescriptor(name: string): Promise<media.AVFileDescriptor> {
    let fileDescriptor: media.AVFileDescriptor
    let rawFileDes = await this.context.resourceManager.getRawFd(name)
    fileDescriptor = { fd: rawFileDes.fd, offset: rawFileDes.offset, length: rawFileDes.length }
    Logger.info(TAG, 'getRawFileDescriptor success fileName: ' + name)
    Logger.info(TAG, 'getRawFileDescriptor success fd: ' + fileDescriptor.fd)
    Logger.info(TAG, 'getRawFileDescriptor success offset: ' + fileDescriptor.offset)
    Logger.info(TAG, 'getRawFileDescriptor success length: ' + fileDescriptor.length)
    return fileDescriptor
  }

  async fdSrcInit(url: string, surfaceId?: string): Promise<void> {
    Logger.info(TAG, 'play fdSrc,source is:' + url)
    this.isHttp = false
    this.isVideo = false
    // 判断是否传入surfaceID
    if (surfaceId) {
      this.isVideo = true
      this.surfaceId = surfaceId.toString()
      Logger.info(TAG, `surfaceId success: ${surfaceId}`)
    }
    await this.release()
    this.fileName = url
    this.fileDescriptor = await this.openFileDescriptor(url)
    this.media = await media.createAVPlayer()
    this.isCreate = true
    this.setSourceInfo()
    this.setStateChangeCallback()
    this.media.fdSrc = this.fileDescriptor
  }

  async init(resourceAddress: mediaLibrary.FileAsset, surfaceId?: string) {
    this.isHttp = false
    Logger.info(TAG, `init state`)
    this.isVideo = false
    // 判断是否传入surfaceID
    if (surfaceId) {
      this.isVideo = true
      this.surfaceId = surfaceId.toString()
      Logger.info(TAG, `surfaceId success: ${surfaceId}`)
    }
    // 如果已经存在avplayer实例对象则释放该对象重新创建
    await this.release()
    this.resourceAddress = resourceAddress
    Logger.info(TAG, `resourceAddress success: ${this.resourceAddress}`)
    this.fileName = resourceAddress.displayName
    Logger.info(TAG, `fileName success: ${this.fileName}`)
    this.totalDuration = resourceAddress.duration
    Logger.info(TAG, `totalDuration success: ${this.totalDuration}`)
    // 获取待播放的fd地址
    this.resourceAddress.open('r').then(async (fd: number) => {
      Logger.info(TAG, `fd success: ${fd}`)
      this.fd = fd
      if (this.resourceAddress.mediaType == mediaLibrary.MediaType.AUDIO) {
        Logger.info(TAG, `AUDIO success`)
        this.getFileIndex(this.audioData)
        this.mediaDataLen = this.audioData.length
      } else if (this.resourceAddress.mediaType == mediaLibrary.MediaType.VIDEO) {
        this.getFileIndex(this.videoData)
        this.mediaDataLen = this.videoData.length
      }
      this.media = await media.createAVPlayer()
      this.isCreate = true
      this.setSourceInfo()
      this.setStateChangeCallback()
      this.ratio = this.resourceAddress.width / this.resourceAddress.height
      Logger.info(TAG, `VIDEO success this.ratio` + this.ratio)
      this.media.url = `fd://${this.fd}`
    })
  }

  // 获取轨道信息接口
  async getTrackDescription(): Promise<void> {
    await this.media.getTrackDescription().then((arrayList: media.MediaDescription[]) => {
      for (let i = 0; i < arrayList.length; i++) {
        for (let j = 0; j < arrayList[i].length; j++) {
          let property = arrayList[i][j]
          Logger.info(TAG, 'case key is  ' + j)
          Logger.info(TAG, 'case value is  ' + property)
        }
      }
    })
    Logger.info(TAG, 'getTrackDescription end')
  }

  // 视频信息上报函数
  async setSourceInfo(): Promise<void> {
    // drmInfo 更新回调
    this.media.on('drmInfoUpdate', (drmInfo: Object[]) => {
      const drmInfoArr: drmInfo[] = drmInfo as drmInfo[]
      this.drmPlayProcess(drmInfoArr)
    })
    // 时间上报函数
    this.media.on('timeUpdate', (time: number) => {
      Logger.info(TAG, 'timeUpdate called: time is :' + time)
      Logger.info(TAG, 'timeUpdate called: currentTime is :' + this.media.currentTime)
      this.callbackTimeUpdate(time)
    })
    // 音量变化回调函数
    this.media.on('volumeChange', (vol: number) => {
      Logger.info(TAG, 'volumeChange success,and new volume is :' + vol)
    })
    // 视频播放结束触发回调
    this.media.on('endOfStream', () => {
      Logger.info(TAG, 'endOfStream success')
    })
    // seek操作回调函数
    this.media.on('seekDone', (seekDoneTime: number) => {
      Logger.info(TAG, 'seekDone success,and seek time is:' + seekDoneTime)
    })
    // 视频总时长上报函数
    this.media.on('durationUpdate', (duration: number) => {
      Logger.info(TAG, 'durationUpdate success,and durationUpdate is:' + duration)
    })
    // 设置倍速播放回调函数
    this.media.on('speedDone', (speed: number) => {
      Logger.info(TAG, 'speedDone success,and speed value is:' + speed)
    })
    // bitrate设置成功回调函数
    this.media.on('bitrateDone', (bitrate: number) => {
      Logger.info(TAG, 'bitrateDone success,and bitrate value is:' + bitrate)
    })
    // 缓冲上报回调函数
    this.media.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      Logger.info(TAG, 'bufferingUpdate success,and infoType value is:' + infoType + ', value is :' + value)
    })
    // 首帧上报回调函数
    this.media.on('startRenderFrame', () => {
      Logger.info(TAG, 'startRenderFrame success 1')
    })
    // 视频宽高上报回调函数
    this.media.on('videoSizeChange', (width: number, height: number) => {
      Logger.info(TAG, 'videoSizeChange success,and width is:' + width + ', height is :' + height)
    })
    // 焦点上报回调函数
    this.media.on('audioInterrupt', (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      Logger.info(TAG, 'audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info))
    })
    // HLS上报所有支持的比特率
    this.media.on('availableBitrates', (bitrates: number[]) => {
      Logger.info(TAG, 'availableBitrates success,and availableBitrates length is:' + bitrates.length)
      this.callbackBitrateUpdate(bitrates)
    })
    // 设置错误监听
    this.media.on('error', (error: BusinessError) => {
      Logger.error(TAG, 'error happened,message is :' + error.message)
      this.callbackErrorUpdate('Error ' + error.code + ' - ' + error.message)
    })
  }

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    this.media.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      Logger.info(TAG, 'stateChange callback function is triggered,state is:' + state + ',reason is :' + reason)
      switch (state) {
        case 'idle':
          this.release()
          Logger.info(TAG, 'state idle called')
          break
        case 'initialized':
          this.isLoading = true
          Logger.info(TAG, 'state initialized called')
          this.setSurfaceID()
          this.media.prepare()
          break
        case 'prepared':
          Logger.info(TAG, 'state prepared called')
          this.isLoading = true
        // 获取轨道信息并打印
          this.getTrackDescription()
        // 设置焦点上报类型
          this.totalDuration = this.media.duration
          this.media.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE
          this.getPlay()
          break
        case 'playing':
          Logger.info(TAG, 'state playing called')
          this.isLoading = false
          break
        case 'paused':
          Logger.info(TAG, 'state paused called')
          break
        case 'completed':
          Logger.info(TAG, 'state completed called')
          this.callbackComplete()
          break
        case 'stopped':
          Logger.info(TAG, 'state stopped called')
          break
        case 'released':
          Logger.info(TAG, 'state released called')
          this.isLoading = false
          this.drmController.releaseDrm()
          break
        case 'error':
          Logger.info(TAG, 'state error called')
          break
        default:
          Logger.info(TAG, 'unkown state :' + state)
          break
      }
    })
  }

  setIsLoopCallBack(boole: boolean) {
    this.isLoop = boole
  }

  private getPlayStatus() {
    return this.media.state
  }

  setSurfaceID(): void {
    if (this.isVideo) {
      Logger.info(TAG, 'play video: surfaceID is:' + this.surfaceId)
      this.media.surfaceId = this.surfaceId
    } else {
      Logger.info(TAG, 'play audio')
    }
  }

  getPlayMode(boole: boolean) {
    Logger.info(TAG, `getPlayMode state : ${boole}`)
    if (boole) {
      this.media.loop = true
    } else {
      this.media.loop = false
    }
  }

  getPlay() {
    if (this.isCreate) {
      this.media.play()
    }
  }

  stop() {
    if (this.isCreate) {
      this.media.stop()
    }
  }

  async release() {
    if (this.isCreate) {
      await this.media.release()
      this.isCreate = false
    }
  }

  reset() {
    if (this.isCreate) {
      this.media.reset()
    }
  }

  getPause() {
    if (this.isCreate) {
      this.media.pause()
    }
  }

  getCurrentTime() {
    if (this.isCreate) {
      return this.media.currentTime
    }
    return 0
  }

  setBitrate(bitrate: number) {
    if (this.isCreate) {
      this.media.setBitrate(bitrate)
    }
  }

  setSpeed(speed: number) {
    if (this.isCreate) {
      this.media.setSpeed(speed)
    }
  }

  async seek(time: number) {
    if (this.isCreate) {
      Logger.info(TAG, 'seek time is ' + time)
      this.media.seek(time)
    }
  }

  getFormat() {
    return this.resourceAddress.mimeType
  }

  /**
   * DRM播放流程启动
   * @param drmInfoArr
   */
  async drmPlayProcess(drmInfoArr: drmInfo[]) {
    if (this.drmInfoFirstUpdate === false) {
      this.drmInfoFirstUpdate = true
      Logger.info(TAG, 'player has received drmInfo signal: ' + JSON.stringify(drmInfoArr))

      // --- 1 --- 判断系统是否支持drm能力
      let isSupported = this.drmController.isDrmSupported()
      if (!isSupported) {
        Logger.error(TAG, 'The system does not support the DRM.')
        return
      }
      Logger.info(TAG, 'The system supports the DRM.')

      // --- 2 --- 创建drm实例及会话
      this.drmController.createDrmSystem()

      // --- 3 --- 生成license请求；发送license到云端获取响应，将响应交给底层
      let isSuccess: boolean = await this.drmController.executeLicenseProcess(this.drmUrl, this.drmLicenseUrl, drmInfoArr, AppStorage.get('licenseType'))
      if (!isSuccess) {
        this.release()
        return
      }

      // --- 4 --- 设置加密配置
      this.drmController.bindInstance(this.media)
    }
  }

  /**
   * 删除离线license
   * @param drmUrl
   */
  deleteOfflineLicense(drmUrl: string) {
    this.drmController.deleteOfflineLicense(drmUrl)
  }
}