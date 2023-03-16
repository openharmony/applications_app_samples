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

import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'
import PlayerModel from '../feature/BackgroundPlayerFeature'
import ContinuousTaskModel from '../model/ContinuousTaskModel'

const TAG: string = 'BackgroundPlayer'
const ONE_HUNDRED: number = 100 // Convert Milliseconds
const ONE_THOUSAND: number = 1000 // Convert second
const SIXTY: number = 60 // Convert minute

@Entry
@Component
struct BackgroundPlayer {
  @State currentTimeText: string = ''
  @State currentProgress: number = 0 // Current progress
  @State totalMs: number = 0 // Total time
  @State isSwitching: boolean = false
  @State isDialogShowing: boolean = false
  @State isDistributed: boolean = false
  @State title: string = ''
  @State totalTimeText: string = '00:00'
  @State albumSrc: Resource = $r('app.media.album')
  @State selectedIndex: number = 0 // selected song
  @State imageArrays: Array<Resource> = [$r('app.media.ic_play_previous'), $r('app.media.ic_play'), $r('app.media.ic_play_next')]
  private continuousTaskModel: ContinuousTaskModel = new ContinuousTaskModel(getContext() as common.UIAbilityContext)

  // get time
  getShownTimer(ms: number): string {
    let minStr: string
    let secStr: string
    let seconds = Math.floor(ms / ONE_THOUSAND)
    let sec = seconds % SIXTY
    Logger.info(TAG, `getShownTimer sec = ${sec}`)
    let min = (seconds - sec) / SIXTY
    Logger.info(TAG, `getShownTimer min = ${min}`)
    if (sec < 10) {
      secStr = '0' + sec
    } else {
      secStr = sec.toString(10)
    }
    if (min < 10) {
      minStr = '0' + min
    } else {
      minStr = min.toString(10)
    }
    Logger.warn(TAG, `getShownTimer = ${minStr}:${secStr}`)
    return minStr + ':' + secStr
  }

  // refresh song
  refreshSongInfo(index: number): number {
    Logger.info(TAG, `refreshSongInfo ${index}/${PlayerModel.playlist.audioFiles.length}`)
    if (index >= PlayerModel.playlist.audioFiles.length) {
      Logger.warn(TAG, `refreshSongInfo ignored`)
      return
    }
    // update song title
    this.title = PlayerModel.playlist.audioFiles[index].name
    this.albumSrc = (index % 2 === 0) ? $r('app.media.album') : $r('app.media.album2')
    // update duration
    this.totalMs = PlayerModel.getDuration()
    this.totalTimeText = this.getShownTimer(this.totalMs)
    this.currentTimeText = this.getShownTimer(PlayerModel.getCurrentMs())
    Logger.info(TAG, `refreshSongInfo this.title= ${this.title}, this.totalMs= ${this.totalMs}, this.totalTimeText= ${this.totalTimeText},this.currentTimeText= ${this.currentTimeText}`)
  }

  // previous
  onPreviousClick(): boolean {
    if (this.isSwitching) {
      Logger.info(TAG, `onPreviousClick ignored, isSwitching`)
      return
    }
    Logger.info(TAG, `onPreviousClick`)
    PlayerModel.playerIndex--
    if (PlayerModel.playerIndex < 0 && PlayerModel.playlist.audioFiles.length >= 1) {
      PlayerModel.playerIndex = PlayerModel.playlist.audioFiles.length - 1
    }
    this.currentProgress = 0
    this.isSwitching = true
    PlayerModel.preLoad(PlayerModel.playerIndex, () => {
      this.refreshSongInfo(PlayerModel.playerIndex)
      PlayerModel.playMusic(0, true)
      if (PlayerModel.isPlaying) {
        this.imageArrays[1] = $r('app.media.ic_pause')
      }
      this.isSwitching = false
    })
  }

  // next
  onNextClick(): boolean {
    if (this.isSwitching) {
      Logger.info(TAG, `onNextClick ignored, isSwitching`)
      return
    }
    Logger.info(TAG, `onNextClick`)
    PlayerModel.playerIndex++
    if (PlayerModel.playerIndex >= PlayerModel.playlist.audioFiles.length) {
      PlayerModel.playerIndex = 0
    }
    this.currentProgress = 0
    this.isSwitching = true
    PlayerModel.preLoad(PlayerModel.playerIndex, () => {
      this.refreshSongInfo(PlayerModel.playerIndex)
      PlayerModel.playMusic(0, true)
      if (PlayerModel.isPlaying) {
        this.imageArrays[1] = $r('app.media.ic_pause')
      }
      this.isSwitching = false
    })
  }

  // play or pause
  onPlayClick(): boolean {
    if (this.isSwitching) {
      Logger.info(TAG, `onPlayClick ignored, isSwitching`)
      return
    }
    Logger.info(TAG, `onPlayClick isPlaying= ${PlayerModel.isPlaying}`)
    if (PlayerModel.isPlaying) {
      PlayerModel.pauseMusic()
      this.imageArrays[1] = $r('app.media.ic_play')
      // cancel continuous task
      this.continuousTaskModel.stopContinuousTask()
    } else {
      // start continuous task
      this.continuousTaskModel.startContinuousTask()
      PlayerModel.preLoad(PlayerModel.playerIndex, () => {
        PlayerModel.playMusic(-1, true)
        this.imageArrays[1] = $r('app.media.ic_pause')
      })
    }
  }

  aboutToAppear() {
    Logger.info(TAG, `begin`)
    this.currentTimeText = this.getShownTimer(0)
    PlayerModel.setOnStatusChangedListener((isPlaying: boolean) => {
      Logger.info(TAG, `on player status changed, isPlaying= ${isPlaying} refresh ui`)
      PlayerModel.setOnPlayingProgressListener((currentTimeMs: number) => {
        this.currentTimeText = this.getShownTimer(currentTimeMs)
        this.currentProgress = Math.floor(currentTimeMs / this.totalMs * ONE_HUNDRED)
      })
      if (isPlaying) {
        this.imageArrays[1] = $r('app.media.ic_pause')
      } else {
        this.imageArrays[1] = $r('app.media.ic_play')
      }
    })
    PlayerModel.getPlaylist(() => {
      Logger.info(TAG, `on playlist generated, refresh ui`)
      PlayerModel.preLoad(0, () => {
        this.refreshSongInfo(0)
      })
    })
  }

  build() {
    Column() {
      Text(this.title)
        .width('100%')
        .fontSize(30)
        .margin({ top: '10%' })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
      Image(this.albumSrc)
        .width('60%')
        .height('35%')
        .objectFit(ImageFit.Contain)
        .margin({ top: 20, left: 40, right: 40 })
      Row() {
        Text(this.currentTimeText)
          .fontSize(20)
          .fontColor(Color.White)
        Blank()
        Text(this.totalTimeText)
          .fontSize(20)
          .fontColor(Color.White)
      }
      .width('90%')
      .margin({ top: '10%' })

      Slider({ value: this.currentProgress })
        .width('80%')
        .selectedColor($r('app.color.select'))
        .onChange((value: number, mode: SliderChangeMode) => {
          this.currentProgress = value
          if (isNaN(this.totalMs)) {
            this.currentProgress = 0
            Logger.info(TAG, `setProgress ignored, totalMs= ${this.totalMs}`)
            return
          }
          let currentMs = this.currentProgress / ONE_HUNDRED * this.totalMs
          this.currentTimeText = this.getShownTimer(currentMs)
          if (mode === SliderChangeMode.End || mode === 3) {
            Logger.info(TAG, `player.seek= ${currentMs}`)
            PlayerModel.seekTimeMs(currentMs)
          }
        })

      Row() {
        ForEach(this.imageArrays, (item, index) => {
          Column() {
            Image(item)
              .size({ width: 72, height: 72 })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                switch (index) {
                  case 0:
                    this.onPreviousClick()
                    break
                  case 1:
                    this.onPlayClick()
                    break
                  case 2:
                    this.onNextClick()
                    break
                  default:
                    break
                }
              })
          }
          .width(100)
          .height(100)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        })

      }
      .width('100%')
      .margin({ top: '10%' })
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg_blurry'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}