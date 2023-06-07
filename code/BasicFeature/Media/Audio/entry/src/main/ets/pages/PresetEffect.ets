import common from '@ohos.app.ability.common'
import audio from '@ohos.multimedia.audio'
import router from '@ohos.router'

@Entry
@Component
struct DetectPresetEffect {
  private contentTypeString = ''
  private streamUsageString = ''
  private appContext: common.Context
  private audioEffectInfoArray = [null, null]
  private audioManager = undefined
  private audioStreamManager = undefined
  @State queryResult: Resource = $r('app.string.BLANK')
  @State contentTypeIndex: number = 0
  @State streamUsageIndex: number = 0
  private contentTypeOptions = [{ value: $r('app.string.CONTENT_TYPE_UNKNOWN') },
    { value: $r('app.string.CONTENT_TYPE_SPEECH') },
    { value: $r('app.string.CONTENT_TYPE_MUSIC') },
    { value: $r('app.string.CONTENT_TYPE_MOVIE') },
    { value: $r('app.string.CONTENT_TYPE_SONIFICATION') },
    { value: $r('app.string.CONTENT_TYPE_RINGTONE') }
  // { value: $r('app.string.CONTENT_TYPE_ULTRASONIC')}
  ]
  private streamUsageOptions = [{ value: $r('app.string.STREAM_USAGE_UNKNOWN') },
    { value: $r('app.string.STREAM_USAGE_MEDIA') },
    { value: $r('app.string.STREAM_USAGE_VOICE_COMMUNICATION') },
    { value: $r('app.string.STREAM_USAGE_VOICE_ASSISTANT') },
    { value: $r('app.string.STREAM_USAGE_ALARM') },
    { value: $r('app.string.STREAM_USAGE_NOTIFICATION_RINGTONE') },
    { value: $r('app.string.STREAM_USAGE_ACCESSIBILITY') }
  // { value: $r('app.string.STREAM_USAGE_SYSTEM')}
  ]

  async aboutToAppear() {
    this.appContext = getContext()
    this.contentTypeString = this.appContext.resourceManager.getStringSync(this.contentTypeOptions[this.contentTypeIndex].value.id)
    this.streamUsageString = this.appContext.resourceManager.getStringSync(this.streamUsageOptions[this.streamUsageIndex].value.id)
  }

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
          Image($r('app.media.ic_back')).width(20).height(18).margin({ left: 2 })
          Text($r('app.string.EffectManager')).fontSize(20).fontWeight(FontWeight.Bold).margin({ left: 16 })
        }
        .onClick(async () => {
          await router.pushUrl({ url: 'pages/Index' })
        })
        .id('back_btn_preset')
        .height(28)
        .width('100%')
        .margin({ top: 12 })
        .onClick(async () => {
          await router.pushUrl({ url: 'pages/Index' })
        })
        .width(360)


        Row() {
          Select(this.contentTypeOptions)
            .selected(this.contentTypeIndex)
            .value(this.contentTypeString)
            .font({ size: 16, weight: 500, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
            .optionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFontColor('#007DFF')
            .onSelect((index: number) => {
              console.info("Select:" + index)
              this.contentTypeIndex = index
              this.queryResult = $r('app.string.BLANK')
              this.contentTypeString = this.appContext.resourceManager.getStringSync(this.contentTypeOptions[index].value.id)
            })
            .backgroundColor('#F1F3F5')
            .id('select_content_preset')
            .height(40)
            .margin({ left: 12, right: 12 })

          Select(this.streamUsageOptions)
            .selected(this.streamUsageIndex)
            .value(this.streamUsageString)
            .font({ size: 16, weight: 500, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
            .optionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFontColor('#007DFF')
            .onSelect((index: number) => {
              console.info("Select:" + index)
              this.streamUsageIndex = index
              console.info("StreamUsage:" + this.streamUsageIndex)
              this.queryResult = $r('app.string.BLANK')
              this.streamUsageString = this.appContext.resourceManager.getStringSync(this.streamUsageOptions[index].value.id)
            })
            .backgroundColor('#F1F3F5')
            .height(40)
            .margin({ left: 12, right: 12 })
            .id('select_usage_preset')
        }
        .margin({ top: 15 })

        Column() {
          Row() {
            Text($r('app.string.SYSTEM_PRESET_AUDIO_EFFECT'))
              .fontSize(16)
              .fontWeight(500)
              .height(20)
              .width(96)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .margin({ left: 12 })
            Button($r('app.string.QUERY'), { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor(0xF5F5F5)
              .fontColor(0x1E90FF)
              .fontSize(12)
              .fontWeight(500)
              .height(28)
              .width(72)
              .margin({ right: 12 })
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

                this.audioEffectInfoArray.sort()
                console.info('query result:' + this.queryResult)
              })
              .id('query_btn_preset')

          }
          //.margin({ left:12,right: 12 })
          .justifyContent(FlexAlign.SpaceBetween)
          .height('50%')
          .width('100%')

          Row() {
          }
          .height(1).width(312)
          .backgroundColor('#F1F3F5')

          Row() {
            Text($r('app.string.QUERY_RESULT'))
              .fontSize(16)
              .fontWeight(500)
              .margin({ left: 12 })
            Text(this.queryResult)
              .fontSize(16)
              .fontWeight(400)
              .enabled(false)
              .fontColor(Color.Grey)
              .margin({ right: 12 })
              .id('query_result_preset')
          }
          // .margin({ left:12,right: 12 })
          .justifyContent(FlexAlign.SpaceBetween)
          .height('50%')
          .width('100%')

        }
        .height(104)
        .width(360)
        .backgroundColor(Color.White)
        //.margin({left: 12, right: 12 })
        .borderRadius(20)
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

  }
}

