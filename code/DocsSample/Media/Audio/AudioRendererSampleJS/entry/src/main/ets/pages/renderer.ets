/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

// [Start render_process]
// [Start init_oncallback]
// [Start create_audiorender]
// [Start get_volumemanager]
// [Start get_systemvolume]
// [Start regist_volumechangecallback]
// [Start set_appvolume]
// [Start get_spacesound]
// [Start check_spacesound]
// [Start check_isspacesoundon]
// [Start regist_spacesoundcallback]
// [Start unregist_spacesoundcallback]
// [Start check_renderstate]
// [Start regist_listeningrendererchange]
// [Start create_streammanager]
// [Start regist_renderchangechallback]
// [Start get_allstreaminfo]
import { audio } from '@kit.AudioKit';
// [StartExclude get_allstreaminfo]
// [StartExclude regist_renderchangechallback]
// [StartExclude create_streammanager]
// [StartExclude regist_listeningrendererchange]
// [StartExclude check_renderstate]
// [StartExclude unregist_spacesoundcallback]
// [StartExclude regist_spacesoundcallback]
// [StartExclude check_isspacesoundon]
// [StartExclude check_spacesound]
// [StartExclude get_spacesound]
// [StartExclude set_appvolume]
// [StartExclude regist_volumechangecallback]
// [StartExclude get_volumemanager]
// [StartExclude create_audiorender]
// [StartExclude get_volumemanager]
// [Start render_start]
// [Start render_stop]
// [Start render_release]
// [Start init_callback]
// [Start Renderset_streamvolume]
// [EndExclude get_allstreaminfo]
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude get_allstreaminfo]
// [StartExclude Renderset_streamvolume]
// [StartExclude get_systemvolume]
// [StartExclude render_start]
// [StartExclude render_stop]
// [StartExclude render_release]
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
// [StartExclude init_oncallback]
// [StartExclude render_process]
// [StartExclude init_callback]
import { media } from '@kit.MediaKit';
// [EndExclude get_volumemanager]
// [EndExclude set_appvolume]
// [EndExclude get_spacesound]
// [EndExclude create_streammanager]
let audioManager = audio.getAudioManager();
// [StartExclude create_streammanager]
// [StartExclude get_spacesound]
let audioVolumeManager = audioManager.getVolumeManager();
// [StartExclude set_appvolume]
// [End get_volumemanager]
let avPlayer: media.AVPlayer;
media.createAVPlayer((error: BusinessError, video: media.AVPlayer) => {
  if (video != null) {
    avPlayer = video;
    console.info('Succeeded in creating AVPlayer');
  } else {
    console.error(`Failed to create AVPlayer. Code: ${error.code}, message: ${error.message}`);
  }
});
// [EndExclude create_streammanager]
let audioStreamManager = audioManager.getStreamManager();
// [End create_streammanager]
// [EndExclude get_spacesound]
let audioSpatializationManager = audioManager.getSpatializationManager();
// [End get_spacesound]
// [EndExclude check_spacesound]
let audioRoutingManager = audioManager.getRoutingManager();
// [StartExclude check_spacesound]
// [EndExclude render_process]
// [EndExclude init_callback]
// [EndExclude init_oncallback]
class Options {
  public offset?: number;
  public length?: number;
}
// [StartExclude init_oncallback]
// [StartExclude init_callback]
// [StartExclude render_process]
// 全局变量用于UI更新回调
let globalLogUpdate: (msg: string, isError: boolean) => void = () => {};
let globalStateUpdate: (msg: string) => void = () => {};
let globalCallbackUpdate: (msg: string) => void = () => {};
// [EndExclude render_process]

let audioRenderer: audio.AudioRenderer | undefined = undefined;
// [EndExclude create_audiorender]
let audioStreamInfo: audio.AudioStreamInfo = {
  samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率。
  channels: audio.AudioChannel.CHANNEL_2, // 通道。
  sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式。
  encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式。
};
let audioRendererInfo: audio.AudioRendererInfo = {
  usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型：音乐。根据业务场景配置，参考StreamUsage。
  rendererFlags: 0 // 音频渲染器标志。
};
let audioRendererOptions: audio.AudioRendererOptions = {
  streamInfo: audioStreamInfo,
  rendererInfo: audioRendererInfo
};
// [StartExclude create_audiorender]
let writeDataCallback: audio.AudioRendererWriteDataCallback;

async function initArguments(context: common.UIAbilityContext) {
  // [EndExclude init_callback]
  // [EndExclude init_oncallback]
  let bufferSize: number = 0;
  let file = await context.resourceManager.getRawFd('S16LE_2_48000.pcm');
  writeDataCallback = (buffer: ArrayBuffer) => {
    let options: Options = {
      offset: bufferSize + file.offset,
      length: buffer.byteLength
    };
    // [StartExclude init_callback]
    if (bufferSize > file.length) {
      return audio.AudioDataCallbackResult.INVALID;
    }
    try {
      let bufferLength = fs.readSync(file.fd, buffer, options);
      bufferSize += buffer.byteLength;
      // 系统会判定buffer有效，正常播放
      // [StartExclude init_oncallback]
      if (bufferSize > file.length) {
        let view = new DataView(buffer);
        for (let i = bufferSize - file.length; i < buffer.byteLength; i++) {
          // 空白区域填充静音数据。当使用音频采样格式为SAMPLE_FORMAT_U8时0x7F为静音数据，使用其他采样格式时0为静音数据。
          view.setUint8(i, 0);
        }
      }
      // API version 11不支持返回回调结果，从API version 12开始支持返回回调结果。
      // 如果开发者不希望播放某段buffer，返回audio.AudioDataCallbackResult.INVALID即可。
      // [EndExclude init_oncallback]
      return audio.AudioDataCallbackResult.VALID;
    } catch (error) {
      console.error(`Failed to read file. Code: ${error.code}, message: ${error.message}`);
      // [StartExclude render_process]
      // 系统会判定buffer无效，不播放
      // [StartExclude init_oncallback]
      globalLogUpdate(`Failed to read file. Code: ${error.code}, message: ${error.message}`, true);
      // [EndExclude render_process]
      // API version 11不支持返回回调结果，从API version 12开始支持返回回调结果。
      // [EndExclude init_oncallback]
      return audio.AudioDataCallbackResult.INVALID;
    }
  };
  // [StartExclude init_oncallback]
}

// 初始化，创建实例，设置监听事件。
async function init() {
  // [EndExclude create_audiorender]
  audio.createAudioRenderer(audioRendererOptions, (err, renderer) => { // 创建AudioRenderer实例。
    if (!err) {
      console.info('Succeeded in creating audio renderer.');
      // [StartExclude create_audiorender]
      // [StartExclude render_process]
      globalLogUpdate('Succeeded in creating audio renderer.', false);
      // [EndExclude render_process]
      // [EndExclude create_audiorender]
      audioRenderer = renderer;
      if (audioRenderer !== undefined) {
        // [EndExclude init_callback]
        // [EndExclude init_oncallback]
        audioRenderer.on('writeData', writeDataCallback);
        // [End init_oncallback]
        // [End init_callback]
        // [StartExclude render_process]
        // [StartExclude create_audiorender]
        // 自动启动监听
        registListeningStateChange();
        listenvolume();
        listenRenderChange();
        // [EndExclude render_process]
        // [EndExclude create_audiorender]
      }
    } else {
      console.info(`Failed to create audio renderer. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude render_process]
      globalLogUpdate(`Failed to create audio renderer. Code: ${err.code}, message: ${err.message}`, false);
      // [EndExclude render_process]
    }
  });
  // [End create_audiorender]
}

// 开始一次音频渲染。
async function start() {
  if (audioRenderer !== undefined) {
    let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    if (stateGroup.indexOf(audioRenderer.state.valueOf()) === -1) { // 当且仅当状态为prepared、paused和stopped之一时才能启动渲染。
      console.error('Audio renderer state is invalid.');
      // [StartExclude render_process]
      globalLogUpdate('Audio renderer state is invalid.', true);
      // [EndExclude render_process]
      return;
    }
    // 启动渲染。
    // [EndExclude render_start]
    audioRenderer.start((err: BusinessError) => {
      if (err) {
        console.error(`Failed to start audio renderer. Code: ${err.code}, message: ${err.message}`);
        // [StartExclude render_start]
        // [StartExclude render_process]
        globalLogUpdate(`Failed to start audio renderer. Code: ${err.code}, message: ${err.message}`, true);
        // [EndExclude render_process]
        // [EndExclude render_start]
      } else {
        console.info('Succeeded in starting audio renderer.');
        // [StartExclude render_start]
        // [StartExclude render_process]
        globalLogUpdate('Succeeded in starting audio renderer.', false);
        // [EndExclude render_process]
        // [EndExclude render_start]
      }
    });
    // [End render_start]
  }
}

async function pause() {
  // 暂停渲染。
  if (audioRenderer !== undefined) {
    // 只有渲染器状态为running的时候才能暂停。
    if (audioRenderer.state.valueOf() !== audio.AudioState.STATE_RUNNING) {
      console.info('Audio renderer state is not running.');
      // [StartExclude render_process]
      globalLogUpdate('Audio renderer state is not running.', false);
      // [EndExclude render_process]
      return;
    }
    // 暂停渲染。
    audioRenderer.pause((err: BusinessError) => {
      if (err) {
        console.error(`Failed to pause audio renderer. Code: ${err.code}, message: ${err.message}`);
        // [StartExclude render_process]
        globalLogUpdate(`Failed to pause audio renderer. Code: ${err.code}, message: ${err.message}`, true);
        // [EndExclude render_process]
      } else {
        console.info('Succeeded in pausing audio renderer.');
        // [StartExclude render_process]
        globalLogUpdate('Succeeded in pausing audio renderer.', false);
        // [EndExclude render_process]
      }
    });
  }
}

// 停止渲染。
async function stop() {
  if (audioRenderer !== undefined) {
    // 只有渲染器状态为running或paused的时候才可以停止。
    if (audioRenderer.state.valueOf() !== audio.AudioState.STATE_RUNNING &&
      audioRenderer.state.valueOf() !== audio.AudioState.STATE_PAUSED) {
      console.info('Audio renderer state is not running or paused.');
      // [StartExclude render_process]
      globalLogUpdate('Audio renderer state is not running or paused.', false);
      // [EndExclude render_process]
      return;
    }
    // 停止渲染。
    // [EndExclude render_stop]
    audioRenderer.stop((err: BusinessError) => {
      if (err) {
        console.error(`Failed to stop audio renderer. Code: ${err.code}, message: ${err.message}`);
        // [StartExclude render_stop]
        // [StartExclude render_process]
        globalLogUpdate(`Failed to stop audio renderer. Code: ${err.code}, message: ${err.message}`, true);
        // [EndExclude render_process]
        // [EndExclude render_stop]
      } else {
        console.info('Succeeded in stopping audio renderer.');
        // [StartExclude render_stop]
        // [StartExclude render_process]
        globalLogUpdate('Succeeded in stopping audio renderer.', false);
        // [EndExclude render_process]
        // [EndExclude render_stop]
      }
    });
    // [End render_stop]
  }
}

// 销毁实例，释放资源。
async function release() {
  if (audioRenderer !== undefined) {
    // 渲染器状态不是released状态，才能release。
    if (audioRenderer.state.valueOf() === audio.AudioState.STATE_RELEASED) {
      console.info('Audio renderer state is released.');
      // [StartExclude render_process]
      globalLogUpdate('Audio renderer state is released.', false);
      // [EndExclude render_process]
      return;
    }

    // [StartExclude render_process]
    // 先取消所有监听
    offlistenRenderChange();
    audioVolumeManager.off('streamVolumeChange');
    console.info('Succeeded in using off streamVolumeChange.');
    globalLogUpdate('Succeeded in using off streamVolumeChange.', false);
    // [EndExclude render_process]

    // 释放资源。
    // [EndExclude render_release]
    audioRenderer.release((err: BusinessError) => {
      if (err) {
        console.error(`Failed to release audio renderer. Code: ${err.code}, message: ${err.message}`);
        // [StartExclude render_release]
        // [StartExclude render_process]
        globalLogUpdate(`Failed to release audio renderer. Code: ${err.code}, message: ${err.message}`, true);
        // [EndExclude render_process]
        // [EndExclude render_release]
      } else {
        // 关闭沙箱文件
        console.info('Succeeded in releasing audio renderer.');
        // [StartExclude render_release]
        // [StartExclude render_process]
        globalLogUpdate('Succeeded in releasing audio renderer.', false);
        // [EndExclude render_process]
        // [EndExclude render_release]
      }
    });
    // [End render_release]
  }
}
// [End render_process]
async function getvolume(){
  // [EndExclude get_systemvolume]
  // 获取指定流的音量。
  let streamVolume = audioVolumeManager.getVolumeByStream(audio.StreamUsage.STREAM_USAGE_MUSIC);
  // [StartExclude get_systemvolume]
  // [EndExclude get_systemvolume]
  // 获取指定流的最小音量。
  let minVolume = audioVolumeManager.getMinVolumeByStream(audio.StreamUsage.STREAM_USAGE_MUSIC);

  // 获取指定流的最大音量。
  let maxVolume = audioVolumeManager.getMaxVolumeByStream(audio.StreamUsage.STREAM_USAGE_MUSIC);
  // [End get_systemvolume]
  globalLogUpdate(`stream MUSIC Volume: ${streamVolume}, maxVolume: ${maxVolume}, minVolume: ${minVolume}`, false);
}

async function listenvolume(){
  // [EndExclude regist_volumechangecallback]
  audioVolumeManager.on('streamVolumeChange', audio.StreamUsage.STREAM_USAGE_MUSIC,
    (streamVolumeEvent: audio.StreamVolumeEvent) => {
    console.info(`Succeeded in using on function. StreamVolumeEvent: ${JSON.stringify(streamVolumeEvent)}`);
    // [StartExclude regist_volumechangecallback]
    globalCallbackUpdate(`Succeeded in using on function. StreamVolumeEvent: ${JSON.stringify(streamVolumeEvent)}`);
    // [EndExclude regist_volumechangecallback]
  });
  // [End regist_volumechangecallback]
}

async function setAPPvolume(){
  // [EndExclude set_appvolume]
  // 设置应用的音量（范围为0到100）。
  audioVolumeManager.setAppVolumePercentage(20).then(() => {
    console.info('Succeeded in setting app volume percentage.');
    // [StartExclude set_appvolume]
    globalLogUpdate('Succeeded in setting app volume percentage.', false);
    // [EndExclude set_appvolume]
  });

  // 查询应用音量。
  audioVolumeManager.getAppVolumePercentage().then((value: number) => {
    console.info(`Succeeded in getting app volume percentage, app volume is ${value}.`);
    // [StartExclude set_appvolume]
    globalLogUpdate(`Succeeded in getting app volume percentage, app volume is ${value}.`, false);
    // [EndExclude set_appvolume]
  });

  // 监听应用音量变化，on方法和off方法传入callback参数一致，off方法取消对应on方法订阅的监听。
  let appVolumeChangeCallback = (volumeEvent: audio.VolumeEvent) => {
    console.info(`Succeeded in using on or off function. VolumeEvent: ${JSON.stringify(volumeEvent)}`);
    // [StartExclude set_appvolume]
    globalCallbackUpdate(`Succeeded in using on or off function. VolumeEvent: ${JSON.stringify(volumeEvent)}`);
    // [EndExclude set_appvolume]
  };
  audioVolumeManager.on('appVolumeChange', appVolumeChangeCallback);
  audioVolumeManager.off('appVolumeChange', appVolumeChangeCallback);
  // [End set_appvolume]
}

async function setStreamVolume(){
  if (audioRenderer) {
    // [Start AVPlayerset_streamvolume]
    let volume = 1.0;  // 指定的音量大小，取值范围为[0.00-1.00]，1表示最大音量。
    avPlayer.setVolume(volume);
    // [End AVPlayerset_streamvolume]
    // [EndExclude Renderset_streamvolume]
    // 设置音频流音量。
    audioRenderer.setVolume(0.5).then(() => {  // 音量范围为[0.0-1.0]。
      console.info('Succeeded in setting volume.'');
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate('Succeeded in setting volume.', false);
      // [EndExclude Renderset_streamvolume]
    }).catch((err: BusinessError) => {
      console.error(`Failed to set volume. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate(`Failed to set volume. Code: ${err.code}, message: ${err.message}`, true);
      // [EndExclude Renderset_streamvolume]
    });

    // 获取音频流音量。
    try {
      let value: number = audioRenderer.getVolume();
      console.info(`Succeeded in getting volume, volume is ${value}.`);
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate(`Succeeded in getting volume, volume is ${value}.`, false);
      // [EndExclude Renderset_streamvolume]
    } catch (err) {
      let error = err as BusinessError;
      console.error(`Failed to get volume. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate(`Failed to get volume. Code: ${err.code}, message: ${err.message}`, true);
      // [EndExclude Renderset_streamvolume]
    }
    // [End Renderset_streamvolume]
  } else {
    console.info('renderer is not created.');
    globalLogUpdate('renderer is not created.', false);
  }
}

async function getDevicesSync(){
  // [EndExclude check_spacesound]
  let deviceDescriptors = audioRoutingManager.getDevicesSync(audio.DeviceFlag.OUTPUT_DEVICES_FLAG);
  console.info(`Succeeded in getting devices, AudioDeviceDescriptors: ${JSON.stringify(deviceDescriptors)}.`);
  // [End check_spacesound]
  globalLogUpdate(`Succeeded in getting devices, AudioDeviceDescriptors: ${JSON.stringify(deviceDescriptors)}.`, false);
}

async function getStatus(){
  // [EndExclude check_isspacesoundon]
  let isSpatializationEnabledForCurrentDevice = audioSpatializationManager.isSpatializationEnabledForCurrentDevice();
  console.info(`Succeeded in using isSpatializationEnabledForCurrentDevice function,
   IsSpatializationEnabledForCurrentDevice: ${isSpatializationEnabledForCurrentDevice}.`);
  // [End check_isspacesoundon]
  globalLogUpdate(`Succeeded in using isSpatializationEnabledForCurrentDevice function,
   IsSpatializationEnabledForCurrentDevice: ${isSpatializationEnabledForCurrentDevice}.`, false);
}

async function on(){
  // [EndExclude regist_spacesoundcallback]
  audioSpatializationManager.on('spatializationEnabledChangeForCurrentDevice',
    (isSpatializationEnabledForCurrentDevice: boolean) => {
    console.info(`Succeeded in using on function, IsSpatializationEnabledForCurrentDevice:
     ${isSpatializationEnabledForCurrentDevice}.`);
    // [StartExclude regist_spacesoundcallback]
    globalCallbackUpdate(`Succeeded in using on function, IsSpatializationEnabledForCurrentDevice:
     ${isSpatializationEnabledForCurrentDevice}.`);
    // [EndExclude regist_spacesoundcallback]
  });
  // [End regist_spacesoundcallback]
  globalLogUpdate(`Succeeded in regist isSpatializationEnabledForCurrentDevice callback`, false);
}

async function off() {
  // [EndExclude unregist_spacesoundcallback]
  audioSpatializationManager.off('spatializationEnabledChangeForCurrentDevice');
  // [End unregist_spacesoundcallback]
  globalLogUpdate(`Succeeded in unregist isSpatializationEnabledForCurrentDevice callback`, false);
}

async function getRendererState(){
  if (audioRenderer != null) {
    // [EndExclude check_renderstate]
    let audioRendererState: audio.AudioState = audioRenderer.state;
    console.info(`Current state is: ${audioRendererState}`);
    // [End check_renderstate]
    globalLogUpdate(`Current state is: ${audioRendererState}`, false);
  } else {
    console.info('audio renderer is null')
    globalLogUpdate('audio renderer is null', false);
  }
}

async function registListeningStateChange() {
  if (audioRenderer != null) {
    // [EndExclude regist_listeningrendererchange]
    audioRenderer.on('stateChange', (rendererState: audio.AudioState) => {
      console.info(`Succeeded in using on function, state change to: ${rendererState}`);
      // [StartExclude regist_listeningrendererchange]
      globalCallbackUpdate(`Succeeded in using on function, state change to: ${rendererState}`);
      // [EndExclude regist_listeningrendererchange]
    });
    // [End regist_listeningrendererchange]
  } else {
    console.info('audio renderer is null')
    globalLogUpdate('audio renderer is null', false);
  }
}

async function listenRenderChange() {
  // [EndExclude regist_renderchangechallback]
  audioStreamManager.on('audioRendererChange',  (audioRendererChangeInfoArray: audio.AudioRendererChangeInfoArray) => {
    console.info(`Succeeded in using on function. AudioRendererChangeInfoArray: ${JSON.stringify(audioRendererChangeInfoArray)}`);
    globalLogUpdate(`Succeeded in using on function. AudioRendererChangeInfoArray: ${JSON.stringify(audioRendererChangeInfoArray)}`, false);
  });
  // [End regist_renderchangechallback]
}

async function offlistenRenderChange(){
  // [Start unregist_renderchangechallback]
  audioStreamManager.off('audioRendererChange');
  console.info('Succeeded in using off function.');
  // [End unregist_renderchangechallback]
  globalLogUpdate('Succeeded in using off function.', false);
}

// [EndExclude get_allstreaminfo]
async function getCurrentAudioRendererInfoArray(): Promise<void> {
  await audioStreamManager.getCurrentAudioRendererInfoArray()
    .then((audioRendererChangeInfoArray: audio.AudioRendererChangeInfoArray) => {
      console.info(`Succeeded in getting current audio renderer info array. AudioRendererChangeInfoArray: ${JSON.stringify(audioRendererChangeInfoArray)}`);
      globalLogUpdate(`Succeeded in getting current audio renderer info array. AudioRendererChangeInfoArray: ${JSON.stringify(audioRendererChangeInfoArray)}`, false);
    }).catch((err: BusinessError ) => {
      console.error(`Failed to get current audio renderer info array. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude get_allstreaminfo]
      globalLogUpdate(`Failed to get current audio renderer info array. Code: ${err.code}, message: ${err.message}`, true);
      // [EndExclude get_allstreaminfo]
    });
}
// [End get_allstreaminfo]
@Entry
@Component
struct Index {
  @State currentState: string = '当前状态: 未初始化';
  @State logMessages: string = '暂无日志';
  @State callbackMessages: string = '暂无回调信息';

  aboutToAppear() {
    globalLogUpdate = (msg: string, isError: boolean) => {
      this.logMessages = msg;
    };
    globalStateUpdate = (msg: string) => {
      this.currentState = msg;
    };
    globalCallbackUpdate = (msg: string) => {
      this.callbackMessages = msg;
    };
  }

  build() {
    Scroll() {
      Column() {
        // 信息显示区域
        Column() {
          Text('当前状态').fontSize(14).fontColor('#999999').margin({ bottom: 8 })
          Text(this.currentState).fontSize(14).fontColor('#007DFF')
        }
        .width('95%')
        .padding(12)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ bottom: 12 })
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('日志信息').fontSize(14).fontColor('#999999').margin({ bottom: 8 })
          Text(this.logMessages)
            .fontSize(14)
            .fontColor(this.logMessages.includes('Failed') || this.logMessages.includes('failed') ||
            this.logMessages.includes('error') || this.logMessages.includes('Error') ? '#FF0000' : '#52C41A')
        }
        .width('95%')
        .padding(12)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ bottom: 12 })
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('回调信息').fontSize(14).fontColor('#999999').margin({ bottom: 8 })
          Text(this.callbackMessages).fontSize(14).fontColor('#FA8C16')
        }
        .width('95%')
        .padding(12)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ bottom: 16 })
        .alignItems(HorizontalAlign.Start)

        Row() {
          Column() {
            Text('初始化').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            initArguments(context);
            init();
            this.currentState = '已初始化';
          });

          Column() {
            Text('开始播放').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ bottom: 12 })
          .onClick(async () => {
            start();
            this.currentState = '已开始';
          });
        }

        Row() {
          Column() {
            Text('暂停播放').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_effect_manager_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            pause();
            this.currentState = '已暂停';
          });

          Column() {
            Text('停止播放').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ bottom: 12 })
          .onClick(async () => {
            stop();
            this.currentState = '已停止';
          });
        }

        Row() {
          Column() {
            Text('释放资源').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            release();
            this.currentState = '已释放';
          });

          Column() {
            Text('获取音频流音量').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            getvolume();
          });
        }

        Row() {
          Column() {
            Text('设置应用的音量').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            setAPPvolume();
          });
          Column() {
            Text('设置音频流音量').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            setStreamVolume();
          });
        }

        Row() {
          Column() {
            Text('是否支持空间音频').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            getDevicesSync();
          });
          Column() {
            Text('查询空间音频开关状态').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            getStatus();
          });
        }

        Row() {
          Column() {
            Text('订阅开关状态事件').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            on();
          });
          Column() {
            Text('取消订阅').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            off();
          });
        }

        Row() {
          Column() {
            Text('查看播放的状态').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            getRendererState();
          });

          Column() {
            Text('获取所有流信息').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            getCurrentAudioRendererInfoArray();
          });
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5');
    }
  }
}