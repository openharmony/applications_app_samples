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

export class ModeType {
  id: number
  name: string

  constructor(id: number, name: string) {
    this.id = id;
    this.name = name;
  }
}

@Component
struct ModeItem_1 {
  private mode: ModeType
  @Consume contentTypeIndex: number

  @Builder renderModeItem(fontColor: string, bgColor: string, value: string) {
    Flex() {
      Text(value)
        .fontSize(16)
        .fontWeight(400)
        .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
        .fontColor(fontColor)
    }
    .height(44)
    .width(148)
    .backgroundColor(bgColor)
    .borderRadius(12)
    .padding({ left: 14, top: 14, bottom: 14 })

    if (this.mode.id != 5) {
      Flex() {
        Flex() {
        }.height(1).width('100%')
        .backgroundColor('#F3F3F3')
      }
      .padding({ left: 12, right: 12 })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      if (this.contentTypeIndex == this.mode.id) {
        this.renderModeItem('#007DFF', 'rgba(0,125,255,0.20)', this.mode.name)
      } else {
        this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name)
      }
    }.height(48).width(156)
  }
}

@Component
struct ModeItem_2 {
  private mode: ModeType
  @Consume streamUsageIndex: number

  @Builder renderModeItem(fontColor: string, bgColor: string, value: string) {
    Flex() {
      Text(value)
        .fontSize(16)
        .fontColor(fontColor)
        .fontWeight(400)
        .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
    }
    .height(44)
    .width(148)
    .backgroundColor(bgColor)
    .borderRadius(12)
    .padding({ left: 14, top: 14, bottom: 14 })

    if (this.mode.id != 14) {
      Flex() {
        Flex() {
        }.height(1).width('100%').backgroundColor('#F3F3F3')
      }
      .padding({ left: 12, right: 12 })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      if (this.streamUsageIndex == this.mode.id) {
        this.renderModeItem('#007DFF', 'rgba(0,125,255,0.20)', this.mode.name)
      } else {
        this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name)
      }
    }.height(48).width(156)
  }
}

@Component
struct ModeItem_3 {
  private mode: ModeType
  @Consume audioEffectModeSettingIndex: number

  @Builder renderModeItem(fontColor: string, bgColor: string, value: string) {
    Flex() {
      Text(value)
        .fontSize(16)
        .fontWeight(400)
        .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
        .fontColor(fontColor)
    }
    .height(44)
    .width(148)
    .backgroundColor(bgColor)
    .borderRadius(12)
    .padding({ left: 14, top: 14, bottom: 14 })

    if (this.mode.id != 1) {
      Flex() {
        Flex() {
        }.height(1).width('100%')
        .backgroundColor('#F3F3F3')
      }
      .padding({ left: 12, right: 12 })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      if (this.audioEffectModeSettingIndex == this.mode.id) {
        this.renderModeItem('#007DFF', 'rgba(0,125,255,0.20)', this.mode.name)
      } else {
        this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name)
      }
    }.height(48).width(156)
  }
}

@Entry
@Component
struct RealtimeAudioEffectQuery {
  scroller: Scroller = new Scroller()
  private audioSource = 'test1.wav'
  private appContext: common.Context
  private fileDescriptor = null
  private audioPlayState: Array<string> = ['notPlaying', 'onPlaying']
  private stateImg: Array<Resource> = [$r('app.media.ic_play'), $r('app.media.ic_pause')]
  private audioRenderer = null
  private contentTypeOptions = [{ id: 0, name: $r('app.string.CONTENT_TYPE_UNKNOWN') },
    { id: 1, name: $r('app.string.CONTENT_TYPE_SPEECH') },
    { id: 2, name: $r('app.string.CONTENT_TYPE_MUSIC') },
    { id: 3, name: $r('app.string.CONTENT_TYPE_MOVIE') },
    { id: 4, name: $r('app.string.CONTENT_TYPE_SONIFICATION') },
    { id: 5, name: $r('app.string.CONTENT_TYPE_RINGTONE') }]
  private streamUsageOptions = [{ id: 0, name: $r('app.string.STREAM_USAGE_UNKNOWN') },
    { id: 1, name: $r('app.string.STREAM_USAGE_MEDIA') },
    { id: 2, name: $r('app.string.STREAM_USAGE_MUSIC') },
    { id: 3, name: $r('app.string.STREAM_USAGE_VOICE_COMMUNICATION') },
    { id: 4, name: $r('app.string.STREAM_USAGE_VOICE_ASSISTANT') },
    { id: 5, name: $r('app.string.STREAM_USAGE_ALARM') },
    { id: 6, name: $r('app.string.STREAM_USAGE_VOICE_MESSAGE') },
    { id: 7, name: $r('app.string.STREAM_USAGE_NOTIFICATION_RINGTONE') },
    { id: 8, name: $r('app.string.STREAM_USAGE_RINGTONE') },
    { id: 9, name: $r('app.string.STREAM_USAGE_NOTIFICATION') },
    { id: 10, name: $r('app.string.STREAM_USAGE_ACCESSIBILITY') },
    { id: 11, name: $r('app.string.STREAM_USAGE_MOVIE') },
    { id: 12, name: $r('app.string.STREAM_USAGE_GAME') },
    { id: 13, name: $r('app.string.STREAM_USAGE_AUDIOBOOK') },
    { id: 14, name: $r('app.string.STREAM_USAGE_NAVIGATION') }]
  private audioEffectModeSettingOptions = [{ id: 0, name: $r('app.string.EFFECT_NONE') },
    { id: 1, name: $r('app.string.EFFECT_DEFAULT') }]
  @State showSelector_1: boolean = false
  @State showSelector_2: boolean = false
  @State showSelector_3: boolean = false
  @State queryResult: Resource = $r('app.string.BLANK')
  @State queryButtonState: boolean = false
  @State stateTextIndex: number = 0
  @State stateImgIndex: number = 0
  @State optionsButtonState: boolean = true
  @State currentAudioEffect: Resource = $r('app.string.EFFECT_DEFAULT')
  @State selectColor: Color = Color.Black
  @Provide audioEffectModeSettingIndex: number = 1
  @Provide contentTypeIndex: number = 0
  @Provide streamUsageIndex: number = 0

  async getStageFileDescriptor(fileName: string) {
    let fileDescriptor = undefined
    this.appContext = getContext()
    let mgr = this.appContext.resourceManager
    await mgr.getRawFd(fileName).then(value => {
      fileDescriptor = { fd: value.fd, offset: value.offset, length: value.length }
      console.log('case getRawFileDescriptor success filefd: ' + value.fd)
    }).catch(error => {
      console.log('case getRawFileDescriptor err: ' + error)
    })
    return fileDescriptor
  }

  async aboutToAppear() {
    this.appContext = getContext()
  }

  async onBackPress() {
    await this.audioRenderer.stop()
    await this.audioRenderer.release()
  }

  async onPageHide() {
    if (this.audioRenderer !== null && this.audioRenderer.state === audio.AudioState.STATE_RUNNING) {
      await this.audioRenderer.pause()
      this.stateImgIndex = 0
      this.stateTextIndex = 0
      console.info('The audio renderer has been paused.')
      this.optionsButtonState = true
    }
  }

  mapContentIndexToType(index: number) {
    // map the index of options to the content type in @ohos.multimedia.audio
    let index2Content = new Map([
      [0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]
    ]);
    console.info("get content type:" + index2Content.get(index))
    return index2Content.get(index)
  }

  mapStreamIndexToUsage(index: number) {
    // map the index of options to the stream usage in @ohos.multimedia.audio
    let index2Usage = new Map([
      [0, 0], [1, 1], [2, 1], [3, 2], [4, 3], [5, 4], [6, 5], [7, 6],
      [8, 6], [9, 7], [10, 8], [11, 10], [12, 11], [13, 12], [14, 13]
    ]);
    console.info("get stream usage:" + index2Usage.get(index))
    return index2Usage.get(index)
  }

  async createAudioEffectAndPlay() {
    let audioRendererOptions =
      {
        streamInfo: {
          samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
          channels: audio.AudioChannel.CHANNEL_2,
          sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
          encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
        },
        rendererInfo: {
          content: this.mapContentIndexToType(this.contentTypeIndex),
          usage: this.mapStreamIndexToUsage(this.streamUsageIndex),
          rendererFlags: 0
        }
      }
    try {
      this.audioRenderer = await audio.createAudioRenderer(audioRendererOptions)
      console.info("createAudioRenderer:SUCCEED")
    } catch (err) {
      console.error(`audioRenderer create ,Error: ${JSON.stringify(err)}`)
      return
    }
    await this.audioRenderer.setAudioEffectMode(this.audioEffectModeSettingIndex)
    try {
      await this.audioRenderer.start()
      console.info(" audioRenderer.start:SUCCEED")
    } catch (err) {
      console.error(`audioRenderer start ,Error: ${JSON.stringify(err)}`)
      return
    }

    let bufferSize
    try {
      bufferSize = await this.audioRenderer.getBufferSize()
      console.info(" get Buffer Size:SUCCEED")
    } catch (err) {
      console.error(`get Buffer Size ,Error: ${JSON.stringify(err)}`)
      return
    }
    console.info("buffer size:" + bufferSize)
    await this.getStageFileDescriptor(this.audioSource).then((res) => {
      this.fileDescriptor = res
    })

    let buf = new ArrayBuffer(bufferSize)
    let startOffset = this.fileDescriptor.offset
    let cur = startOffset + bufferSize
    while (true) {
      // when render released,state is changed to STATE_RELEASED
      if (this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
        break
      }
      while (cur <= startOffset + this.fileDescriptor.length - bufferSize) {
        let options = {
          offset: cur,
          length: bufferSize
        }
        await fs.read(this.fileDescriptor.fd, buf, options)
        await this.audioRenderer.write(buf)
        cur += bufferSize
      }
      cur = startOffset + bufferSize
    }
  }

  async playOrPause() {
    if (this.stateImgIndex === 0) {
      if (this.audioRenderer === null || this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
        this.createAudioEffectAndPlay()
        this.stateImgIndex = 1
        this.stateTextIndex = 1
        this.optionsButtonState = false
        this.selectColor = Color.Gray
        this.queryButtonState = true
      } else {
        let previousARInfo = await this.audioRenderer.getRendererInfo()
        let previousContent = previousARInfo.content
        let previousUsage = previousARInfo.usage
        if (this.mapContentIndexToType(this.contentTypeIndex) != previousContent
        || this.mapStreamIndexToUsage(this.streamUsageIndex) != previousUsage) {
          await this.audioRenderer.stop()
          await this.audioRenderer.release()
          this.stateImgIndex = 1
          this.stateTextIndex = 1
          this.optionsButtonState = false
          this.selectColor = Color.Gray
          this.queryButtonState = true
          this.createAudioEffectAndPlay()
        } else {
          await this.audioRenderer.start()
          this.stateImgIndex = 1
          this.stateTextIndex = 1
          this.optionsButtonState = false
          this.selectColor = Color.Gray
          this.queryButtonState = true
        }
      }
    } else {
      console.info('Try to pause')
      try {
        await this.audioRenderer.pause()
      } catch (err) {
        console.error(`audioRenderer pause ,Error: ${JSON.stringify(err)}`)
        return
      }
      this.stateImgIndex = 0
      this.stateTextIndex = 0
      console.info('The audio renderer has been paused.')
      this.optionsButtonState = true
      this.selectColor = Color.Black
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Navigation() {
            NavRouter() {
              NavDestination() {
              }
            }.onStateChange(async (isActivated: boolean) => {
              console.info("hello")
              if (this.audioRenderer != null) {
                await this.audioRenderer.stop()
                await this.audioRenderer.release()
              }
              await router.pushUrl({ url: 'pages/Index' })
            })
          }
          .id('back_btn_realtime')
          .height(56)
          .width(384)
          .hideBackButton(false)
          .titleMode(NavigationTitleMode.Mini)
          .title($r('app.string.EffectManager'))
          .mode(NavigationMode.Stack)
          .backgroundColor('#F1F3F5')
        }

        Row() {
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Row() {
              Text(this.contentTypeOptions[this.contentTypeIndex].name)
                .textAlign(TextAlign.Center)
                .textOverflow({ overflow: TextOverflow.None })
                .fontColor(this.selectColor)
                .fontSize(16)
                .fontWeight(500)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              if (this.showSelector_1) {
                Image($r('app.media.ic_arrow_up_big')).height(7).width(10)
                  .fillColor(this.selectColor)
                  .margin({ left: 8 })
              } else {
                Image($r('app.media.ic_arrow_down_big')).height(7).width(10)
                  .fillColor(this.selectColor)
                  .margin({ left: 8 })
              }
            }
          }
          .height(40)
          .width(140)
          .backgroundColor('#F1F3F5')
          .borderRadius(16)
          .margin({ left: 37, right: 6 })
          .padding({
            left: 16,
            right: 16
          })
          .enabled(this.optionsButtonState)
          .id('select_content_realtime')
          .onClick(() => {
            this.showSelector_1 = !this.showSelector_1
            this.showSelector_2 = false
            this.showSelector_3 = false
          })

          if (this.showSelector_1) {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
              ForEach(this.contentTypeOptions, item => {
                Flex() {
                  ModeItem_1({ mode: item })
                }.width(156)
                .onClick(() => {
                  if (this.contentTypeIndex !== item.id) {
                    this.contentTypeIndex = item.id
                    console.info('this.contentTypeIndex===' + this.contentTypeIndex)
                    this.queryResult = $r('app.string.BLANK')
                    this.queryButtonState = false
                    this.audioEffectModeSettingIndex = 1
                  }
                  this.showSelector_1 = false
                })
              }, item => item.id.toString())
            }
            .height(296)
            .width(156)
            .backgroundColor('#fff')
            .borderRadius(16)
            .shadow({ radius: 50, color: 'rgba(0,0,30,0.1500)' })
            .padding({ left: 4, right: 4, top: 4, bottom: 4 })
            .position({ x: 54, y: 40 })
            .zIndex(1)
          }

          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Row() {
              Text(this.streamUsageOptions[this.streamUsageIndex].name)
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .fontWeight(500)
                .fontColor(this.selectColor)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              if (this.showSelector_2) {
                Image($r('app.media.ic_arrow_up_small')).height(7).width(10)
                  .fillColor(this.selectColor)
                  .margin({ left: 8 })
              } else {
                Image($r('app.media.ic_arrow_down_small')).height(7).width(10)
                  .fillColor(this.selectColor)
                  .margin({ left: 8 })
              }
            }
          }
          .height(40)
          .width(140)
          .margin({ right: 37 })
          .backgroundColor('#F1F3F5')
          .borderRadius(16)
          .padding({
            left: 16,
            right: 16
          })
          .enabled(this.optionsButtonState)
          .id('select_usage_realtime')
          .onClick(() => {
            this.showSelector_1 = false
            this.showSelector_2 = !this.showSelector_2;
            this.showSelector_3 = false
          })

          if (this.showSelector_2) {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
              Scroll(this.scroller) {
                Column() {
                  ForEach(this.streamUsageOptions, item => {
                    Flex() {
                      ModeItem_2({ mode: item })
                    }.width(156)
                    .onClick(() => {
                      if (this.streamUsageIndex !== item.id) {
                        this.streamUsageIndex = item.id
                        console.info('this.streamUsageIndex===' + this.streamUsageIndex)
                        this.queryResult = $r('app.string.BLANK')
                        this.queryButtonState = false
                        this.audioEffectModeSettingIndex = 1
                      }
                      this.showSelector_2 = false
                    })
                  }, item => item.id.toString())
                }
              }
              .scrollable(ScrollDirection.Vertical)
              .scrollBar(BarState.On)
              .scrollBarColor(Color.Gray)
              .scrollBarWidth(10)
              .edgeEffect(EdgeEffect.None)
            }
            .height(344)
            .width(156)
            .backgroundColor('#fff')
            .borderRadius(16)
            .shadow({ radius: 50, color: 'rgba(0,0,30,0.1500)' })
            .padding({ left: 4, right: 4, top: 4, bottom: 4 })
            .position({ x: 145, y: 40 })
            .zIndex(1)
          }
        }.zIndex(1)

        Column() {
          Row() {
            Row() {
              Image(this.stateImg[this.stateImgIndex])
                .height(36)
                .width(36)
                .id('play_pause_realtime')
                .onClick(async () => {
                  this.showSelector_1 = false
                  this.showSelector_2 = false
                  this.showSelector_3 = false
                  await this.playOrPause()
                })
              Text($r('app.string.CURRENT_AUDIO_EFFECT'))
                .fontSize(16)
                .fontWeight(500)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                .width(112)
                .height(20)
                .margin({ left: 12 })
              Text(this.audioPlayState[this.stateTextIndex])
                .fontSize(2)
                .height(20)
                .width(5)
                .fontColor(Color.White)
                .id('audio_play_state')
            }

            Button($r('app.string.QUERY'), { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor('rgba(24,36,49,0.05)')
              .fontColor('#007DFF')
              .fontSize(12)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .height(28)
              .width(72)
              .id('query_btn_realtime')
              .enabled(this.queryButtonState)
              .onClick(async () => {
                this.showSelector_1 = false
                this.showSelector_2 = false
                this.showSelector_3 = false
                if (this.audioRenderer.state === audio.AudioState.STATE_RUNNING
                || this.audioRenderer.state === audio.AudioState.STATE_PAUSED) {
                  console.info('Cur audio effect query Button onClick')
                  let audioEffectMode = await this.audioRenderer.getAudioEffectMode()
                  console.info('cur audio effect mode value:' + audioEffectMode)
                  if (audioEffectMode === 0) {
                    this.currentAudioEffect = $r('app.string.EFFECT_NONE')
                  } else if (audioEffectMode === 1) {
                    this.currentAudioEffect = $r('app.string.EFFECT_DEFAULT')
                  }
                  this.queryResult = this.currentAudioEffect
                }
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height(56).width('100%')
          .margin({ top: 4, bottom: 1 })

          Row() {
          }
          .height(1).width(280)
          .margin({ right: -40 })
          .backgroundColor('#F1F3F5')

          Row() {
            Text($r('app.string.QUERY_RESULT'))
              .fontSize(16)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            Text(this.queryResult)
              .fontSize(14)
              .margin({ top: 22 })
              .fontColor(Color.Gray)
              .id('query_result_realtime')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height(48)
          .width('100%')

          Row() {
          }
          .height(1).width('100%')
          .backgroundColor('#F1F3F5')

          Row() {
            Text($r('app.string.AUDIO_EFFECT_MODE_SETTING'))
              .fontSize(16)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .height(22)
            Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
              Row() {
                Text(this.audioEffectModeSettingOptions[this.audioEffectModeSettingIndex].name)
                  .textAlign(TextAlign.Center)
                  .id('select_mode_name_realtime')
                  .textOverflow({ overflow: TextOverflow.None })
                  .fontSize(16)
                  .fontWeight(500)
                  .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))

                if (this.showSelector_3) {
                  Image($r('app.media.ic_arrow_up_small')).height(7).width(10)
                    .margin({ left: 8 })
                } else {
                  Image($r('app.media.ic_arrow_down_small')).height(7).width(10)
                    .margin({ left: 8 })
                }
              }
            }
            .height(22)
            .width(95)
            .backgroundColor(Color.White)
            .id('select_mode_realtime')
            .onClick(() => {
              this.showSelector_1 = false
              this.showSelector_2 = false
              this.showSelector_3 = !this.showSelector_3;
            })

            if (this.showSelector_3) {
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
                ForEach(this.audioEffectModeSettingOptions, item => {
                  Flex() {
                    ModeItem_3({ mode: item })
                  }.width(156)
                  .onClick(async () => {
                    if (this.audioEffectModeSettingIndex !== item.id) {
                      this.audioEffectModeSettingIndex = item.id
                      console.info('this.audioEffectModeSettingIndex===' + this.audioEffectModeSettingIndex)
                      if (this.audioRenderer !== null && this.audioRenderer.state !== audio.AudioState.STATE_RELEASED) {
                        await this.audioRenderer.setAudioEffectMode(item.id)
                      }
                    }
                    this.showSelector_3 = false
                  })
                }, item => item.id.toString())
              }
              .height(105)
              .width(156)
              .backgroundColor('#fff')
              .borderRadius(16)
              .shadow({ radius: 50, color: 'rgba(0,0,30,0.1500)' })
              .padding({ left: 4, right: 4, top: 6, bottom: 4 })
              .position({ x: 180, y: 40 })
              .zIndex(1)
            }
          }
          .margin({ top: 1, bottom: 4 })
          .height(48)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .zIndex(0)
        .width(360)
        .height(160)
        .backgroundColor(Color.White)
        .padding({ left: 12, right: 12 })
        .borderRadius(20)
      }

      Row() {
        Column() {
          Image($r('app.media.ic_Silent_normal'))
            .width(24)
            .height(24)
            .margin({ top: 7, bottom: 4 })
          Text($r('app.string.PRESET_AUDIO_EFFECT_QUERY'))
            .fontSize(10)
            .height(14)
        }
        .margin({ left: 24 })
        .height(56)
        .width(156)
        .id('switch_btn_realtime')
        .onClick(async () => {
          if (this.audioRenderer != null) {
            await this.audioRenderer.stop()
            await this.audioRenderer.release()
            console.info('The audio renderer has been released.')
          }
          await router.replaceUrl({ url: 'pages/PresetEffect' })
        })

        Column() {
          Image($r('app.media.ic_Sound_select'))
            .width(24)
            .height(24)
            .margin({ top: 7, bottom: 4 })
          Text($r('app.string.REALTIME_AUDIO_EFFECT_SETTING'))
            .fontSize(10)
            .height(14)
            .fontColor('#007DFF')
        }
        .height(56)
        .width(156)
        .margin({ right: 24 })
      }
      .height(56)
      .width(360)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#F1F3F5')
    .onClick(() => {
      this.showSelector_1 = false
      this.showSelector_2 = false
      this.showSelector_3 = false
    })
  }
}