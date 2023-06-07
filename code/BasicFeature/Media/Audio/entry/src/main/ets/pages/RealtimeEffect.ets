import common from '@ohos.app.ability.common'
import fs from '@ohos.file.fs'
import audio from '@ohos.multimedia.audio'
import router from '@ohos.router'

@Entry
@Component
struct RealtimeAudioEffectQuery {
  private audioRenderer = null
  private audioSource = 'test1.wav'
  private appContext: common.Context
  private fileDescriptor = null
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
  //{ value: $r('app.string.STREAM_USAGE_SYSTEM')}
  ]
  private contentTypeString = ''
  private streamUsageString = ''
  private currentAudioEffectString = ''
  private audioEffectModeSettingOptions = [{ value: $r('app.string.EFFECT_NONE') }, {
    value: $r('app.string.EFFECT_DEFAULT')
  }]
  private audioPlayState: Array<string> = ['notPlaying', 'onPlaying']
  private stateImg: Array<Resource> = [$r('app.media.ic_play'), $r('app.media.ic_pause')]
  @State audioEffectModeSettingString: string = ''
  @State stateTextIndex: number = 0
  @State contentTypeIndex: number = 0
  @State streamUsageIndex: number = 0
  @State stateImgIndex: number = 0
  @State optionsButtonState: boolean = true
  @State queryButtonState: boolean = true
  @State currentAudioEffect: Resource = $r('app.string.EFFECT_DEFAULT')
  @State queryResult: Resource = $r('app.string.BLANK')
  @State audioEffectModeSettingIndex: number = 1

  async getStageFileDescriptor(fileName: string) {
    let fileDescriptor = undefined
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
    this.contentTypeString = this.appContext.resourceManager.getStringSync(this.contentTypeOptions[this.contentTypeIndex].value.id)
    this.streamUsageString = this.appContext.resourceManager.getStringSync(this.streamUsageOptions[this.streamUsageIndex].value.id)
    this.currentAudioEffectString = this.appContext.resourceManager.getStringSync(this.currentAudioEffect.id)
    this.audioEffectModeSettingString = this.appContext.resourceManager.getStringSync(this.audioEffectModeSettingOptions[this.audioEffectModeSettingIndex].value.id)
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
    let type
    if (index === 6) {
      type = 9
    } else {
      type = index
    }
    return type
  }

  mapStreamIndexToUsage(index: number) {
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
    } catch (err) {
      console.error(`audioRenderer create ,Error: ${JSON.stringify(err)}`)
      return
    }

    await this.audioRenderer.setAudioEffectMode(this.audioEffectModeSettingIndex)

    try {
      await this.audioRenderer.start()
    } catch (err) {
      console.error(`audioRenderer start ,Error: ${JSON.stringify(err)}`)
      return
    }


    let bufferSize = await this.audioRenderer.getBufferSize()
    console.info("buffer size:" + bufferSize)
    await this.getStageFileDescriptor(this.audioSource).then((res) => {
      this.fileDescriptor = res
    })

    let buf = new ArrayBuffer(bufferSize)
    let startOffset = this.fileDescriptor.offset
    let cur = startOffset
    while (true) {
      // when render released,state is changed to STATE_RELEASED
      if (this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
        break
      }
      while (cur <= startOffset + this.fileDescriptor.length) {
        let options = {
          offset: cur,
          length: bufferSize
        }
        await fs.read(this.fileDescriptor.fd, buf, options)
        await this.audioRenderer.write(buf)
        cur += bufferSize
      }
      cur = startOffset
    }
  }

  async playOrPause() {
    if (this.stateImgIndex === 0) {
      if (this.audioRenderer === null || this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
        this.stateImgIndex = 1
        this.stateTextIndex = 1
        this.optionsButtonState = false
        this.queryButtonState = true
        this.createAudioEffectAndPlay()
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
          this.queryButtonState = true
          this.createAudioEffectAndPlay()
        } else {
          await this.audioRenderer.start()
          this.stateImgIndex = 1
          this.stateTextIndex = 1
          this.optionsButtonState = false
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
    }

  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.ic_back')).width(20).height(18).margin({ left: 2 })
          Text($r('app.string.EffectManager')).fontSize(20).fontWeight(FontWeight.Bold).margin({ left: 16 })
        }
        .id('back_btn_realtime')
        .height(28)
        .width('100%')
        .margin({ top: 12 })
        .onClick(async () => {
          if (this.audioRenderer != null) {
            await this.audioRenderer.stop()
            await this.audioRenderer.release()
          }
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
            .enabled(this.optionsButtonState)
            .id('select_content_realtime')
            .onSelect((index: number) => {
              console.info("Select:" + index)
              this.contentTypeIndex = index
              this.contentTypeString = this.appContext.resourceManager.getStringSync(this.contentTypeOptions[index].value.id)
              this.audioEffectModeSettingIndex = 1
              this.audioEffectModeSettingString = this.appContext.resourceManager.getStringSync(this.audioEffectModeSettingOptions[this.audioEffectModeSettingIndex].value.id)
              this.queryResult = $r('app.string.BLANK')
              this.queryButtonState = false
            })
            .backgroundColor('#F1F3F5')
            .height(40)
            .margin({ left: 12, right: 12 })

          Select(this.streamUsageOptions)
            .selected(this.streamUsageIndex)
            .value(this.streamUsageString)
            .font({ size: 16, weight: 500, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
            .optionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFontColor('#007DFF')
            .enabled(this.optionsButtonState)
            .id('select_usage_realtime')
            .onSelect((index: number) => {
              console.info("Select:" + index)
              this.streamUsageIndex = index
              this.streamUsageString = this.appContext.resourceManager.getStringSync(this.streamUsageOptions[index].value.id)
              this.audioEffectModeSettingIndex = 1
              this.audioEffectModeSettingString = this.appContext.resourceManager.getStringSync(this.audioEffectModeSettingOptions[this.audioEffectModeSettingIndex].value.id)
              this.queryResult = $r('app.string.BLANK')
              this.queryButtonState = false

            })
            .backgroundColor('#F1F3F5')
            .height(40)
            .margin({ left: 12, right: 12 })
        }
        .margin({ top: 15 })

        Column() {
          Row() {
            Image(this.stateImg[this.stateImgIndex])
              .height(36)
              .width(36)
              .id('play_pause_realtime')
              .onClick(async () => {
                await this.playOrPause()
              })
            Text($r('app.string.CURRENT_AUDIO_EFFECT'))
              .fontSize(16)
              .fontWeight(500)
              .width(112)
              .height(20)
              .margin({ left: 12 })
            Text(this.audioPlayState[this.stateTextIndex])
              .fontSize(2)
              .height(20)
              .width(5)
              .fontColor(Color.White)
              .id('audio_play_state')
            Button($r('app.string.QUERY'), { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor(0xF1F3F5)
              .fontColor(0x007DFF)
              .fontSize(12)
              .height(28)
              .width(72)
              .margin({ left: 87 })
              .id('query_btn_realtime')
              .enabled(this.queryButtonState)
              .onClick(async () => {
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
                  this.currentAudioEffectString = this.appContext.resourceManager.getStringSync(this.currentAudioEffect.id)
                }
              })
          }
          .height(56).width('100%')
          .margin({ left: 24 })

          Row() {
          }
          .height(1).width(312)
          .backgroundColor('#F1F3F5')


          Row() {
            Text($r('app.string.QUERY_RESULT'))
              .fontSize(16)
              .fontWeight(500)
            Text(this.queryResult)
              .fontSize(14)
              .margin({ top: 22, right: 24 })
              .fontColor(Color.Gray)
              .id('query_result_realtime')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height(48)
          .width('100%')
          .margin({ left: 24 })

          Row() {
          }
          .height(1).width(312)
          .backgroundColor('#F1F3F5')


          Row() {
            Text($r('app.string.AUDIO_EFFECT_MODE_SETTING'))
              .fontSize(16)
              .fontWeight(500)
              .height(22)
            Select(this.audioEffectModeSettingOptions)
              .selected(this.audioEffectModeSettingIndex)
              .height(22)
              .value(this.audioEffectModeSettingString)
              .id('select_mode_realtime')
              .font({ size: 16, weight: 500, family: 'serif', style: FontStyle.Normal })
              .selectedOptionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
              .optionFont({ size: 16, weight: 400, family: 'serif', style: FontStyle.Normal })
              .selectedOptionFontColor('#007DFF')
              .onSelect(async (index: number) => {
                if (this.audioRenderer !== null && this.audioRenderer.state !== audio.AudioState.STATE_RELEASED) {
                  await this.audioRenderer.setAudioEffectMode(index)
                }
                this.audioEffectModeSettingIndex = index
                this.audioEffectModeSettingString = this.appContext.resourceManager.getStringSync(this.audioEffectModeSettingOptions[this.audioEffectModeSettingIndex].value.id)
              })
              .margin({ right: 12 })
          }
          .margin({ left: 24 })
          .height(48)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width(360)
        .height(160)
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor(Color.White)
        .margin({ bottom: 4 })
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
  }
}
