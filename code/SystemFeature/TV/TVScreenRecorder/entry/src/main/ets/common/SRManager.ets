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

import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { RecorderConstants, RecordingState } from './Constants'
import { common } from '@kit.AbilityKit'
import SRApi from 'libentry.so'
import Logger from './Logger'
import { fileIo as fs } from '@kit.CoreFileKit'
import { display } from '@kit.ArkUI'

const TAG: string = '[SRManager]-->';

export default class SRManager {
  private static instance: SRManager | undefined
  private recordingState: RecordingState = RecordingState.Idle
  private videoFd: number = -1
  private videoAsset: photoAccessHelper.PhotoAsset | undefined
  private videoFileName: string = ''
  private photoAccessManager: photoAccessHelper.PhotoAccessHelper | undefined
  private ctx: common.Context | undefined
  private stateChangeCallback: (state: RecordingState) => void = () => {
  }

  private constructor(ctx: common.Context) {
    this.ctx = ctx
  }

  public static getInstance(ctx: common.Context): SRManager {
    if (!SRManager.instance) {
      SRManager.instance = new SRManager(ctx)
    }
    return SRManager.instance
  }

  private getVideoName(): string {
    const date = new Date()
    const month = `${date.getMonth() + 1}`.padStart(RecorderConstants.TIME_LENGTH, RecorderConstants.TIME_PREFIX)
    const day = date.getDate().toString().padStart(RecorderConstants.TIME_LENGTH, RecorderConstants.TIME_PREFIX)
    const year = date.getFullYear().toString().padStart(RecorderConstants.TIME_LENGTH, RecorderConstants.TIME_PREFIX)
    const hour = date.getHours().toString().padStart(RecorderConstants.TIME_LENGTH, RecorderConstants.TIME_PREFIX)
    const minute = date.getMinutes().toString().padStart(RecorderConstants.TIME_LENGTH, RecorderConstants.TIME_PREFIX)
    const second = date.getSeconds().toString().padStart(RecorderConstants.TIME_LENGTH, RecorderConstants.TIME_PREFIX)
    const timeStamp = `${year}${month}${day}${RecorderConstants.CONNECTOR}${hour}${minute}${second}`
    return `${RecorderConstants.SCREEN_RECORD_PREFIX}${RecorderConstants.CONNECTOR}${timeStamp}${RecorderConstants.VIDEO_TYPE}`
  }

  private getPhotoAccessManager(): photoAccessHelper.PhotoAccessHelper {
    if (this.photoAccessManager) {
      return this.photoAccessManager;
    }
    const ctx = this.ctx
    if (!ctx) {
      throw new Error('context is undefined')
    }
    this.photoAccessManager = photoAccessHelper.getPhotoAccessHelper(ctx)
    return this.photoAccessManager
  }

  private async createVideoAsset(): Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        const phAccessHelper = this.getPhotoAccessManager()
        if(phAccessHelper == null){
          throw new Error('phAccessHelper is null')
        }
        this.videoFileName = this.getVideoName()
        const createOption: photoAccessHelper.PhotoCreateOptions = {
          subtype: photoAccessHelper.PhotoSubtype.SCREENSHOT
        }
        this.videoAsset = await phAccessHelper.createAsset(this.videoFileName, createOption)
        this.videoFd = fs.openSync(this.videoAsset.uri, fs.OpenMode.WRITE_ONLY).fd
        Logger.info(TAG, 'create videoAsset succeeded. fd:', this.videoFd)
        resolve()
      } catch (err) {
        Logger.error(TAG, 'create videoAsset error:' + JSON.stringify(err))
        this.recordingState = RecordingState.Error
        this.stateChangeCallback(this.recordingState)
        reject(err)
      }
    })
  }

  private async onStateChangeEvent(): Promise<void> {
    Logger.info(TAG, 'onStateChangeEvent')
    try {
      SRApi.onStateChange((state: number) => {
        Logger.info(TAG, 'onStateChange state ==> ' + state)
        this.recordingState = state
        switch (state) {
          case RecordingState.Idle: {
            Logger.info(TAG, 'AVRecorderState is idle. ')
            this.recordingState = RecordingState.Idle
            break;
          }
          case RecordingState.Recording: {
            Logger.info(TAG, 'AVRecorderState is started. ')
            this.recordingState = RecordingState.Recording
            this.stateChangeCallback(this.recordingState)
            break;
          }
          case RecordingState.Stopped: {
            Logger.info(TAG, 'AVRecorderState is stopped. ')
            this.recordingState = RecordingState.Stopped
            this.stateChangeCallback(this.recordingState)
            break;
          }
          case RecordingState.Error: {
            Logger.info(TAG, 'AVRecorderState is Error. ')
            this.recordingState = RecordingState.Error
            this.stateChangeCallback(this.recordingState)
            break;
          }
        }
      })
    } catch (err) {
      Logger.error(TAG, 'onStateChange error:', JSON.stringify(err))
      this.recordingState = RecordingState.Error
      this.stateChangeCallback(this.recordingState)
    }
  }


  public async startRecording(): Promise<void> {
    this.onStateChangeEvent()
    await this.createVideoAsset()
    try {
      const url = `${RecorderConstants.FD_PREFIX}${this.videoFd}`
      Logger.info(TAG, 'startRecording url ' + url)
      const result = SRApi.startRecording(url)
      if(result != 0){
        throw new Error('StartRecording error')
      }
      Logger.info(TAG, 'startRecording success')
    } catch (err) {
      Logger.error(TAG, 'startRecording err', JSON.stringify(err))
      this.recordingState = RecordingState.Error
      this.stateChangeCallback(this.recordingState)
    }
  }

  public onStateChange(cb: (state: RecordingState) => void) {
    this.stateChangeCallback = cb
  }

  public async stopRecording(): Promise<void> {
    try {
      const result = SRApi.stopRecording()
      if(result != 0){
        throw new Error('stopRecording error')
      }
      Logger.info(TAG, 'stopRecording success')
    } catch (err) {
      Logger.error(TAG, 'stopRecording err', JSON.stringify(err))
      this.recordingState = RecordingState.Error
      this.stateChangeCallback(this.recordingState)
    }
  }

  public getRecorderState() {
    try {
      this.recordingState = SRApi.getRecorderState()
      Logger.info(TAG, 'getRecorderState ' + JSON.stringify(this.recordingState))
    } catch (err) {
      Logger.error(TAG, 'getRecorderState err', JSON.stringify(err))
    }
    return this.recordingState
  }

}
