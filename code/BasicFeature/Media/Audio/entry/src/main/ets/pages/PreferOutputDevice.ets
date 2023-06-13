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

@Entry
@Component
struct PreferOutputDevice {
  private appContext: common.Context = null
  private audioRendererOption = {
    streamInfo: {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
      channels: audio.AudioChannel.CHANNEL_2,
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
    },
    rendererInfo: {
      content: audio.ContentType.CONTENT_TYPE_SPEECH,
      usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
      rendererFlags: 0
    }
  }
  private audioRenderer = null
  private audioSource = 'test1.wav'
  private fileDescriptor = null
  private audioRoutingManager = null
  @State preferOutputDeviceName: string = ''

  async aboutToAppear() {
    this.init()
  }

  async init() {
    if (this.appContext !== null) {
      return
    }
    this.appContext = getContext()
    let audioManager = audio.getAudioManager()
    this.audioRoutingManager = audioManager.getRoutingManager()
    this.audioRoutingManager.on('deviceChange', audio.DeviceFlag.OUTPUT_DEVICES_FLAG, async (deviceChanged) => {
      await this.getPreferOutputDeviceForRendererInfo()
    })
    await this.getPreferOutputDeviceForRendererInfo()
    await this.getStageFileDescriptor(this.audioSource).then((res) => {
      this.fileDescriptor = res
    })
    await this.renderPlay()
  }

  async over() {
    this.appContext = null
    if (this.audioRenderer !== null) {
      await this.audioRenderer.release()
      this.audioRenderer = null
    }
    if (this.fileDescriptor !== null) {
      this.closeResource(this.audioSource)
      this.fileDescriptor = null
    }
    this.audioRoutingManager = null
  }

  async onBackPress() {
    this.over()
  }

  async onPageHide() {
    this.over()
  }

  onPageShow() {
    this.init()
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

  getPreferOutputDeviceForRendererInfo() {
    this.audioRoutingManager.getPreferOutputDeviceForRendererInfo(this.audioRendererOption.rendererInfo)
      .then(data => {
        this.preferOutputDeviceName = this.getDeviceList(data[0])
      }).catch(err => {
      this.preferOutputDeviceName = 'Invalid'
      console.log(`getPreferOutputDeviceForRendererInfo err:${JSON.stringify(err)}`)
    })
  }

  getZNDeviceTypeName(deviceTypeName) {
    let map = {
      'EARPIECE': this.appContext.resourceManager.getStringSync($r('app.string.EarPiece').id),
      'SPEAKER': this.appContext.resourceManager.getStringSync($r('app.string.Speaker').id),
      'WIRED_HEADSET': this.appContext.resourceManager.getStringSync($r('app.string.WiredHeadset').id),
      'WIRED_HEADPHONES': this.appContext.resourceManager.getStringSync($r('app.string.WiredHeadPhones').id),
      'BLUETOOTH_A2DP': this.appContext.resourceManager.getStringSync($r('app.string.Bluetooth_A2DP').id),
      'BLUETOOTH_SCO': this.appContext.resourceManager.getStringSync($r('app.string.BLUETOOTH_SCO').id),
      'USB_HEADSET': this.appContext.resourceManager.getStringSync($r('app.string.USB_Headset').id)
    }
    if (map[deviceTypeName]) {
      return map[deviceTypeName]
    } else {
      return 'Invalid'
    }
  }

  getDeviceList(deviceDescriptor) {
    let deviceTypeName = this.getDeviceTypeNameByValue(deviceDescriptor.deviceType)
    return this.getZNDeviceTypeName(deviceTypeName)
  }

  getDeviceTypeNameByValue(value) {
    for (let key in audio.DeviceType) {
      if (audio.DeviceType[key] == value) {
        return key
      }
    }
  }

  async renderPlay() {
    if (this.audioRenderer !== null) {
      return
    }
    try {
      this.audioRenderer = await audio.createAudioRenderer(this.audioRendererOption)
    } catch (err) {
      console.error(`audioRenderer create : Error: ${JSON.stringify(err)}`)
      return
    }
    let bufferSize
    try {
      bufferSize = await this.audioRenderer.getBufferSize()
      await this.audioRenderer.start()
    } catch (err) {
      console.error(`audioRenderer start : Error: ${JSON.stringify(err)}`)
      return
    }

    try {
      let startOffset = this.fileDescriptor.offset
      let cur = startOffset
      let buf = new ArrayBuffer(bufferSize)
      while (true) {
        // when render released,state is changed to STATE_RELEASED
        if (this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
          break
        }
        while (cur <= startOffset + this.fileDescriptor.length) {
          // when render released,state is changed to STATE_RELEASED
          if (this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
            break
          }
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
    } catch (err) {
      console.error(`audioRenderer write : Error: ${JSON.stringify(err)}`)
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
        .title($r('app.string.SelectOutputDevice'))
        .mode(NavigationMode.Stack)
      }.height(56).width('100%').id('back_btn')
      .onClick(async () => {
        await router.pushUrl({ url: 'pages/Index' })
      })

      Column() {
        Row() {
          Row() {
            Image($r('app.media.ic_call')).width(48).height(48)
            Text($r('app.string.VoiceCallType'))
              .fontSize(16)
              .margin({ left: 12 })
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .fontWeight(500)
          }

          Row() {
            Text(this.preferOutputDeviceName)
              .id('device_name_text')
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .fontWeight(400)
              .opacity(0.6)
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(72)
        .width('100%')
        .padding({ left: '3.35%', right: '3.35%' })
        .backgroundColor(Color.White)
        .borderRadius(24)
      }.padding({ left: '3.35%', right: '3.35%' })
    }
    .height('100%').width('100%').backgroundColor('#f1f3f5')
  }
}