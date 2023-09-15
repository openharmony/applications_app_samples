/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import common from '@ohos.app.ability.common'
import fs from '@ohos.file.fs'
import audio from '@ohos.multimedia.audio'
import router from '@ohos.router'

const MUSIC_INDEX = 0
const RINGTONE_INDEX = 1
const TOTAL_SECOND = 30
const PLAYER_CONTAINER = [0, 1]

@Entry
@Component
struct Focus {
  @State outSetValueOne: number = 50
  private audioRenderers = [null, null]
  private audioRendererOptions = [
    {
      streamInfo: {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
        channels: audio.AudioChannel.CHANNEL_2,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      },
      rendererInfo: {
        content: audio.ContentType.CONTENT_TYPE_MUSIC,
        usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
        rendererFlags: 0
      }
    },
    {
      streamInfo: {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
        channels: audio.AudioChannel.CHANNEL_2,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      },
      rendererInfo: {
        content: audio.ContentType.CONTENT_TYPE_MUSIC,
        usage: audio.StreamUsage.STREAM_USAGE_NOTIFICATION_RINGTONE,
        rendererFlags: 0
      }
    }
  ]
  private fileDescriptors = [null, null]
  private appContext: common.Context = null
  private audioSources = ['test1.wav', 'test2.wav']
  @State stateImg: Array<Resource> = [$r('app.media.ic_pause_y'), $r('app.media.ic_pause_no')]
  @State stateText: Array<string> = ['ic_pause', 'ic_pause_no']
  @State starts: Array<number> = [0, 0]
  @State curTimeSecs: Array<number> = [0, 0]
  @State musicIsClicked: boolean = false

  aboutToAppear() {
    this.init()
  }

  async init() {
    if (this.appContext !== null) {
      return
    }
    this.fileDescriptors = [null, null]
    this.stateImg = [$r('app.media.ic_pause_y'), $r('app.media.ic_pause_no')]
    this.stateText = ['ic_pause', 'ic_pause_no']
    this.starts = [0, 0]
    this.curTimeSecs = [0, 0]
    this.musicIsClicked = false
    this.appContext = getContext(this)
    await this.getStageFileDescriptor(this.audioSources[MUSIC_INDEX]).then((res) => {
      this.fileDescriptors[MUSIC_INDEX] = res
    })
    await this.getStageFileDescriptor(this.audioSources[RINGTONE_INDEX]).then((res) => {
      this.fileDescriptors[RINGTONE_INDEX] = res
    })

    for (let index = 0; index < PLAYER_CONTAINER.length; index++) {
      try {
        this.audioRenderers[index] = await audio.createAudioRenderer(this.audioRendererOptions[index])
        await this.audioRenderers[index].setInterruptMode(audio.InterruptMode.INDEPENDENT_MODE)
        this.listenState(index)
        this.listenFocus(index)
      } catch (err) {
        console.error(`audioRenderer_${index} create ,Error: ${JSON.stringify(err)}`)
        return
      }
    }
  }

  async over() {
    this.appContext = null
    if (this.audioRenderers[MUSIC_INDEX] !== null) {
      await this.audioRenderers[MUSIC_INDEX].release()
      this.audioRenderers[MUSIC_INDEX] = null
    }
    if (this.audioRenderers[RINGTONE_INDEX] !== null) {
      await this.audioRenderers[RINGTONE_INDEX].release()
      this.audioRenderers[RINGTONE_INDEX] = null
    }
    if (this.fileDescriptors[MUSIC_INDEX] !== null) {
      await this.closeResource(this.audioSources[MUSIC_INDEX])
      this.fileDescriptors[MUSIC_INDEX] = null
    }
    if (this.fileDescriptors[RINGTONE_INDEX] !== null) {
      await this.closeResource(this.audioSources[RINGTONE_INDEX])
      this.fileDescriptors[RINGTONE_INDEX] = null
    }
  }

  onBackPress() {
    this.over()
  }

  async onPageHide() {
    this.over()
  }

  onPageShow() {
    this.init()
  }

  listenFocus(index) {
    this.audioRenderers[index].on('audioInterrupt', async audioInterrupt => {
      let hintType = audioInterrupt.hintType
      if (hintType === audio.InterruptHint.INTERRUPT_HINT_PAUSE) {
        this.stateImg[index] = $r('app.media.ic_pause_no')
        this.stateText[index] = 'ic_pause_no'
      }
      if (hintType === audio.InterruptHint.INTERRUPT_HINT_RESUME) {
        this.stateImg[index] = $r('app.media.ic_play_no')
        this.stateText[index] = 'ic_play_no'
        await this.play(index)
      }
    })
  }

  listenState(index) {
    this.audioRenderers[index].on('stateChange', state => {
      if (state === audio.AudioState.STATE_RUNNING) {
        if (index === 0) {
          this.stateImg[index] = $r('app.media.ic_play_no')
          this.stateText[index] = 'ic_play_no'
        } else {
          this.stateImg[index] = $r('app.media.ic_play_y')
          this.stateText[index] = 'ic_play'
        }
      }
      if (state === audio.AudioState.STATE_PAUSED) {
        this.stateImg[index] = $r('app.media.ic_pause_y')
        this.stateText[index] = 'ic_pause'
      }
      if (state === audio.AudioState.STATE_STOPPED) {
        this.stateImg[index] = $r('app.media.ic_pause_no')
        this.stateText[index] = 'ic_pause_no'
      }
    })
  }

  getCurTimeSec(totalSec, totalLen, PastLen) {
    return parseInt((totalSec / totalLen * PastLen).toFixed(0))
  }

  async getStageFileDescriptor(fileName) {
    let fileDescriptor = undefined
    let mgr = this.appContext.resourceManager
    await mgr.getRawFd(fileName).then(value => {
      fileDescriptor = { fd: value.fd, offset: value.offset, length: value.length }
      console.log('case getRawFileDescriptor success fileName: ' + fileName)
    }).catch(error => {
      console.log('case getRawFileDescriptor err: ' + error)
    })
    return fileDescriptor
  }

  async closeResource(fileName) {
    let mgr = this.appContext.resourceManager
    await mgr.closeRawFd(fileName).then(() => {
      console.log('case closeRawFd success fileName: ' + fileName)
    }).catch(error => {
      console.log('case closeRawFd err: ' + error)
    })
  }

  async play(index) {
    if (this.audioRenderers[index] === null) {
      return
    }
    let bufferSize
    try {
      bufferSize = await this.audioRenderers[index].getBufferSize()
      await this.audioRenderers[index].start()
    } catch (err) {
      console.error(`audioRenderer start : Error: ${JSON.stringify(err)}`)
      return
    }
    try {
      let buf = new ArrayBuffer(bufferSize)
      let start = this.fileDescriptors[index].offset
      if (this.starts[index] === 0) {
        this.starts[index] = start
      }
      let cur = this.starts[index]
      while (cur < start + this.fileDescriptors[index].length) {
        // when render released,state is changed to STATE_RELEASED
        if (this.audioRenderers[index].state === audio.AudioState.STATE_RELEASED) {
          break
        }
        // when render paused,state is changed to STATE_PAUSED
        if (this.audioRenderers[index].state === audio.AudioState.STATE_PAUSED) {
          this.starts[index] = cur
          break
        }
        // when render stopped,state is changed to STATE_STOPPED
        if (this.audioRenderers[index].state === audio.AudioState.STATE_STOPPED) {
          this.starts[index] = this.fileDescriptors[index].length
          this.curTimeSecs[index] = TOTAL_SECOND
          break
        }
        let options = {
          offset: cur,
          length: bufferSize
        }
        await fs.read(this.fileDescriptors[index].fd, buf, options)
        await this.audioRenderers[index].write(buf)
        // update progress
        this.curTimeSecs[index] = this.getCurTimeSec(TOTAL_SECOND, parseInt(this.fileDescriptors[index].length), cur - start)
        cur += bufferSize
      }
      // when audio play completed,update state to stopped
      if (cur >= this.fileDescriptors[index].length) {
        await this.audioRenderers[index].stop()
        this.curTimeSecs[index] = TOTAL_SECOND
      }
    } catch (err) {
      console.error(`audioRenderer write : Error: ${JSON.stringify(err)}`)
    }
  }

  async stop(index) {
    try {
      await this.audioRenderers[index].stop()
    }
    catch (err) {
      console.error(`render_1  stop err:${JSON.stringify(err)}`)
    }
  }

  build() {
    Column() {
      Row() {
        Navigation() {
          NavRouter() {
            NavDestination() {
            }
          }
        }
        .height('100%')
        .width('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        .title($r('app.string.AudioFocus'))
        .mode(NavigationMode.Stack)
      }.height(56).width('100%').id('back_btn_focus')
      .onClick(async () => {
        await router.pushUrl({ url: 'pages/Index' })
      })

      Column() {
        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_music')).width(48).height(48)
              Text($r('app.string.MusicType'))
                .fontSize(16)
                .margin({ left: 12 })
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                .fontColor('#182431')
                .fontWeight(500)
            }

            Text(this.stateText[MUSIC_INDEX]).id('music_state_text').fontSize(10).fontColor(Color.White)
            Image(this.stateImg[MUSIC_INDEX]).id('music_state_img').width(36).height(36)
          }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 12 })

          Row() {
            Progress({ value: this.curTimeSecs[MUSIC_INDEX], total: TOTAL_SECOND, type: ProgressType.Linear })
              .color('#007DFF')
              .value(this.curTimeSecs[MUSIC_INDEX])
              .width('100%')
              .height(4)
          }.margin({ top: 24, bottom: 3 }).width('100%')

          Row() {
            Text(this.curTimeSecs[MUSIC_INDEX] + 's')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .opacity(0.6)
              .fontWeight(400)
            Text(TOTAL_SECOND + 's')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .opacity(0.6)
              .fontWeight(400)
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }
        .id('music_player_item')
        .height(126)
        .width('100%')
        .padding({ left: '3.35%', right: '3.35%' })
        .backgroundColor(Color.White)
        .margin({ bottom: 20 })
        .borderRadius(24)
        .onClick(() => {
          if (this.audioRenderers[MUSIC_INDEX].state === audio.AudioState.STATE_PREPARED) {
            this.play(MUSIC_INDEX)
            this.musicIsClicked = true
            this.stateText[RINGTONE_INDEX] = 'ic_pause'
            this.stateImg[RINGTONE_INDEX] = $r('app.media.ic_pause_y')
          }
        })

        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_ring')).width(48).height(48)
              Text($r('app.string.RingtoneType'))
                .fontSize(16)
                .margin({ left: 12 })
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                .fontColor('#182431')
                .fontWeight(500)
            }

            Text(this.stateText[RINGTONE_INDEX]).id('ringtone_state_text').fontSize(10).fontColor(Color.White)
            Image(this.stateImg[RINGTONE_INDEX]).id('ringtone_state_img').width(36).height(36)
          }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 10 })

          Row() {
            Progress({ value: this.curTimeSecs[RINGTONE_INDEX], total: TOTAL_SECOND, type: ProgressType.Linear })
              .color('#007DFF')
              .value(this.curTimeSecs[RINGTONE_INDEX])
              .width('100%')
              .height(4)
          }.margin({ top: 24, bottom: 3 })

          Row() {
            Text(this.curTimeSecs[RINGTONE_INDEX] + 's')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .opacity(0.6)
              .fontWeight(400)
            Text(TOTAL_SECOND + 's')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .opacity(0.6)
              .fontWeight(400)
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }
        .id('ringtone_player_item')
        .width('100%')
        .padding({ left: '3.35%', right: '3.35%' })
        .height(126)
        .backgroundColor(Color.White)
        .borderRadius(24)
        .onClick(() => {
          if (this.audioRenderers[RINGTONE_INDEX].state === audio.AudioState.STATE_RUNNING) {
            this.stop(RINGTONE_INDEX)
          } else if (this.audioRenderers[RINGTONE_INDEX].state === audio.AudioState.STATE_PREPARED && this.musicIsClicked === true) {
            this.play(RINGTONE_INDEX)
          }
        })
      }.width('100%').padding({ left: '3.35%', right: '3.35%' })
    }.height('100%').width('100%').backgroundColor('#f1f3f5')
  }
}