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

// [Start all_focusprocess]
import { audio } from '@kit.AudioKit';  // 导入audio模块。
import { BusinessError } from '@kit.BasicServicesKit'; // 导入BusinessError。

// [StartExclude all_focusprocess]
// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;
// [EndExclude all_focusprocess]

let audioSessionStateChangedCallback = (audioSessionStateChangedEvent: audio.AudioSessionStateChangedEvent) => {
  console.info(`hint of audioSessionStateChanged: ${audioSessionStateChangedEvent.stateChangeHint} `);

  // [StartExclude all_focusprocess]
  let callbackMsg = `hint of audioSessionStateChanged: ${audioSessionStateChangedEvent.stateChangeHint}`;
  if (globalCallbackUpdate) {
    globalCallbackUpdate(callbackMsg);
  }
  // [EndExclude all_focusprocess]

  switch (audioSessionStateChangedEvent.stateChangeHint) {
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_PAUSE:
      // 此分支表示系统已将音频流暂停，应用需切换至音频暂停状态。
      // 临时失去焦点：其他音频流释放音频焦点后，本音频流会收到resume事件，可继续播放。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_RESUME:
      // 此分支表示系统解除AudioSession焦点的暂停操作。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_STOP:
      // 此分支表示系统已将音频流停止（永久失去焦点），为保持状态一致，应用需切换至音频暂停状态。
      // 永久失去焦点：后续不会再收到音频焦点事件，恢复播放需用户主动触发。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_TIME_OUT_STOP:
      // 此分支表示由于长时间无音频流播放，系统已将AudioSession停止（永久失去焦点），应用需切换至音频暂停状态。
      // 永久失去焦点：后续不会再收到音频焦点事件，恢复播放需用户主动触发。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_DUCK:
      // 此分支表示系统已将音频音量降低（默认降到正常音量的20%）。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_UNDUCK:
      // 此分支表示系统已将音频音量恢复正常。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_MUTE_SUGGESTION:
      // 此分支表示其他应用开始播放非混音音频，系统可自行决定是否静音。
      break;
    case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_UNMUTE_SUGGESTION:
      // 此分支表示其他应用的非混音音频播放结束，系统可自行决定是否取消静音。
      break;
    default:
      break;
  }
};

// [Start all_sessionprocess]
// [Start get_sessionmanager]
let audioManager = audio.getAudioManager();
let audioSessionManager: audio.AudioSessionManager = audioManager.getSessionManager();
// [StartExclude all_sessionprocess]
// [End get_sessionmanager]
// [StartExclude all_focusprocess]
async function setAudioScene(){
  // 示例中选择了AUDIO_SESSION_SCENE_MEDIA会话场景，实际情况请根据具体场景修改该参数。
  // [EndExclude all_focusprocess]
  // [Start set_audioscene]
  // [Start enable_muteSuggestion]
  audioSessionManager.setAudioSessionScene(audio.AudioSessionScene.AUDIO_SESSION_SCENE_MEDIA);
  // [StartExclude set_audioscene]
  // [StartExclude all_focusprocess]
  // [StartExclude enable_muteSuggestion]
  console.info('Succeeded in doing setAudioSessionScene.');
  if (globalLogUpdate) {
    globalLogUpdate('Succeeded in doing setAudioSessionScene.', false);
  }
}

async function enableMuteSuggestion(){
  setAudioScene();
  // [EndExclude enable_muteSuggestion]
  audioSessionManager.enableMuteSuggestionWhenMixWithOthers(true);
  // [StartExclude enable_muteSuggestion]
  console.info('Succeeded in doing enableMuteSuggestionWhenMixWithOthers.');
  if (globalLogUpdate) {
    globalLogUpdate('Succeeded in doing enableMuteSuggestionWhenMixWithOthers.', false);
  }
}

async function activeSession(){
  // [EndExclude all_focusprocess]
  // 示例中选择了CONCURRENCY_MIX_WITH_OTHERS策略，请根据具体场景修改该参数。
  // [Start active_audiosession]
  // [EndExclude set_audioscene]
  // [EndExclude all_sessionprocess]
  // [EndExclude enable_muteSuggestion]
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS
  };

  // 激活AudioSession，即抢占焦点。
  audioSessionManager.activateAudioSession(strategy).then(() => {
    console.info('Succeeded in doing activateAudioSession.');
    // [StartExclude active_audiosession]
    // [StartExclude enable_muteSuggestion]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in doing activateAudioSession.', false);
    }
    // [EndExclude active_audiosession]
    // [EndExclude enable_muteSuggestion]
  }).catch((err: BusinessError) => {
    console.error(`Failed to activateAudioSession. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude active_audiosession]
    // [StartExclude enable_muteSuggestion]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to activateAudioSession. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude active_audiosession]
    // [EndExclude enable_muteSuggestion]
  });
  // [End set_audioscene]
  // [End active_audiosession]
  // [End enable_muteSuggestion]
  let isActivated = audioSessionManager.isAudioSessionActivated();
  // [StartExclude all_sessionprocess]
  if (!isActivated) {
    console.error(`session is not activated.`);
  } else {
    console.info('session is activated.');
  }

  audioSessionManager.on('audioSessionStateChanged', audioSessionStateChangedCallback);
  // [Start listen_audiosessiondeactiveevent]
  // [EndExclude all_sessionprocess]
  audioSessionManager.on('audioSessionDeactivated', (audioSessionDeactivatedEvent: audio
  .AudioSessionDeactivatedEvent) => {
    console.info(`reason of audioSessionDeactivated: ${audioSessionDeactivatedEvent.reason} `);
    // [StartExclude listen_audiosessiondeactiveevent]
    if (globalCallbackUpdate) {
      globalCallbackUpdate(`reason of audioSessionDeactivated: ${audioSessionDeactivatedEvent.reason}`);
    }
    // [EndExclude listen_audiosessiondeactiveevent]
  });
  // [StartExclude all_sessionprocess]
  // [End listen_audiosessiondeactiveevent]
}
// 根据实际业务，可以启动多个AudioRenderer等音频播放。
// [Start deactive_audiosession]
// [StartExclude all_focusprocess]
async function deactiveSession(){
  // [EndExclude all_sessionprocess]
  // [EndExclude all_focusprocess]
  // 结束AudioSession，即释放焦点。
  audioSessionManager.deactivateAudioSession().then(() => {
    console.info('Succeeded in doing deactivateAudioSession.');
    // [StartExclude deactive_audiosession]
    // [StartExclude all_focusprocess]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in doing deactivateAudioSession.', false);
    }
    // [EndExclude all_focusprocess]
    // [EndExclude deactive_audiosession]
  }).catch((err: BusinessError) => {
    console.error(`Failed to deactivateAudioSession. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude deactive_audiosession]
    // [StartExclude all_focusprocess]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to deactivateAudioSession. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude deactive_audiosession]
    // [EndExclude all_focusprocess]
  });
  // [End deactive_audiosession]
  // [StartExclude all_sessionprocess]
  // [StartExclude all_focusprocess]
  // [Start audiosession_checkisactivated]
  let isActivated = audioSessionManager.isAudioSessionActivated();
  // [End audiosession_checkisactivated]
  if (!isActivated){
    console.error(`deactive AudioSession successfully`);
  }
  // [EndExclude all_focusprocess]
  audioSessionManager.off('audioSessionStateChanged', audioSessionStateChangedCallback);
  // [End all_focusprocess]
  // 停用音频会话
  // [Start cancellisten_audiosessiondeactiveevent]
  // [EndExclude all_sessionprocess]
  audioSessionManager.off('audioSessionDeactivated');
  // [End all_sessionprocess]
  // [End cancellisten_audiosessiondeactiveevent]
}
async function sessionIsActivated(){
  // [Start audiosession_checkisactivated]
  let isActivated = audioSessionManager.isAudioSessionActivated();
  // [End audiosession_checkisactivated]
  if (!isActivated) {
    console.error(`session is not activated.`);
  } else {
    console.info('session is activated.');
  }
}

@Entry
@Component
struct Index {
  @State private runningResult: string = '暂无运行结果';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

  aboutToAppear(): void {
    // 设置全局回调
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
    globalCallbackUpdate = (msg) => this.updateCallbackInfo(msg);
  }

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

          // 运行结果
          Column() {
            Text('运行结果')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.runningResult)
              .fontSize(12)
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
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
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
            Scroll() {
              Text(this.callbackMessages)
                .fontSize(12)
                .fontColor('#FA8C16')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
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
          Button() {
            Text('设置场景').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await setAudioScene()
            this.runningResult = 'set session scene:MEDIA'
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('启用静音建议').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await enableMuteSuggestion()
            this.runningResult = 'enable mute suggestion'
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('激活焦点+注册监听').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await activeSession()
            this.runningResult = 'active session with strategy MIX WITH OTHERS'
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('判断焦点是否激活').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await sessionIsActivated()
            this.runningResult = 'active session with strategy PAUSE_OTHERS'
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('注销焦点+注销监听').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await deactiveSession()
            this.runningResult = 'deactive session success'
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5');
    }
  }
}