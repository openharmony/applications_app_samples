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
// [Start all_audioLoopback]
// [Start create_AudioLoopback]
import { audio } from '@kit.AudioKit'; // 导入audio模块。
// [Start get_Status]
// [Start set_Volume]
// [Start set_ReverbPreset]
// [Start get_ReverbPreset]
// [Start get_EqualizerPreset]
// [Start enable]
import { BusinessError } from '@kit.BasicServicesKit'; // 导入BusinessError。
// [StartExclude create_AudioLoopback]
// [StartExclude get_Status]
// [StartExclude set_Volume]
// [StartExclude set_ReverbPreset]
// [StartExclude get_ReverbPreset]
// [StartExclude set_EqualizerPreset]
// [StartExclude get_EqualizerPreset]
// [StartExclude enable]
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit'; // 导入UIAbilityContext。

const TAG = 'AudioLoopbackDemo';
// [EndExclude create_AudioLoopback]
let mode: audio.AudioLoopbackMode = audio.AudioLoopbackMode.HARDWARE;
let audioLoopback: audio.AudioLoopback | undefined = undefined;
// [StartExclude create_AudioLoopback]
let currentReverbPreset: audio.AudioLoopbackReverbPreset = audio.AudioLoopbackReverbPreset.THEATER;
let currentEqualizerPreset: audio.AudioLoopbackEqualizerPreset = audio.AudioLoopbackEqualizerPreset.FULL;
// [StartExclude all_audioLoopback]
let statusChangeCallback = (status: audio.AudioLoopbackStatus) => {
  if (status == audio.AudioLoopbackStatus.UNAVAILABLE_DEVICE) {
    console.info('Audio loopback status is: UNAVAILABLE_DEVICE');
  } else if (status == audio.AudioLoopbackStatus.UNAVAILABLE_SCENE) {
    console.info('Audio loopback status is: UNAVAILABLE_SCENE');
  } else if (status == audio.AudioLoopbackStatus.AVAILABLE_IDLE) {
    console.info('Audio loopback status is: AVAILABLE_IDLE');
  } else if (status == audio.AudioLoopbackStatus.AVAILABLE_RUNNING) {
    console.info('Audio loopback status is: AVAILABLE_RUNNING');
  }
};
// [EndExclude all_audioLoopback]

// [StartExclude all_audioLoopback]
async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager
    .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  return result.authResults[0] === 0;
}
// [EndExclude all_audioLoopback]

// 查询能力，创建实例。
function init(updateCallback?: (msg: string, isError: boolean) => void): void {
  // [EndExclude create_AudioLoopback]
  let isSupported = audio.getAudioManager().getStreamManager().isAudioLoopbackSupported(mode);
  if (isSupported) {
    audio.createAudioLoopback(mode).then((loopback) => {
      console.info('Invoke createAudioLoopback succeeded.');
      // [StartExclude all_audioLoopback]
      // [StartExclude create_AudioLoopback]
      const successMsg = 'Invoke createAudioLoopback succeeded.';
      if (updateCallback) {
        updateCallback(successMsg, false);
      }
      // [EndExclude create_AudioLoopback]
      // [EndExclude all_audioLoopback]
      audioLoopback = loopback;
    }).catch((err: BusinessError) => {
      console.error(`Invoke createAudioLoopback failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude create_AudioLoopback]
      const errorMsg = `Invoke createAudioLoopback failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude create_AudioLoopback]
      // [EndExclude all_audioLoopback]
    });
  } else {
    console.error('Audio loopback is unsupported.');
    // [StartExclude all_audioLoopback]
    // [StartExclude create_AudioLoopback]
    const errorMsg = 'Audio loopback is unsupported.';
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude create_AudioLoopback]
    // [EndExclude all_audioLoopback]
  }
  // [End create_AudioLoopback]
}

// 设置音频返听音量。
async function setVolume(volume: number, updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    // [EndExclude set_Volume]
    try {
      await audioLoopback.setVolume(volume);
      console.info(`Invoke setVolume ${volume} succeeded.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude set_Volume]
      const successMsg = `Invoke setVolume ${volume} succeeded.`;
      if (updateCallback) {
        updateCallback(successMsg, false);
      }
      // [EndExclude set_Volume]
      // [EndExclude all_audioLoopback]
    } catch (err) {
      console.error(`Invoke setVolume failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude set_Volume]
      const errorMsg = `Invoke setVolume failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude set_Volume]
      // [EndExclude all_audioLoopback]
    }
    // [End set_Volume]
  } else {
    console.error('Audio loopback not created.');
    // [StartExclude all_audioLoopback]
    const errorMsg = 'Audio loopback not created.';
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude all_audioLoopback]
  }
}

// 设置音频返听的混响模式。
async function setReverbPreset(preset: audio.AudioLoopbackReverbPreset, updateCallback?: (msg: string,
  isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    // [EndExclude set_ReverbPreset]
    try {
      audioLoopback.setReverbPreset(preset);
      console.info(`setReverbPreset( ${preset} succeeded.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude set_ReverbPreset]
      const successMsg = `setReverbPreset ${preset} succeeded.`;
      if (updateCallback) {
        updateCallback(successMsg, false);
      }
      // [EndExclude set_ReverbPreset]
      // [EndExclude all_audioLoopback]
      currentReverbPreset = audioLoopback.getReverbPreset(); // 查询当前的混响模式，防止设置失败。
    } catch (err) {
      console.error(`setReverbPreset( failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude set_ReverbPreset]
      const errorMsg = `setReverbPreset failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude set_ReverbPreset]
      // [EndExclude all_audioLoopback]
    }
    // [End set_ReverbPreset]
  } else {
    console.error('Audio loopback not created.');
    // [StartExclude all_audioLoopback]
    const errorMsg = 'Audio loopback not created.';
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude all_audioLoopback]
  }
}

// 设置音频返听的均衡器类型。
async function setEqualizerPreset(preset: audio.AudioLoopbackEqualizerPreset, updateCallback?:
  (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    // [EndExclude set_EqualizerPreset]
    try {
      audioLoopback.setEqualizerPreset(preset);
      console.info(`setEqualizerPreset ${preset} succeeded.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude set_EqualizerPreset]
      const successMsg = `setEqualizerPreset ${preset} succeeded.`;
      if (updateCallback) {
        updateCallback(successMsg, false);
      }
      // [EndExclude set_EqualizerPreset]
      // [EndExclude all_audioLoopback]
      currentEqualizerPreset = audioLoopback.getEqualizerPreset(); // 查询当前的均衡器类型，防止设置失败。
    } catch (err) {
      console.error(`setEqualizerPreset failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude set_EqualizerPreset]
      const errorMsg = `setEqualizerPreset failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude set_EqualizerPreset]
      // [EndExclude all_audioLoopback]
    }
    // [End set_EqualizerPreset]
  } else {
    console.error('Audio loopback not created.');
    // [StartExclude all_audioLoopback]
    const errorMsg = 'Audio loopback not created.';
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude all_audioLoopback]
  }
}

// [EndExclude enable]
// 设置监听事件，启用音频返听。
async function enable(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    try {
      let status = await audioLoopback.getStatus();
      if (status == audio.AudioLoopbackStatus.AVAILABLE_IDLE) {
        // 注册监听。
        audioLoopback.on('statusChange', statusChangeCallback);
        // 启动返听。
        let success = await audioLoopback.enable(true);
        if (success) {
          console.info('Invoke enable succeeded');
          // [StartExclude all_audioLoopback]
          // [StartExclude enable]
          const successMsg = `Invoke enable succeeded`;
          if (updateCallback) {
            updateCallback(successMsg, false);
          }
          // [EndExclude enable]
          // [EndExclude all_audioLoopback]
        } else {
          status = await audioLoopback.getStatus();
          statusChangeCallback(status);
        }
      } else {
        statusChangeCallback(status);
      }
    } catch (err) {
      console.error(`Invoke enable failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude enable]
      const errorMsg = `Invoke enable failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude enable]
      // [EndExclude all_audioLoopback]
    }
  } else {
    console.error('Audio loopback not created.');
    // [StartExclude all_audioLoopback]
    // [StartExclude enable]
    const errorMsg = `Audio loopback not created.`;
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude enable]
    // [EndExclude all_audioLoopback]
  }
}

// 禁用音频返听，关闭监听事件。
async function disable(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    try {
      let status = await audioLoopback.getStatus();
      if (status == audio.AudioLoopbackStatus.AVAILABLE_RUNNING) {
        // 禁用返听。
        let success = await audioLoopback.enable(false);
        if (success) {
          console.info('Invoke disable succeeded');
          // [StartExclude all_audioLoopback]
          // [StartExclude enable]
          const successMsg = `Invoke disable succeeded`;
          if (updateCallback) {
            updateCallback(successMsg, false);
          }
          // [EndExclude enable]
          // [EndExclude all_audioLoopback]
          // 关闭监听。
          audioLoopback.off('statusChange', statusChangeCallback);
        } else {
          status = await audioLoopback.getStatus();
          statusChangeCallback(status);
        }
      } else {
        statusChangeCallback(status);
      }
    } catch (err) {
      console.error(`Invoke disable failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude all_audioLoopback]
      // [StartExclude enable]
      const errorMsg = `Invoke disable failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude enable]
      // [EndExclude all_audioLoopback]
    }
  } else {
    console.error('Audio loopback not created.');
    // [StartExclude all_audioLoopback]
    // [StartExclude enable]
    const errorMsg = `Audio loopback not created.`;
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude enable]
    // [EndExclude all_audioLoopback]
  }
}
// [End enable]
// [End all_audioLoopback]

// [StartExclude all_audioLoopback]
// 查询当前返听状态
async function getStatus(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    // [EndExclude get_Status]
    audioLoopback.getStatus().then((status: audio.AudioLoopbackStatus) => {
      console.info(`getStatus success, status is ${status}.`);
      // [StartExclude get_Status]
      const successMsg = `getStatus success, status is ${status}.`;
      if (updateCallback) {
        updateCallback(successMsg, false);
      }
      // [EndExclude get_Status]
    }).catch((err: BusinessError) => {
      console.error(`getStatus failed, code is ${err.code}, message is ${err.message}.`);
      // [StartExclude get_Status]
      const errorMsg = `getStatus failed, code is ${err.code}, message is ${err.message}.`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude get_Status]
    })
    // [End get_Status]
  }
}

// 查询当前的音频返听的混响模式
async function getReverbPreset(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    // [EndExclude get_ReverbPreset]
    try {
      let reverbPreset = audioLoopback.getReverbPreset();
    } catch (err) {
      console.error(`getReverbPreset:ERROR: ${err}`);
      // [StartExclude get_ReverbPreset]
      const errorMsg = `getReverbPreset:ERROR: ${err}`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude get_ReverbPreset]
    }
    // [End get_ReverbPreset]
  }
}

// 查询当前的音频返听的均衡器类型
async function getEqualizerPreset(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    // [EndExclude get_EqualizerPreset]
    try {
      let equalizerPreset = audioLoopback.getEqualizerPreset();
    } catch (err) {
      console.error(`getEqualizerPreset:ERROR: ${err}`);
      // [StartExclude get_EqualizerPreset]
      const errorMsg = `getEqualizerPreset:ERROR: ${err}`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude get_EqualizerPreset]
    }
    // [End get_EqualizerPreset]
  }
}
// [EndExclude all_audioLoopback]


@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

  // 更新日志信息
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  // 更新回调信息
  updateCallbackInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.callbackMessages = `[${timestamp}] ${msg}`;
  }

  build(): void {
    Scroll() {
      Column() {
        // 信息显示区域
        Column() {
          Text('实时状态信息')
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          // 当前状态
          Column() {
            Text('当前状态')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // 日志信息
          Column() {
            Text('日志信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.logMessages)
              .fontSize(13)
              .fontColor('#52C41A')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
              .maxLines(5)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // 回调信息
          Column() {
            Text('回调信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.callbackMessages)
              .fontSize(13)
              .fontColor('#FA8C16')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 20 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 功能按钮
        Row() {
          Column() {
            Text('创建音频低时延耳返实例')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ right: 12, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            // [StartExclude all_audioLoopback]
            let hasPermission = await requestMicrophonePermission(context);
            if (!hasPermission) {
              const errorMsg = '麦克风权限未授权，无法录音';
              console.error(errorMsg);
              this.updateLogInfo(errorMsg, true);
              this.currentState = '权限未授权';
              return;
            }
            // [EndExclude all_audioLoopback]
            init((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已创建实例';
          });

          Column() {
            Text('设置音频返听音量')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await setVolume(0.5, (msg, isError) => this.updateLogInfo(msg, isError));
          });
        }

        Row() {
          Column() {
            Text('设置混响模式')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ right: 12, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await setReverbPreset(currentReverbPreset, (msg, isError) => this.updateLogInfo(msg, isError));
          });

          Column() {
            Text('设置均衡器类型')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await setEqualizerPreset(currentEqualizerPreset, (msg, isError) => this.updateLogInfo(msg, isError));
          });
        }

        Row() {
          Column() {
            Text('查询返听状态')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ right: 12, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await getStatus((msg, isError) => this.updateLogInfo(msg, isError));
          });

          Column() {
            Text('查询混响模式')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await getReverbPreset((msg, isError) => this.updateLogInfo(msg, isError));
          });
        }

        Row() {
          Column() {
            Text('查询均衡器类型')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ right: 12, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await getEqualizerPreset((msg, isError) => this.updateLogInfo(msg, isError));
          });

          Column() {
            Text('启用音频返听')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await enable((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已启用返听';
          });
        }

        Row() {
          Column() {
            Text('禁用音频返听')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ right: 12, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await disable((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已禁用返听';
          });
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}