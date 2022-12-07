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

import screenManager from '@ohos.screen'
import media from '@ohos.multimedia.media'
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import Logger from '../common/Logger'
import display from '@ohos.display'
import emitter from '@ohos.events.emitter';
import { DESTROY_FLOAT_WINDOW } from '../common/Constants'

const TAG: string = '[ScreenRecorder]'

const DEFAULT_VIDEO_PROFILE = {
  audioBitrate: 48000,
  audioChannels: 2,
  audioCodec: media.CodecMimeType.AUDIO_AAC,
  audioSampleRate: 48000,
  fileFormat: media.ContainerFormatType.CFT_MPEG_4,
  videoBitrate: 48000,
  videoCodec: media.CodecMimeType.VIDEO_AVC,
  videoFrameWidth: 0,
  videoFrameHeight: 0,
  videoFrameRate: 0,
}

enum RecordingState {
  Idle = 0,
  Recording,
  Stopped,
  Error
}

const VIDEO_SOURCE_RGB = 2
const AUDIO_SOURCE_MIC = 1
const FD_PREFIX = 'fd://'
const TIME_LENGTH = 2
const TIME_PREFIX = '0'
const SCREEN_RECORD_PREFIX = 'REC'
const VIDEO_TYPE = '.mp4'
const CONNECTOR = '_'
const VIRTUAL_SCREEN_NAME = 'screenRecorder'
type MediaManager = ReturnType<typeof mediaLibrary.getMediaLibrary>

@Entry
@Component
struct ScreenRecorder {
  //'Idle' | 'Recording' | 'Stopped' | 'Error'
  @State recordingState: RecordingState = RecordingState.Idle
  @State isIconHidden: boolean = false
  textTimerController: TextTimerController = new TextTimerController()
  private timeoutID: number = -1
  //'idle' | 'prepared' | 'playing' | 'paused' | 'stopped' | 'error'
  private videoRecorder: media.VideoRecorder
  private virtualScreen: screenManager.Screen
  private videoFd: number
  private videoAsset: mediaLibrary.FileAsset
  private videoFileName: string
  private mediaManager: MediaManager
  @State timerFormat: string = 'hh:mm:ss'
  build() {
    Row() {
      Rect({ width: 10, height: 10, radius: 2 })
        .fill(Color.Red)
        .visibility(this.isIconHidden ? Visibility.Hidden : Visibility.Visible)
      TextTimer({ controller: this.textTimerController })
        .format(this.timerFormat)
        .fontColor(0xe5000000)
        .fontSize(16)
        .margin({ left: 12 })
    }
    .onClick(() => {
      this.stopRecorder()
      this.textTimerController.pause()
      clearTimeout(this.timeoutID)
      this.isIconHidden = false
      emitter.emit({ eventId: DESTROY_FLOAT_WINDOW })
    })
    .borderRadius(15)
    .padding({ left: 20, right: 20 })
    .backgroundColor(0x55000000)
    .size({ width: '100%', height: '100%' })

  }

  /* Red icon of the recording state to flash each 500ms */
  private flashTheRecordingIcon() {
    this.timeoutID = setTimeout(() => {
      this.isIconHidden = !this.isIconHidden
      this.flashTheRecordingIcon()
    }, 500)
  }

  /* Page life cycle to load this page before the build */
  aboutToAppear(): void {
    Logger.info(TAG, `aboutToAppear()`)
  }

  /* Page life cycle after the build */
  onPageShow(): void {
    if (this.recordingState === RecordingState.Idle) {
      // Notes: controller must start after the build() func to init the TextTimer() now
      this.textTimerController.start()
      this.startRecorder()
      // this.flashTheRecordingIcon() // enable this feature depend on the ArkTSPartialUpdate enable or TextTimer bugfix
      Logger.info(TAG, 'onPageShow() textTimerController to start')
    } else {
      Logger.warn(TAG, 'onPageShow() recording is not idle, recordingState:' + this.recordingState.toString())
    }
  }

  onPageHide(): void {
    Logger.info(TAG, 'onPageHide() recordingState:' + this.recordingState.toString())
  }

  private async getVideoConfig(url: string): Promise<media.VideoRecorderConfig> {
    const dftDisplay = display.getDefaultDisplaySync()
    const videoProfile: media.VideoRecorderProfile = {
      ...DEFAULT_VIDEO_PROFILE,
      videoFrameWidth: dftDisplay.width,
      videoFrameHeight: dftDisplay.height,
      videoFrameRate: dftDisplay.refreshRate,
    }
    return {
      audioSourceType: AUDIO_SOURCE_MIC,
      videoSourceType: VIDEO_SOURCE_RGB,
      profile: videoProfile,
      url,
    }
  }

  private getMediaManager(): MediaManager {
    if (this.mediaManager) {
      return this.mediaManager;
    }
    this.mediaManager = mediaLibrary.getMediaLibrary(globalThis.shotScreenContext)
    return this.mediaManager
  }

  private async createVideoAsset(): Promise<void> {
    try {
      const mediaManager = this.getMediaManager()
      const publicPath = await mediaManager.getPublicDirectory(mediaLibrary.DirectoryType.DIR_VIDEO)
      this.videoAsset = await mediaManager.createAsset(mediaLibrary.MediaType.VIDEO, this.videoFileName, publicPath)
      this.videoFd = await this.videoAsset.open('w')
    } catch (err) {
      Logger.error(TAG, 'createVideoAsset error:', JSON.stringify(err))
      this.videoAsset && this.videoAsset.close(this.videoFd)
      this.videoFd = undefined;
    }
  }

  private async initPreparedVideoRecorder(): Promise<void> {
    if (!this.videoFd) {
      Logger.error(TAG, 'Create the video asset first and open the file')
      return
    }
    try {
      this.videoRecorder = await media.createVideoRecorder()
      const config = await this.getVideoConfig(`${FD_PREFIX}${this.videoFd}`)
      this.videoRecorder.prepare(config)
      const surfaceId = await this.videoRecorder.getInputSurface()
      Logger.info(TAG, 'Get input surface id:', surfaceId)
    } catch (err) {
      Logger.error(TAG, 'Create video recorder failed:' + JSON.stringify(err))
    }
  }

  private async createVirtualScreen(surfaceId: string) {
    try {
      const dftDisplay = display.getDefaultDisplaySync();
      return await screenManager.createVirtualScreen({
        name: VIRTUAL_SCREEN_NAME,
        width: dftDisplay.width,
        height: dftDisplay.height,
        density: dftDisplay.densityDPI,
        surfaceId,
      })
    } catch (err) {
      Logger.error(TAG, 'Create the virtual screen failed' + JSON.stringify(err))
    }
  }

  private async setVirtualScreenAsMirror() {
    if (!this.virtualScreen) {
      Logger.error(TAG, 'Virtual screen not exist')
      return
    }
    try {
      const screens = await screenManager.getAllScreens()
      const defaultScreen = screens[0]
      if (!defaultScreen) {
        Logger.error(TAG, 'Default screen not exist')
        return
      }
      screenManager.makeMirror(defaultScreen.id, [this.virtualScreen.id])
    } catch (err) {
      Logger.error(TAG, 'setVirtualScreenAsMirror error:' + JSON.stringify(err))
    }
  }

  private async bindSurfaceToRecorder(surfaceId: string) {
    if (!this.videoRecorder || !this.virtualScreen) {
      Logger.error(TAG, 'videoRecorder or virtualScreen undefined')
      return
    }
    try {
      await screenManager.setVirtualScreenSurface(this.virtualScreen.id, surfaceId)
    } catch (err) {
      Logger.error(TAG, 'bindSurfaceToRecorder error:' + JSON.stringify(err))
    }
  }

  private getVideoName(): string {
    const date = new Date()
    const month = `${date.getMonth() + 1}`.padStart(TIME_LENGTH, TIME_PREFIX)
    const day = date.getDate().toString().padStart(TIME_LENGTH, TIME_PREFIX)
    const year = date.getFullYear().toString().padStart(TIME_LENGTH, TIME_PREFIX)
    const hour = date.getHours().toString().padStart(TIME_LENGTH, TIME_PREFIX)
    const minute = date.getMinutes().toString().padStart(TIME_LENGTH, TIME_PREFIX)
    const second = date.getSeconds().toString().padStart(TIME_LENGTH, TIME_PREFIX)
    const timeStamp = `${year}${month}${day}${CONNECTOR}${hour}${minute}${second}`
    return `${SCREEN_RECORD_PREFIX}${CONNECTOR}${timeStamp}${VIDEO_TYPE}`
  }

  private async startRecorder(): Promise<void> {
    if (this.videoFileName) {
      Logger.info(TAG, 'The screen is recording')
    }
    this.recordingState = RecordingState.Recording
    Logger.info(TAG, 'recordingState:' + this.recordingState.toString())
    try {
      this.videoFileName = this.getVideoName()

      // Create a temp video file
      await this.createVideoAsset()

      // Initialize video Recorder
      await this.initPreparedVideoRecorder()

      // Obtains the surface ID provided by the video recorder
      const surfaceId = await this.videoRecorder.getInputSurface()

      this.virtualScreen = await this.createVirtualScreen(surfaceId)

      // Bind the output of the virtual screen to the surface of the video recorder
      await this.bindSurfaceToRecorder(surfaceId)

      // Set the virtual screen as a mirror of the default screen
      await this.setVirtualScreenAsMirror()

      await this.videoRecorder.start()
      this.recordingState = this.videoRecorder.state === 'playing' ? RecordingState.Recording : RecordingState.Error
      Logger.info(TAG, 'startRecorder() recordingState:' + this.recordingState.toString())
    } catch (err) {
      this.release()
      this.recordingState = RecordingState.Error
      Logger.error(TAG, 'Start screen recorder error:' + JSON.stringify(err))
    }
  }

  private async stopRecorder(): Promise<void> {
    if (!this.videoRecorder) {
      Logger.error(TAG, 'Recording is stopped or not started')
    }
    try {
      await this.videoRecorder.stop().then(() => {
        Logger.info(TAG, 'Stop video recorder success')
      }).catch((err) => {
        Logger.error(TAG, 'Stop video recorder failed error:' + JSON.stringify(err))
      })
      await this.videoRecorder.reset().then(() => {
        Logger.info(TAG, 'Reset video recorder success')
      }).catch((err) => {
        Logger.error(TAG, 'Reset video recorder failed error:' + JSON.stringify(err))
      })
      this.recordingState = this.videoRecorder.state === 'idle' ? RecordingState.Idle : RecordingState.Error
      Logger.info(TAG, 'stopRecorder() recordingState:' + this.recordingState.toString())
    } catch (err) {
      this.recordingState = RecordingState.Error
      Logger.error(TAG, 'Stop screenRecorder error:' + JSON.stringify(err))
    } finally {
      await this.release()
    }
  }

  private async release(): Promise<void> {
    try {
      this.videoRecorder && await this.videoRecorder.release()
      this.videoRecorder = undefined
      this.videoFileName = undefined

      this.virtualScreen && await screenManager.destroyVirtualScreen(this.virtualScreen.id)
      this.virtualScreen = undefined
      this.recordingState = RecordingState.Idle
      Logger.info(TAG, 'release(), release success')
    } catch (err) {
      Logger.error(TAG, 'release(), release error:' + JSON.stringify(err))
    }
  }
}


