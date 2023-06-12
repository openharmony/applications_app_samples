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
    Flex({ direction: FlexDirection.Column }) {
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
    .width(156)
  }

  build() {
    Flex() {
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
    Flex({ direction: FlexDirection.Column }) {
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

      if (this.mode.id != 6) {
        Flex() {
          Flex() {
          }.height(1).width('100%').backgroundColor('#F3F3F3')
        }
        .padding({ left: 12, right: 12 })
      }
    }
    .width(156)
  }

  build() {
    Flex() {
      if (this.streamUsageIndex == this.mode.id) {
        this.renderModeItem('#007DFF', 'rgba(0,125,255,0.20)', this.mode.name)
      } else {
        this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name)
      }
    }.height(48).width(156)
  }
}

@Entry
@Component
struct DetectPresetEffect {
  private audioEffectInfoArray = [null, null]
  private audioManager = undefined
  private audioStreamManager = undefined
  private contentTypeOptions = [{ id: 0, name: $r('app.string.CONTENT_TYPE_UNKNOWN') },
    { id: 1, name: $r('app.string.CONTENT_TYPE_SPEECH') },
    { id: 2, name: $r('app.string.CONTENT_TYPE_MUSIC') },
    { id: 3, name: $r('app.string.CONTENT_TYPE_MOVIE') },
    { id: 4, name: $r('app.string.CONTENT_TYPE_SONIFICATION') },
    { id: 5, name: $r('app.string.CONTENT_TYPE_RINGTONE') }]
  private streamUsageOptions = [{ id: 0, name: $r('app.string.STREAM_USAGE_UNKNOWN') },
    { id: 1, name: $r('app.string.STREAM_USAGE_MEDIA') },
    { id: 2, name: $r('app.string.STREAM_USAGE_VOICE_COMMUNICATION') },
    { id: 3, name: $r('app.string.STREAM_USAGE_VOICE_ASSISTANT') },
    { id: 4, name: $r('app.string.STREAM_USAGE_ALARM') },
    { id: 5, name: $r('app.string.STREAM_USAGE_NOTIFICATION_RINGTONE') },
    { id: 6, name: $r('app.string.STREAM_USAGE_ACCESSIBILITY') }]
  @State showSelector_1: boolean = false
  @State showSelector_2: boolean = false
  @State queryResult: Resource = $r('app.string.BLANK')
  @Provide contentTypeIndex: number = 0
  @Provide streamUsageIndex: number = 0

  mapContentIndexToType(index) {
    // map the index of options to the content type in @ohos.multimedia.audio
    let type
    if (index === 6) {
      type = 9
    } else {
      type = index
    }
    return type
  }

  mapStreamIndexToUsage(index) {
    // map the index of options to the stream usage in @ohos.multimedia.audio
    let usage
    if (index === 5) {
      usage = 6
    } else if (index === 6) {
      usage = 8
    } else if (index === 7) {
      usage = 9
    } else {
      usage = index
    }
    return usage
  }

  build() {
    Column() {
      Column() {
        Row() {
          Navigation() {
            NavRouter() {
              NavDestination() {
              }
            }
            .onStateChange(async (isActivated: boolean) => {
              console.info("hello")
              await router.pushUrl({ url: 'pages/Index' })
            })
          }
          .id('back_btn_preset')
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
                .fontSize(16)
                .fontWeight(500)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              if (this.showSelector_1) {
                Image($r('app.media.ic_arrow_up_small')).height(7).width(10)
                  .margin({ left: 8 })
              } else {
                Image($r('app.media.ic_arrow_down_small')).height(7).width(10)
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
          .id('select_content_preset')
          .onClick(() => {
            this.showSelector_1 = !this.showSelector_1
            this.showSelector_2 = false
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
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              if (this.showSelector_2) {
                Image($r('app.media.ic_arrow_up_small')).height(7).width(10)
                  .margin({ left: 8 })
              } else {
                Image($r('app.media.ic_arrow_down_small')).height(7).width(10)
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
          .id('select_usage_preset')
          .onClick(() => {
            this.showSelector_1 = false
            this.showSelector_2 = !this.showSelector_2;
          })

          if (this.showSelector_2) {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
              ForEach(this.streamUsageOptions, item => {
                Flex() {
                  ModeItem_2({ mode: item })
                }.width(156)
                .onClick(() => {
                  if (this.streamUsageIndex !== item.id) {
                    this.streamUsageIndex = item.id
                    console.info('this.contentTypeIndex===' + this.streamUsageIndex)
                    this.queryResult = $r('app.string.BLANK')
                  }
                  this.showSelector_2 = false
                })
              }, item => item.id.toString())
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
        }
        .width(360)
        .zIndex(1)

        Column() {
          Row() {
            Text($r('app.string.SYSTEM_PRESET_AUDIO_EFFECT'))
              .fontSize(16)
              .fontWeight(500)
              .height(20)
              .width(96)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            Button($r('app.string.QUERY'), { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor('rgba(24,36,49,0.05)')
              .fontColor('#007DFF')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontWeight(500)
              .height(28)
              .width(72)
              .onClick(async () => {
                console.info('Button onClick')
                this.audioManager = audio.getAudioManager()
                this.audioStreamManager = this.audioManager.getStreamManager()
                this.audioEffectInfoArray = await this.audioStreamManager
                  .getAudioEffectInfoArray(this.mapContentIndexToType(this.contentTypeIndex), this.mapStreamIndexToUsage(this.streamUsageIndex))
                console.info('audioEffectInfoArray:' + this.audioEffectInfoArray)
                if (this.audioEffectInfoArray.indexOf(1) == -1) {
                  this.queryResult = $r('app.string.EFFECT_NONE')
                } else {
                  this.queryResult = $r('app.string.EFFECT_NONE_AND_DEFAULT')
                }
                console.info('query result:' + this.queryResult)
              })
              .id('query_btn_preset')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('50%')
          .width('100%')

          Row() {
          }
          .height(1).width('100%')
          .backgroundColor('#F1F3F5')

          Row() {
            Text($r('app.string.QUERY_RESULT'))
              .fontSize(16)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            Text(this.queryResult)
              .fontSize(14)
              .fontWeight(400)
              .enabled(false)
              .fontColor(Color.Grey)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .id('query_result_preset')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('50%')
          .width('100%')

        }
        .height(104)
        .width(360)
        .backgroundColor(Color.White)
        .padding({ left: 12, right: 12 })
        .borderRadius(20)
        .zIndex(0)
      }

      Row() {
        Column() {
          Image($r('app.media.ic_Silent_select'))
            .width(24)
            .height(24)
            .margin({ top: 7, bottom: 4 })

          Text($r('app.string.PRESET_AUDIO_EFFECT_QUERY'))
            .fontSize(10)
            .height(14)
            .fontColor('#007DFF')
        }
        .height(56)
        .width(156)
        .margin({ left: 24 })

        Column() {
          Image($r('app.media.ic_Sound_normal'))
            .width(24)
            .height(24)
            .margin({ top: 7, bottom: 4 })

          Text($r('app.string.REALTIME_AUDIO_EFFECT_SETTING'))
            .fontSize(10)
            .height(14)

        }
        .height(56)
        .width(156)
        .margin({ right: 24 })
        .id('switch_btn_preset')
        .onClick(async () => {
          await router.replaceUrl({ url: 'pages/RealtimeEffect' })
        })
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
    })
  }
}



