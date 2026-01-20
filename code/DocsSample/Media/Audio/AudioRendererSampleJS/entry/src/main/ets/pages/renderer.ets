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
    console.error(`Failed to create AVPlayer, error message:${error.message}`);
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
const TAG = 'AudioRendererDemo';
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
      console.error('Error reading file:', error);
      // [StartExclude render_process]
      // 系统会判定buffer无效，不播放
      // [StartExclude init_oncallback]
      globalLogUpdate('Error reading file: ' + error, true);
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
      console.info(`${TAG}: creating AudioRenderer success`);
      // [StartExclude create_audiorender]
      // [StartExclude render_process]
      globalLogUpdate(`${TAG}: creating AudioRenderer success`, false);
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
      console.info(`${TAG}: creating AudioRenderer failed, error: ${err.message}`);
      // [StartExclude render_process]
      globalLogUpdate(`${TAG}: creating AudioRenderer failed, error: ${err.message}`, false);
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
      console.error(TAG + 'start failed');
      // [StartExclude render_process]
      globalLogUpdate(TAG + 'start failed', true);
      // [EndExclude render_process]
      return;
    }
    // 启动渲染。
    // [EndExclude render_start]
    audioRenderer.start((err: BusinessError) => {
      if (err) {
        console.error('Renderer start failed.');
        // [StartExclude render_start]
        // [StartExclude render_process]
        globalLogUpdate('Renderer start failed.', true);
        // [EndExclude render_process]
        // [EndExclude render_start]
      } else {
        console.info('Renderer start success.');
        // [StartExclude render_start]
        // [StartExclude render_process]
        globalLogUpdate('Renderer start success.', false);
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
      console.info('Renderer is not running');
      // [StartExclude render_process]
      globalLogUpdate('Renderer is not running', false);
      // [EndExclude render_process]
      return;
    }
    // 暂停渲染。
    audioRenderer.pause((err: BusinessError) => {
      if (err) {
        console.error('Renderer pause failed.');
        // [StartExclude render_process]
        globalLogUpdate('Renderer pause failed.', true);
        // [EndExclude render_process]
      } else {
        console.info('Renderer pause success.');
        // [StartExclude render_process]
        globalLogUpdate('Renderer pause success.', false);
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
      console.info('Renderer is not running or paused.');
      // [StartExclude render_process]
      globalLogUpdate('Renderer is not running or paused.', false);
      // [EndExclude render_process]
      return;
    }
    // 停止渲染。
    // [EndExclude render_stop]
    audioRenderer.stop((err: BusinessError) => {
      if (err) {
        console.error('Renderer stop failed.');
        // [StartExclude render_stop]
        // [StartExclude render_process]
        globalLogUpdate('Renderer stop failed.', true);
        // [EndExclude render_process]
        // [EndExclude render_stop]
      } else {
        console.info('Renderer stop success.');
        // [StartExclude render_stop]
        // [StartExclude render_process]
        globalLogUpdate('Renderer stop success.', false);
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
      console.info('Renderer already released');
      // [StartExclude render_process]
      globalLogUpdate('Renderer already released', false);
      // [EndExclude render_process]
      return;
    }

    // [StartExclude render_process]
    // 先取消所有监听
    offlistenRenderChange();
    audioVolumeManager.off('streamVolumeChange');
    console.info('Volume change listener removed');
    globalLogUpdate('Volume change listener removed', false);
    // [EndExclude render_process]

    // 释放资源。
    // [EndExclude render_release]
    audioRenderer.release((err: BusinessError) => {
      if (err) {
        console.error('Renderer release failed.');
        // [StartExclude render_release]
        // [StartExclude render_process]
        globalLogUpdate('Renderer release failed.', true);
        // [EndExclude render_process]
        // [EndExclude render_release]
      } else {
        // 关闭沙箱文件
        console.info('Renderer release success.');
        // [StartExclude render_release]
        // [StartExclude render_process]
        globalLogUpdate('Renderer release success.', false);
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
  audioVolumeManager.getVolumeByStream(audio.StreamUsage.STREAM_USAGE_MUSIC);
  // [StartExclude get_systemvolume]
  // [EndExclude get_systemvolume]
  // 获取指定流的最小音量。
  audioVolumeManager.getMinVolumeByStream(audio.StreamUsage.STREAM_USAGE_MUSIC);

  // 获取指定流的最大音量。
  audioVolumeManager.getMaxVolumeByStream(audio.StreamUsage.STREAM_USAGE_MUSIC);
  // [End get_systemvolume]
}

async function listenvolume(){
  // [EndExclude regist_volumechangecallback]
  audioVolumeManager.on('streamVolumeChange', audio.StreamUsage.STREAM_USAGE_MUSIC,
    (streamVolumeEvent: audio.StreamVolumeEvent) => {
    console.info(`StreamUsagem: ${streamVolumeEvent.streamUsage} `);
    console.info(`Volume level: ${streamVolumeEvent.volume} `);
    console.info(`Whether to updateUI: ${streamVolumeEvent.updateUi} `);
    // [StartExclude regist_volumechangecallback]
    globalCallbackUpdate(`StreamUsagem: ${streamVolumeEvent.streamUsage} Volume level:
     ${streamVolumeEvent.volume} Whether to updateUI: ${streamVolumeEvent.updateUi}`);
    // [EndExclude regist_volumechangecallback]
  });
  // [End regist_volumechangecallback]
}

async function setAPPvolume(){
  // [EndExclude set_appvolume]
  // 设置应用的音量（范围为0到100）。
  audioVolumeManager.setAppVolumePercentage(20).then(() => {
    console.info(`set app volume success.`);
    // [StartExclude set_appvolume]
    globalLogUpdate('set app volume success.', false);
    // [EndExclude set_appvolume]
  });

  // 查询应用音量。
  audioVolumeManager.getAppVolumePercentage().then((value: number) => {
    console.info(`app volume is ${value}.`);
    // [StartExclude set_appvolume]
    globalLogUpdate(`app volume is ${value}.`, false);
    // [EndExclude set_appvolume]
  });

  // 监听应用音量变化，on方法和off方法传入callback参数一致，off方法取消对应on方法订阅的监听。
  let appVolumeChangeCallback = (volumeEvent: audio.VolumeEvent) => {
    console.info(`VolumeType of stream: ${volumeEvent.volumeType} `);
    console.info(`Volume level: ${volumeEvent.volume} `);
    console.info(`Whether to updateUI: ${volumeEvent.updateUi} `);
    // [StartExclude set_appvolume]
    globalCallbackUpdate(`VolumeType of stream: ${volumeEvent.volumeType} Volume level:
     ${volumeEvent.volume} Whether to updateUI: ${volumeEvent.updateUi}`);
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
      console.info('Invoke setVolume succeeded.');
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate('Invoke setVolume succeeded.', false);
      // [EndExclude Renderset_streamvolume]
    }).catch((err: BusinessError) => {
      console.error(`Invoke setVolume failed, code is ${err.code}, message is ${err.message}`);
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate(`Invoke setVolume failed, code is ${err.code}, message is ${err.message}`, true);
      // [EndExclude Renderset_streamvolume]
    });

    // 获取音频流音量。
    try {
      let value: number = audioRenderer.getVolume();
      console.info(`Indicate that the volume is obtained ${value}.`);
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate(`Indicate that the volume is obtained ${value}.`, false);
      // [EndExclude Renderset_streamvolume]
    } catch (err) {
      let error = err as BusinessError;
      console.error(`Failed to obtain the volume, error ${error}.`);
      // [StartExclude Renderset_streamvolume]
      globalLogUpdate(`Failed to obtain the volume, error ${error}.`, true);
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
}

async function off() {
  // [EndExclude unregist_spacesoundcallback]
  audioSpatializationManager.off('spatializationEnabledChangeForCurrentDevice');
  // [End unregist_spacesoundcallback]
}

async function getRendererState(){
  if (audioRenderer != null) {
    // [EndExclude check_renderstate]
    let audioRendererState: audio.AudioState = audioRenderer.state;
    console.info(`Current state is: ${audioRendererState }`);
    // [End check_renderstate]
    globalLogUpdate(`Current state is: ${audioRendererState }`, false);
  } else {
    console.info(`audio renderer is null`)
    globalLogUpdate('audio renderer is null', false);
  }
}

async function registListeningStateChange() {
  if (audioRenderer != null) {
    // [EndExclude regist_listeningrendererchange]
    audioRenderer.on('stateChange', (rendererState: audio.AudioState) => {
      console.info(`State change to: ${rendererState}`);
      // [StartExclude regist_listeningrendererchange]
      globalCallbackUpdate(`State change to: ${rendererState}`);
      // [EndExclude regist_listeningrendererchange]
    });
    // [End regist_listeningrendererchange]
  } else {
    console.info(`audio renderer is null`)
    globalLogUpdate('audio renderer is null', false);
  }
}

async function listenRenderChange() {
  // [EndExclude regist_renderchangechallback]
  audioStreamManager.on('audioRendererChange',  (audioRendererChangeInfoArray: audio.AudioRendererChangeInfoArray) => {
    for (let i = 0; i < audioRendererChangeInfoArray.length; i++) {
      let audioRendererChangeInfo = audioRendererChangeInfoArray[i];
      console.info(`## RendererChange on is called for ${i} ##`);
      console.info(`StreamId for ${i} is: ${audioRendererChangeInfo.streamId}`);
      console.info(`Content ${i} is: ${audioRendererChangeInfo.rendererInfo.content}`);
      console.info(`Stream ${i} is: ${audioRendererChangeInfo.rendererInfo.usage}`);
      console.info(`Flag ${i} is: ${audioRendererChangeInfo.rendererInfo.rendererFlags}`);
      // [StartExclude regist_renderchangechallback]
      globalCallbackUpdate(`## RendererChange on is called for ${i} ## StreamId:
       ${audioRendererChangeInfo.streamId} Content: ${audioRendererChangeInfo.rendererInfo.content} Stream:
        ${audioRendererChangeInfo.rendererInfo.usage} Flag: ${audioRendererChangeInfo.rendererInfo.rendererFlags}`);
      // [EndExclude regist_renderchangechallback]
      for (let j = 0;j < audioRendererChangeInfo.deviceDescriptors.length; j++) {
        console.info(`Id: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].id}`);
        console.info(`Type: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].deviceType}`);
        console.info(`Role: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].deviceRole}`);
        console.info(`Name: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].name}`);
        console.info(`Address: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].address}`);
        console.info(`SampleRates: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].sampleRates[0]}`);
        console.info(`ChannelCount ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].channelCounts[0]}`);
        console.info(`ChannelMask: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].channelMasks}`);
      }
    }
  });
  // [End regist_renderchangechallback]
}

async function offlistenRenderChange(){
  // [Start unregist_renderchangechallback]
  audioStreamManager.off('audioRendererChange');
  console.info('RendererChange Off is called ');
  // [End unregist_renderchangechallback]
  globalLogUpdate('RendererChange Off is called ', false);
}

// [EndExclude get_allstreaminfo]
async function getCurrentAudioRendererInfoArray(): Promise<void> {
  await audioStreamManager.getCurrentAudioRendererInfoArray()
    .then((audioRendererChangeInfoArray: audio.AudioRendererChangeInfoArray) => {
      console.info(`getCurrentAudioRendererInfoArray  Get Promise is called `);
      // [StartExclude get_allstreaminfo]
      globalLogUpdate('getCurrentAudioRendererInfoArray  Get Promise is called ', false);
      // [EndExclude get_allstreaminfo]
      if (audioRendererChangeInfoArray != null) {
        for (let i = 0; i < audioRendererChangeInfoArray.length; i++) {
          let audioRendererChangeInfo = audioRendererChangeInfoArray[i];
          console.info(`StreamId for ${i} is: ${audioRendererChangeInfo.streamId}`);
          console.info(`Content ${i} is: ${audioRendererChangeInfo.rendererInfo.content}`);
          console.info(`Stream ${i} is: ${audioRendererChangeInfo.rendererInfo.usage}`);
          console.info(`Flag ${i} is: ${audioRendererChangeInfo.rendererInfo.rendererFlags}`);
          // [StartExclude get_allstreaminfo]
          globalLogUpdate(`RendererInfo [${i}] - StreamId: ${audioRendererChangeInfo.streamId},
           Content: ${audioRendererChangeInfo.rendererInfo.content},
            Usage: ${audioRendererChangeInfo.rendererInfo.usage},
             Flags: ${audioRendererChangeInfo.rendererInfo.rendererFlags}`, false);
          // [EndExclude get_allstreaminfo]
          for (let j = 0;j < audioRendererChangeInfo.deviceDescriptors.length; j++) {
            console.info(`Id: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].id}`);
            console.info(`Type: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].deviceType}`);
            console.info(`Role: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].deviceRole}`);
            console.info(`Name: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].name}`);
            console.info(`Address: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].address}`);
            console.info(`SampleRates: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].sampleRates[0]}`);
            console.info(`ChannelCount ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].channelCounts[0]}`);
            console.info(`ChannelMask: ${i} : ${audioRendererChangeInfo.deviceDescriptors[j].channelMasks}`);
          }
        }
      }
    }).catch((err: BusinessError ) => {
      console.error(`Invoke getCurrentAudioRendererInfoArray failed, code is ${err.code}, message is ${err.message}`);
      // [StartExclude get_allstreaminfo]
      globalLogUpdate(`Invoke getCurrentAudioRendererInfoArray failed, code is
       ${err.code}, message is ${err.message}`, true);
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