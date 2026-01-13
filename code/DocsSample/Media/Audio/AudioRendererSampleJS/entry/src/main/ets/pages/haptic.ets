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

// [Start get_haptic]
import { audio, audioHaptic } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

let audioHapticManagerInstance: audioHaptic.AudioHapticManager = audioHaptic.getAudioHapticManager();

// [StartExclude get_haptic]
// [Start create_haptic]
let options: audioHaptic.AudioHapticPlayerOptions = {muteAudio: false, muteHaptics: false};
let audioHapticPlayer: audioHaptic.AudioHapticPlayer | undefined = undefined;
// [StartExclude create_haptic]
let idForFd = 0;

// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

async function registSource(){
  // [EndExclude get_haptic]
  // 方法1：使用registerSource接口注册资源。
  let audioUri = 'data/audioTest.wav'; // 此处仅作示例，实际使用时需要将文件替换为应用目标音频资源的Uri。
  let hapticUri = 'data/hapticTest.json'; // 此处仅作示例，实际使用时需要将文件替换为应用目标振动资源的Uri。
  let idForUri = 0;

  audioHapticManagerInstance.registerSource(audioUri, hapticUri).then((value: number) => {
    console.info(`Promise returned to indicate that the source id of the registered source ${value}.`);
    idForUri = value;
    // [StartExclude get_haptic]
    if (globalLogUpdate) {
      globalLogUpdate(`Promise returned to indicate that the source id of the registered source ${value}.`, false);
    }
    // [EndExclude get_haptic]
  }).catch((err: BusinessError) => {
    console.error(`Failed to register source ${err}`);
    // [StartExclude get_haptic]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to register source ${err}`, true);
    }
    // [EndExclude get_haptic]
  });
  // [StartExclude get_haptic]
}

async function registWithFD(context: common.UIAbilityContext) {
  // [EndExclude get_haptic]
  // 方法2:使用registerSourceFromFd接口注册资源。
  // 此处仅作示例,实际使用时需要将文件替换为应用rawfile目录下的对应文件。
  let audioFile = context.resourceManager.getRawFdSync('audioTest.ogg');
  let audioFd: audioHaptic.AudioHapticFileDescriptor = {
    fd: audioFile.fd,
    offset: audioFile.offset,
    length: audioFile.length,
  };
  // 此处仅作示例,实际使用时需要将文件替换为应用rawfile目录下的对应文件。
  let hapticFile = context.resourceManager.getRawFdSync('hapticTest.json');
  let hapticFd: audioHaptic.AudioHapticFileDescriptor = {
    fd: hapticFile.fd,
    offset: hapticFile.offset,
    length: hapticFile.length,
  };
  audioHapticManagerInstance.registerSourceFromFd(audioFd, hapticFd).then((value: number) => {
    console.info('Succeeded in doing registerSourceFromFd.');
    idForFd = value;
    // [StartExclude get_haptic]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in doing registerSourceFromFd.', false);
    }
    // [Start set_hapticparam]
    let latencyMode: audioHaptic.AudioLatencyMode = audioHaptic.AudioLatencyMode.AUDIO_LATENCY_MODE_NORMAL;
    audioHapticManagerInstance.setAudioLatencyMode(idForFd, latencyMode);

    let usage: audio.StreamUsage = audio.StreamUsage.STREAM_USAGE_NOTIFICATION;
    audioHapticManagerInstance.setStreamUsage(idForFd, usage);
    // [End set_hapticparam]
    // [EndExclude create_haptic]
    audioHapticManagerInstance.createPlayer(idForFd, options).then((value: audioHaptic.AudioHapticPlayer) => {
      console.info(`Create the audio haptic player successfully.`);
      audioHapticPlayer = value;
      // [StartExclude create_haptic]
      if (globalLogUpdate) {
        globalLogUpdate(`Create the audio haptic player successfully.`, false);
      }
      // [EndExclude create_haptic]
    }).catch((err: BusinessError) => {
      console.error(`Failed to create player ${err}`);
      // [StartExclude create_haptic]
      if (globalLogUpdate) {
        globalLogUpdate(`Failed to create player ${err}`, true);
      }
      // [EndExclude create_haptic]
    });
    // [End create_haptic]
    // [EndExclude get_haptic]
  }).catch((err: BusinessError) => {
    console.error(`Failed to registerSourceFromFd. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude get_haptic]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to registerSourceFromFd. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude get_haptic]
  });
  // [End get_haptic]
}
async function start(){
  if (audioHapticPlayer == null){
    console.info(`haptic player hasn't been defined.`);

    if (globalLogUpdate) {
      globalLogUpdate(`haptic player hasn't been defined.`, false);
    }
  } else {
    // [Start haptic_start]
    audioHapticPlayer.start().then(() => {
      console.info(`Promise returned to indicate that start playing successfully.`);
      // [StartExclude haptic_start]
      if (globalLogUpdate) {
        globalLogUpdate(`Promise returned to indicate that start playing successfully.`, false);
      }
      // [EndExclude haptic_start]
    }).catch((err: BusinessError) => {
      console.error(`Failed to start playing. ${err}`);
      // [StartExclude haptic_start]
      if (globalLogUpdate) {
        globalLogUpdate(`Failed to start playing. ${err}`, true);
      }
      // [EndExclude haptic_start]
    });
    // [End haptic_start]
  }
}
async function stop(){
  if (audioHapticPlayer == null){
    console.info(`haptic player hasn't been defined.`);

    if (globalLogUpdate) {
      globalLogUpdate(`haptic player hasn't been defined.`, false);
    }
  } else {
    // [Start haptic_stop]
    audioHapticPlayer.stop().then(() => {
      console.info(`Promise returned to indicate that stop playing successfully.`);
      // [StartExclude haptic_stop]
      if (globalLogUpdate) {
        globalLogUpdate(`Promise returned to indicate that stop playing successfully.`, false);
      }
      // [EndExclude haptic_stop]
    }).catch((err: BusinessError) => {
      console.error(`Failed to stop playing. ${err}`);
      // [StartExclude haptic_stop]
      if (globalLogUpdate) {
        globalLogUpdate(`Failed to stop playing. ${err}`, true);
      }
      // [EndExclude haptic_stop]
    });
    // [End haptic_stop]
  }
}
async function release(){
  if(audioHapticPlayer == null){
    console.info(`haptic player hasn't been defined.`);

    if (globalLogUpdate) {
      globalLogUpdate(`haptic player hasn't been defined.`, false);
    }
  } else {
    // [Start haptic_release]
    audioHapticPlayer.release().then(() => {
      console.info(`Promise returned to indicate that release the audio haptic player successfully.`);
      // [StartExclude haptic_release]
      if (globalLogUpdate) {
        globalLogUpdate(`Promise returned to indicate that release the audio haptic player successfully.`, false);
      }
      // [EndExclude haptic_release]
    }).catch((err: BusinessError) => {
      console.error(`Failed to release the audio haptic player. ${err}`);
      // [StartExclude haptic_release]
      if (globalLogUpdate) {
        globalLogUpdate(`Failed to release the audio haptic player. ${err}`, true);
      }
      // [EndExclude haptic_release]
    });
    // [End haptic_release]
    // [Start haptic_unregist]
    audioHapticManagerInstance.unregisterSource(idForFd).then(() => {
      console.info(`Promise returned to indicate that unregister source successfully`);
      // [StartExclude haptic_unregist]
      if (globalLogUpdate) {
        globalLogUpdate(`Promise returned to indicate that unregister source successfully`, false);
      }
      // [EndExclude haptic_unregist]
    }).catch((err: BusinessError) => {
      console.error(`Failed to unregister source ${err}`);
      // [StartExclude haptic_unregist]
      if (globalLogUpdate) {
        globalLogUpdate(`Failed to unregister source ${err}`, true);
      }
      // [EndExclude haptic_unregist]
    });
    // [End haptic_unregist]
  }
}

@Entry
@Component
struct Index {
  @State logMessages: string = '暂无日志信息';

  aboutToAppear(): void {
    // 设置全局回调
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  // 更新日志信息
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build(): void {
    Scroll() {
      Column() {
        // 信息显示区域
        Column() {
          Text('日志信息')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })

          Scroll() {
            Text(this.logMessages)
              .fontSize(12)
              .fontColor('#52C41A')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .height(80)
          .width('80%')
        }
        .width('100%')
        .padding(8)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 功能按钮
        Row() {
          Column() {
            Text('使用注册源注册').fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            await registSource()
          });

          Column() {
            Text('使用描述符注册').fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            // 请在组件内获取context,确保this.getUIContext().getHostContext()返回结果为UIAbilityContext。
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            await registWithFD(context);
          });
        }

        Row() {
          Column() {
            Text('音振协同播放开始').fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('audio_effect_manager_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            await start()
          });

          Column() {
            Text('音振协同播放停止').fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            await stop()
          });
        }

        Row() {
          Column() {
            Text('音振协同播放释放').fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('5%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            await release()
          });
        }
        .padding(12)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5');
    }
  }
}
