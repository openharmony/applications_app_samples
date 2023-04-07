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
import fs from '@ohos.file.fs'

@Entry
@Component
struct PreferOutputDevice {
  @State returnMsg: string = 'Hello World'
  private audioRoutingManager = null
  private contentTypeList = []
  @State selectedContentTypeKey: string = "CONTENT_TYPE_SPEECH"
  private streamUsageList = []
  @State selectedStreamUsageKey: string = "STREAM_USAGE_VOICE_COMMUNICATION"
  private audioRendererOptions = {
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
  private outputDeviceList = []
  private selectOutputDeviceList = [{ value: "无数据" }]
  @State selectedOutputIndex: number = 0
  @State outputDeviceListTag: number = 0
  private audioRenderer = null
  private audioSource = 'test1.wav'
  private fileDescriptor = null
  private skipNum = 215179

  async aboutToAppear() {

    let audioManager = audio.getAudioManager();
    this.audioRoutingManager = audioManager.getRoutingManager();

    for (let key in audio.ContentType) {
      this.contentTypeList.push({ value: key })
    }
    for (let key in audio.StreamUsage) {
      this.streamUsageList.push({ value: key })
    }
    this.getSelectOutputDeviceList()

    await this.getStageFileDescriptor(this.audioSource).then((res) => {
      this.fileDescriptor = res
    });
  }

  async getStageFileDescriptor(fileName) {
    let fileDescriptor = undefined;
    let mgr = globalThis.abilityContext.resourceManager
    await mgr.getRawFileDescriptor(fileName).then(value => {
      fileDescriptor = { fd: value.fd, offset: value.offset, length: value.length };
      console.log('case getRawFileDescriptor success fileName: ' + fileName);
    }).catch(error => {
      console.log('case getRawFileDescriptor err: ' + error);
    });
    return fileDescriptor;
  }

  async onBackPress() {
    if (this.audioRenderer !== null) {
      await this.audioRenderer.release()
      this.audioRenderer = null
    }
  }

  async getSelectOutputDeviceList() {
    let deviceFlag = audio.DeviceFlag.OUTPUT_DEVICES_FLAG
    try {
      this.outputDeviceList = await this.audioRoutingManager.getDevices(deviceFlag)
      if (this.outputDeviceList.length > 0) {
        this.selectOutputDeviceList = this.getDeviceList(this.outputDeviceList)
        this.outputDeviceListTag = 1
      }

      this.returnMsg = `输出设备查询结果:${JSON.stringify(this.selectOutputDeviceList)}`
    } catch (err) {
      this.returnMsg = `getOutputDeviceList Fail:${JSON.stringify(err)}`
    }
  }

  getPreferOutputDeviceForRendererInfoPromise() {
    this.audioRoutingManager.getPreferOutputDeviceForRendererInfo(this.audioRendererOptions.rendererInfo)
      .then(data => {
        this.returnMsg = `发声设备为：${JSON.stringify(this.getDeviceList(data))}`
      }).catch(err => {
      this.returnMsg = `getPreferOutputDeviceForRendererInfo promise Fail:${JSON.stringify(err)}`
    })
  }

  selectOutputDevice() {
    let _this = this;
    if (this.outputDeviceList.length == 0) {
      _this.returnMsg = `没有输出设备类`
      return
    }
    let outputAudioDeviceDescriptor = this.outputDeviceList.filter((value, index) => {
      return index == _this.selectedOutputIndex
    })
    if (outputAudioDeviceDescriptor.length == 0) {
      _this.returnMsg = `尚未选择输出设备`
      return
    }
    this.audioRoutingManager.selectOutputDevice(outputAudioDeviceDescriptor)
      .then(() => {
        _this.returnMsg += `所选的输出设备为:${JSON.stringify(this.getDeviceList(outputAudioDeviceDescriptor))}`
      }).catch(err => {
      _this.returnMsg = `selectOutputDevice promise Failed err:${JSON.stringify(err)}`
    })
  }

  getDeviceList(deviceDescriptors) {
    let deviceList = [];
    for (let i = 0;i < deviceDescriptors.length; i++) {
      let deviceTypeName = this.getDeviceTypeNameByValue(deviceDescriptors[i].deviceType)
      deviceList.push({ value: deviceTypeName })
    }
    return deviceList;
  }

  getDeviceTypeNameByValue(value) {
    for (let key in audio.DeviceType) {
      if (audio.DeviceType[key] == value) {
        return key;
      }
    }
  }

  async renderPlay() {
    if (this.audioRenderer !== null) {
      await this.audioRenderer.release()
      this.audioRenderer = null
    }
    try {
      this.audioRenderer = await audio.createAudioRenderer(this.audioRendererOptions)
    } catch (err) {
      this.returnMsg = `audioRenderer create : Error: ${JSON.stringify(err)}\n`
      return
    }
    let bufferSize
    try {
      bufferSize = await this.audioRenderer.getBufferSize()
      await this.audioRenderer.start()
    } catch (err) {
      this.returnMsg += `audioRenderer start : Error: ${JSON.stringify(err)}\n`
      return
    }

    try {
      let stat = await fs.stat(this.fileDescriptor.fd);
      this.returnMsg = `音频的文件大小:${JSON.stringify(stat.size)}\n`;
      let totalSize = stat.size
      let len = totalSize % bufferSize == 0 ? Math.floor(totalSize / bufferSize) : Math.floor(totalSize / bufferSize + 1);
      this.returnMsg += `文件描述符：fd:${this.fileDescriptor.fd}\n`;

      let buf = new ArrayBuffer(bufferSize);
      this.returnMsg += `音频播放开始 \n`;
      for (let i = 0;i < len; i++) {
        if (i * bufferSize < this.skipNum) {
          continue
        }
        if (this.audioRenderer.state > audio.AudioState.STATE_RUNNING) {
          break;
        }
        let options = {
          offset: i * bufferSize,
          length: bufferSize
        }

        let readsize = await fs.read(this.fileDescriptor.fd, buf, options);
        let writeSize = await this.audioRenderer.write(buf);
      }
      this.returnMsg += `音频播放结束`;
    } catch (err) {
      this.returnMsg += `audioRenderer write : Error: ${JSON.stringify(err)}\n`
    }

    await this.audioRenderer.release()
    this.audioRenderer = null;
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text("【中控台】").fontWeight(FontWeight.Bolder).position({ x: 10, y: 5 }).fontSize(18)
          Text(this.returnMsg).id("returnMsg").position({ x: 10, y: 30 }).fontSize(14)
        }.width('98%').height(120).backgroundColor(Color.Orange).position({ x: '1%' })
      }.position({ x: 0, y: 0 }).width('100%').zIndex(999)

      Scroll() {
        Column() {
          Divider().strokeWidth(6).color(Color.Blue)
          Text("渲染器信息：")
          Row() {
            Select(this.contentTypeList).value(this.selectedContentTypeKey)
              .onSelect((index, value) => {
                this.selectedContentTypeKey = value
                this.audioRendererOptions.rendererInfo.content = audio.ContentType[value]
              })
          }.margin({ top: 10 })

          Row() {
            Select(this.streamUsageList).value(this.selectedStreamUsageKey)
              .onSelect((index, value) => {
                this.selectedStreamUsageKey = value
                this.audioRendererOptions.rendererInfo.usage = audio.StreamUsage[value]
              })
          }.margin({ top: 10 })

          Divider().strokeWidth(6).color(Color.Blue)

          Row() {
            Button() {
              Text("查询发声设备")
                .fontSize(18)
                .fontColor(Color.White)
                .align(Alignment.Center)
                .lineHeight(30)
            }.id("getPreferOutputDeviceBtn").width('100%').height(60)
            .onClick(() => this.getPreferOutputDeviceForRendererInfoPromise())

          }.margin({ top: 10 }).width('100%').justifyContent(FlexAlign.SpaceBetween)

          if (this.outputDeviceListTag == 1) {
            Row() {
              Text("输出设备").fontSize(20).margin({ left: 10 })
              Select(this.selectOutputDeviceList).value(this.selectOutputDeviceList[this.selectedOutputIndex].value)
                .onSelect((index, value) => {
                  this.selectedOutputIndex = index;
                })
            }.margin({ top: 10 }).width('100%')
          }
          Row() {
            Button() {
              Text("选择发声设备").fontSize(20).fontColor(Color.White)
            }.id("selectOutputDeviceBtn").width('100%').height(60).onClick(() => this.selectOutputDevice())
          }.margin({ top: 10, bottom: 20 }).width('100%')

          Row() {
            Button() {
              Text("播放音频数据").fontSize(22).fontColor(Color.Blue)
            }.width('100%').height(60).onClick(() => this.renderPlay()).backgroundColor(Color.Pink)

          }.margin({ top: 10, bottom: 10 }).width('100%').justifyContent(FlexAlign.SpaceBetween)

        }.width('100%')
      }.margin({ top: 130 }).width('100%')
    }
  }
}