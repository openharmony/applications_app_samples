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

// [Start renderer_interrupt]
// [Start get_session_manager]
// [Start activate_audio_session_v1]
// [Start on_audio_session_deactivated]
// [Start audio_session_v1]
// [Start activate_audio_session_v2]
// [Start on_audio_session_state_changed]
// [Start audio_session_v2]
// [Start enable_mute_suggestion]
// [Start set_default_output_device]
// [Start set_session_behavior]
// [Start print_session_info]
import { audio } from '@kit.AudioKit';
// [StartExclude get_session_manager]
// [StartExclude on_audio_session_deactivated]
// [Start deactivate_audio_session_v1]
// [Start deactivate_audio_session_v2]
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude activate_audio_session_v1]
// [StartExclude renderer_interrupt]
// [StartExclude deactivate_audio_session_v1]
// [StartExclude audio_session_v1]
// [StartExclude activate_audio_session_v2]
// [StartExclude on_audio_session_state_changed]
// [StartExclude deactivate_audio_session_v2]
// [StartExclude audio_session_v2]
// [StartExclude enable_mute_suggestion]
// [StartExclude set_default_output_device]
// [StartExclude set_session_behavior]
// [StartExclude print_session_info]
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';
// [EndExclude print_session_info]
import { fileIo as fs } from '@kit.CoreFileKit';
// [StartExclude print_session_info]

// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;

class Options {
  public offset?: number;
  public length?: number;
}

let audioRenderer: audio.AudioRenderer | undefined = undefined;
let audioCapturer: audio.AudioCapturer | undefined = undefined;
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
let audioCapturerInfo: audio.AudioCapturerInfo = {
  source: audio.SourceType.SOURCE_TYPE_MIC,
  capturerFlags: 0
};
let audioCapturerOptions: audio.AudioCapturerOptions = {
  streamInfo: audioStreamInfo,
  capturerInfo: audioCapturerInfo
};
let writeDataCallback: audio.AudioRendererWriteDataCallback;
let readDataCallback: Callback<ArrayBuffer> = (_buffer: ArrayBuffer) => {};
// [EndExclude renderer_interrupt]

let isPlaying: boolean; // 是否正在播放，实际开发中，对应与音频播放状态相关的模块。
let isDucked: boolean; // 是否降低音量，实际开发中，对应与音频音量相关的模块。
let started: boolean; // 标识符，记录“开始播放（start）”操作是否成功。

async function onAudioInterrupt(): Promise<void> {
  if (audioRenderer == undefined) {
    return;
  }
  // 此处以使用AudioRenderer开发音频播放功能举例，变量audioRenderer即为播放时创建的AudioRenderer实例。
  audioRenderer.on('audioInterrupt', async(interruptEvent: audio.InterruptEvent) => {
    // [StartExclude renderer_interrupt]
    if (globalCallbackUpdate) {
      globalCallbackUpdate(`audioInterruptCallback interruptEvent: ${JSON.stringify(interruptEvent)}`);
    }
    // [EndExclude renderer_interrupt]
    // 在发生音频焦点变化时，audioRenderer收到interruptEvent回调，此处根据其内容做相应处理。
    // 1. 可选：读取interruptEvent.forceType的类型，判断系统是否已强制执行相应操作。
    // 注：默认焦点策略下，INTERRUPT_HINT_RESUME为INTERRUPT_SHARE类型，其余hintType均为INTERRUPT_FORCE类型。因此对forceType可不做判断。
    // 2. 必选：读取interruptEvent.hintType的类型，做出相应的处理。
    if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_FORCE) {
      // 强制打断类型（INTERRUPT_FORCE）：音频相关处理已由系统执行，应用需更新自身状态，做相应调整。
      switch (interruptEvent.hintType) {
        case audio.InterruptHint.INTERRUPT_HINT_PAUSE:
          // 此分支表示系统已将音频流暂停（临时失去焦点），为保持状态一致，应用需切换至音频暂停状态。
          // 临时失去焦点：待其他音频流释放音频焦点后，本音频流会收到resume对应的音频焦点事件，到时可自行继续播放。
          isPlaying = false; // 此句为简化处理，代表应用切换至音频暂停状态的若干操作。
          break;
        case audio.InterruptHint.INTERRUPT_HINT_STOP:
          // 此分支表示系统已将音频流停止（永久失去焦点），为保持状态一致，应用需切换至音频暂停状态。
          // 永久失去焦点：后续不会再收到任何音频焦点事件，若想恢复播放，需要用户主动触发。
          isPlaying = false; // 此句为简化处理，代表应用切换至音频暂停状态的若干操作。
          break;
        case audio.InterruptHint.INTERRUPT_HINT_DUCK:
          // 此分支表示系统已将音频音量降低（默认降到正常音量的20%）。
          isDucked = true; // 此句为简化处理，代表应用切换至降低音量播放状态的若干操作。
          break;
        case audio.InterruptHint.INTERRUPT_HINT_UNDUCK:
          // 此分支表示系统已将音频音量恢复正常。
          isDucked = false; // 此句为简化处理，代表应用切换至正常音量播放状态的若干操作。
          break;
        default:
          break;
      }
    } else if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_SHARE) {
      // 共享打断类型（INTERRUPT_SHARE）：应用可自主选择执行相关操作或忽略音频焦点事件。
      switch (interruptEvent.hintType) {
        case audio.InterruptHint.INTERRUPT_HINT_RESUME:
          // 此分支表示临时失去焦点后被暂停的音频流此时可以继续播放，建议应用继续播放，切换至音频播放状态。
          // 若应用此时不想继续播放，可以忽略此音频焦点事件，不进行处理即可。
          // 继续播放，此处主动执行start()，以标识符变量started记录start()的执行结果。
          if (audioRenderer == undefined) {
            return;
          }
          try {
            await audioRenderer.start();
            started = true;
          } catch (err) {
            let error = err as BusinessError;
            console.error(`Failed to start audio renderer. Code: ${error.code}, message: ${error.message}`);
            started = false;
          }
          // 若start()执行成功，则切换至音频播放状态。
          if (started) {
            isPlaying = true; // 此句为简化处理，代表应用切换至音频播放状态的若干操作。
          } else {
            // 音频继续播放的操作执行失败。
          }
          break;
        default:
          break;
      }
    }
  });
}
// [End renderer_interrupt]

async function initArguments(context: common.UIAbilityContext) {
  let bufferSize: number = 0;
  let file = await context.resourceManager.getRawFd('S16LE_2_48000.pcm');
  writeDataCallback = (buffer: ArrayBuffer) => {
    let options: Options = {
      offset: bufferSize + file.offset,
      length: buffer.byteLength
    };
    if (bufferSize > file.length) {
      return audio.AudioDataCallbackResult.INVALID;
    }
    try {
      let bufferLength = fs.readSync(file.fd, buffer, options);
      bufferSize += buffer.byteLength;
      if (bufferSize > file.length) {
        let view = new DataView(buffer);
        for (let i = bufferSize - file.length; i < buffer.byteLength; i++) {
          view.setUint8(i, 0);
        }
      }
      return audio.AudioDataCallbackResult.VALID;
    } catch (error) {
      console.error(`Failed to read file. Code: ${error.code}, message: ${error.message}`);
      return audio.AudioDataCallbackResult.INVALID;
    }
  };
}

// 初始化，创建实例，设置监听事件。
async function init() {
  audio.createAudioRenderer(audioRendererOptions, (err, renderer) => { // 创建AudioRenderer实例。
    if (!err) {
      console.info('Succeeded in creating audio renderer.');
      if (globalLogUpdate) {
        globalLogUpdate('Succeeded in creating audio renderer.', false);
      }
      audioRenderer = renderer;
      if (audioRenderer !== undefined) {
        audioRenderer.on('writeData', writeDataCallback);
      }
    } else {
      console.info(`Failed to create audio renderer. Code: ${err.code}, message: ${err.message}`);
      if (globalLogUpdate) {
        globalLogUpdate(`Failed to create audio renderer. Code: ${err.code}, message: ${err.message}`, true);
      }
    }
  });
}

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  try {
    let result: PermissionRequestResult = await atManager
      .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
    return result.authResults[0] === 0;
  } catch (err) {
    let error = err as BusinessError;
    console.error(`request microphone permission failed. Code: ${error.code}, message: ${error.message}`);
    return false;
  }
}

async function initAudioCapturerForSession(): Promise<boolean> {
  if (audioCapturer !== undefined && audioCapturer.state.valueOf() !== audio.AudioState.STATE_RELEASED) {
    if (globalLogUpdate) {
      globalLogUpdate('AudioCapturer has been created.', false);
    }
    return true;
  }

  return new Promise<boolean>((resolve) => {
    audio.createAudioCapturer(audioCapturerOptions, (err, capturer) => {
      if (err) {
        const errorMsg = `Failed to create audio capturer. Code: ${err.code}, message: ${err.message}`;
        console.error(errorMsg);
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        resolve(false);
        return;
      }

      audioCapturer = capturer;
      if (audioCapturer !== undefined) {
        audioCapturer.on('readData', readDataCallback);
      }
      console.info('Succeeded in creating audio capturer.');
      if (globalLogUpdate) {
        globalLogUpdate('Succeeded in creating audio capturer.', false);
      }
      resolve(true);
    });
  });
}

async function startAudioCapturerForSession(): Promise<boolean> {
  if (audioCapturer === undefined) {
    if (globalLogUpdate) {
      globalLogUpdate('AudioCapturer has not been created.', true);
    }
    return false;
  }

  let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
  if (stateGroup.indexOf(audioCapturer.state.valueOf()) === -1) {
    if (globalLogUpdate) {
      globalLogUpdate('AudioCapturer state is invalid.', true);
    }
    return false;
  }

  return new Promise<boolean>((resolve) => {
    audioCapturer?.start((err: BusinessError) => {
      if (err) {
        const errorMsg = `Failed to start audio capturer. Code: ${err.code}, message: ${err.message}`;
        console.error(errorMsg);
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        resolve(false);
        return;
      }

      console.info('Succeeded in starting audio capturer.');
      if (globalLogUpdate) {
        globalLogUpdate('Succeeded in starting audio capturer.', false);
      }
      resolve(true);
    });
  });
}

async function releaseAudioCapturerForSession(): Promise<boolean> {
  if (audioCapturer === undefined || audioCapturer.state.valueOf() === audio.AudioState.STATE_RELEASED) {
    if (globalLogUpdate) {
      globalLogUpdate('AudioCapturer has been released.', false);
    }
    return true;
  }

  if (audioCapturer.state.valueOf() === audio.AudioState.STATE_RUNNING ||
    audioCapturer.state.valueOf() === audio.AudioState.STATE_PAUSED) {
    await new Promise<void>((resolve) => {
      audioCapturer?.stop(() => {
        resolve();
      });
    });
  }

  return new Promise<boolean>((resolve) => {
    audioCapturer?.release((err: BusinessError) => {
      if (err) {
        const errorMsg = `Failed to release audio capturer. Code: ${err.code}, message: ${err.message}`;
        console.error(errorMsg);
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        resolve(false);
        return;
      }

      audioCapturer = undefined;
      console.info('Succeeded in releasing audio capturer.');
      if (globalLogUpdate) {
        globalLogUpdate('Succeeded in releasing audio capturer.', false);
      }
      resolve(true);
    });
  });
}

async function start() {
  if (audioRenderer !== undefined) {
    let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    if (stateGroup.indexOf(audioRenderer.state.valueOf()) === -1) { // 当且仅当状态为prepared、paused和stopped之一时才能启动渲染。
      console.error('Audio renderer state is invalid.');
      if (globalLogUpdate) {
        globalLogUpdate('Audio renderer state is invalid.', true);
      }
      return;
    }
    audioRenderer.start((err: BusinessError) => {
      if (err) {
        console.error(`Failed to start audio renderer. Code: ${err.code}, message: ${err.message}`);
        if (globalLogUpdate) {
          globalLogUpdate(`Failed to start audio renderer. Code: ${err.code}, message: ${err.message}`, true);
        }
      } else {
        console.info('Succeeded in starting audio renderer.');
        if (globalLogUpdate) {
          globalLogUpdate('Succeeded in starting audio renderer.', false);
        }
      }
    });
  }
}

async function stop() {
  if (audioRenderer !== undefined) {
    if (audioRenderer.state.valueOf() !== audio.AudioState.STATE_RUNNING &&
      audioRenderer.state.valueOf() !== audio.AudioState.STATE_PAUSED) {
      console.info('Audio renderer state is not running or paused.');
      if (globalLogUpdate) {
        globalLogUpdate('Audio renderer state is not running or paused.', true);
      }
      return;
    }
    audioRenderer.stop((err: BusinessError) => {
      if (err) {
        console.error(`Failed to stop audio renderer. Code: ${err.code}, message: ${err.message}`);
        if (globalLogUpdate) {
          globalLogUpdate(`Failed to stop audio renderer. Code: ${err.code}, message: ${err.message}`, true);
        }
      } else {
        console.info('Succeeded in stopping audio renderer.');
        if (globalLogUpdate) {
          globalLogUpdate('Succeeded in stopping audio renderer.', false);
        }
      }
    });
  }
}
// [EndExclude get_session_manager]
// [EndExclude audio_session_v1]
// [EndExclude set_default_output_device]

let audioManager = audio.getAudioManager();
// 创建音频会话管理器。
let audioSessionManager: audio.AudioSessionManager = audioManager.getSessionManager();
// [End get_session_manager]
// [StartExclude audio_session_v1]
// [StartExclude set_default_output_device]

async function setSessionCapturerMuteHint(muteHint: boolean): Promise<boolean> {
  if (audioCapturer === undefined || audioCapturer.state.valueOf() !== audio.AudioState.STATE_RUNNING) {
    const errorMsg = 'AudioCapturer is not running.';
    console.error(errorMsg);
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    return false;
  }

  // [Start set_capturer_mute_hint]
  try {
    await audioSessionManager.setCapturerMuteHint(muteHint);
    console.info(`setCapturerMuteHint ${muteHint} success.`);
    // [StartExclude set_capturer_mute_hint]
    if (globalLogUpdate) {
      globalLogUpdate(`setCapturerMuteHint ${muteHint} success.`, false);
    }
    return true;
    // [EndExclude set_capturer_mute_hint]
  } catch (err) {
    let error = err as BusinessError;
    console.error(`setCapturerMuteHint ${muteHint} failed. Code: ${error.code}, message: ${error.message}`);
    // [StartExclude set_capturer_mute_hint]
    if (globalLogUpdate) {
      globalLogUpdate(`setCapturerMuteHint ${muteHint} failed. Code: ${error.code}, message: ${error.message}`, true);
    }
    return false;
    // [EndExclude set_capturer_mute_hint]
  }
  // [End set_capturer_mute_hint]
}

async function useAudioSessionV1(){
  // [EndExclude activate_audio_session_v1]
  // [EndExclude set_default_output_device]

  // [EndExclude audio_session_v1]
  // 设置音频并发模式。
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS
  };

  // 激活音频会话。
  audioSessionManager.activateAudioSession(strategy).then(() => {
    console.info('Succeeded in activating audio session.');
    // [StartExclude activate_audio_session_v1]
    // [StartExclude audio_session_v1]
    // [StartExclude set_default_output_device]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in activating audio session.', false);
    }
    // [EndExclude activate_audio_session_v1]
    // [EndExclude audio_session_v1]
    // [EndExclude set_default_output_device]
  }).catch((err: BusinessError) => {
    console.error(`Failed to activate audio session. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude activate_audio_session_v1]
    // [StartExclude audio_session_v1]
    // [StartExclude set_default_output_device]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to activate audio session. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude activate_audio_session_v1]
    // [EndExclude audio_session_v1]
    // [EndExclude set_default_output_device]
  });
  // [End activate_audio_session_v1]

  // [StartExclude set_default_output_device]
  // [Start is_audio_session_activated]
  // 查询音频会话是否已激活。
  let isActivated = audioSessionManager.isAudioSessionActivated();
  // [End is_audio_session_activated]
  // [EndExclude on_audio_session_deactivated]

  // 监听音频会话停用事件。
  audioSessionManager.on('audioSessionDeactivated', (audioSessionDeactivatedEvent: audio.AudioSessionDeactivatedEvent) => {
    // [StartExclude on_audio_session_deactivated]
    // [StartExclude audio_session_v1]
    if (globalCallbackUpdate) {
      globalCallbackUpdate(`audioSessionDeactivatedCallback audioSessionDeactivatedEvent: ${JSON.stringify(audioSessionDeactivatedEvent)}`);
    }
    // [EndExclude on_audio_session_deactivated]
    // [EndExclude audio_session_v1]
    console.info(`Succeeded in using on function. AudioSessionDeactivatedEvent: ${JSON.stringify(audioSessionDeactivatedEvent)}`);
  });
  // [End on_audio_session_deactivated]

  if (isActivated) {
    // 音频会话激活后，应用在此处正常执行音频播放、暂停、停止、释放等操作即可。
  }
  // [StartExclude audio_session_v1]
}

async function useAudioSessionV2(){
  // [EndExclude activate_audio_session_v2]
  // [EndExclude audio_session_v2]
  // [EndExclude enable_mute_suggestion]

  // 应用根据业务场景设置适合自己的音频会话场景，激活AudioSession时，系统会根据应用选择的音频会话场景申请对应的音频焦点。
  audioSessionManager.setAudioSessionScene(audio.AudioSessionScene.AUDIO_SESSION_SCENE_MEDIA);
  // [StartExclude activate_audio_session_v2]
  // [StartExclude audio_session_v2]

  // 本接口必须在激活音频会话前调用才会生效。
  audioSessionManager.enableMuteSuggestionWhenMixWithOthers(true);
  // [EndExclude activate_audio_session_v2]
  // [EndExclude audio_session_v2]

  // 设置音频会话策略。
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS
  };

  // 激活AudioSession。
  audioSessionManager.activateAudioSession(strategy).then(() => {
    console.info('Succeeded in activating audio session.');
    // [StartExclude activate_audio_session_v2]
    // [StartExclude audio_session_v2]
    // [StartExclude enable_mute_suggestion]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in activating audio session.', false);
    }
    // [EndExclude activate_audio_session_v2]
    // [EndExclude audio_session_v2]
    // [EndExclude enable_mute_suggestion]
  }).catch((err: BusinessError) => {
    console.error(`Failed to activate audio session. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude activate_audio_session_v2]
    // [StartExclude audio_session_v2]
    // [StartExclude enable_mute_suggestion]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to activate audio session. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude activate_audio_session_v2]
    // [EndExclude audio_session_v2]
    // [EndExclude enable_mute_suggestion]
  });
  // [End activate_audio_session_v2]
  // [EndExclude on_audio_session_state_changed]
  // [End enable_mute_suggestion]

  // 监听AudioSession焦点和状态变化事件。
  let audioSessionStateChangedCallback = (audioSessionStateChangedEvent: audio.AudioSessionStateChangedEvent) => {
    // [StartExclude on_audio_session_state_changed]
    // [StartExclude audio_session_v2]
    if (globalCallbackUpdate) {
      globalCallbackUpdate(`audioSessionStateChangedCallback audioSessionStateChangedEvent: ${JSON.stringify(audioSessionStateChangedEvent)}`);
    }
    // [EndExclude on_audio_session_state_changed]
    // [EndExclude audio_session_v2]
    console.info(`hint of audioSessionStateChanged: ${audioSessionStateChangedEvent.stateChangeHint} `);

    switch (audioSessionStateChangedEvent.stateChangeHint) {
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_PAUSE:
        // 此分支表示系统已将音频流暂停，应用需切换至音频暂停状态。
        // 临时失去焦点：AudioSession会停用并释放焦点，同时停止应用所有音频流的播放。因此，当应用收到Resume回调后，需要重新激活AudioSession并恢复需要继续播放的音频流。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_RESUME:
        // 此分支表示系统解除AudioSession焦点的暂停操作。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_STOP:
        // 此分支表示系统已将音频流停止（永久失去焦点），为保持状态一致，应用需切换至音频暂停状态。
        // 永久失去焦点：AudioSession会停用并释放焦点，同时停止应用所有音频流的播放。后续不会再收到音频焦点事件，恢复播放需用户主动触发。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_TIME_OUT_STOP:
        // 此分支表示由于长时间无音频流播放，系统已将AudioSession停止（永久失去焦点），应用需切换至音频停止状态。
        // 永久失去焦点：后续不会再收到音频焦点事件，恢复播放需用户主动触发。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_DUCK:
        // 此分支表示系统已将应用所有播放音频流音量降低（默认降到正常音量的20%）。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_UNDUCK:
        // 此分支表示系统已将应用所有播放音频流音量恢复正常。
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_MUTE_SUGGESTION:
        // 此分支表示其他应用开始播放非混音音频，系统可自行决定是否静音。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_UNMUTE_SUGGESTION:
        // 此分支表示其他应用的非混音音频播放结束，系统可自行决定是否取消静音。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_MUTE:
        // 此分支表示系统已将应用所有播放音频流静音。
        break;
      case audio.AudioSessionStateChangeHint.AUDIO_SESSION_STATE_CHANGE_HINT_UNMUTE:
        // 此分支表示系统已将应用所有播放音频流解除静音。
        break;
      default:
        break;
    }
  };

  audioSessionManager.on('audioSessionStateChanged', audioSessionStateChangedCallback);
  // [End on_audio_session_state_changed]

  // 查询音频会话是否已激活。
  let isActivated = audioSessionManager.isAudioSessionActivated();

  if (isActivated) {
    // 音频会话激活后，应用在此处正常执行音频播放、暂停、停止、释放等操作即可。
    // 根据实际业务，应用可以启动多个AudioRenderer音频播放流。此处启动的音频播放流不再持有焦点，统一由AudioSession管理。
    // 如果存在多条音频流同时播放，需要特别注意AudioSession停用时机（停用AudioSession时会同时释放应用所有音频播放流）。
  }
  // [StartExclude audio_session_v2]
}

async function setSessionBehavior(){
  // [EndExclude set_session_behavior]

  // 应用根据业务场景设置适合自己的音频会话场景，激活AudioSession时，系统会根据应用选择的音频会话场景申请对应的音频焦点。
  audioSessionManager.setAudioSessionScene(audio.AudioSessionScene.AUDIO_SESSION_SCENE_MEDIA);

  // 本接口应在激活音频会话前调用。
  // 若音频会话在激活状态时调用此接口后，必须重新激活音频会话使其生效。
  let behavior = audio.AudioSessionBehaviorFlags.MUTE_WHEN_INTERRUPTED;
  audioSessionManager.setAudioSessionBehavior(behavior);

  // 设置音频会话策略。
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS
  };

  // 激活AudioSession。
  audioSessionManager.activateAudioSession(strategy).then(() => {
    console.info('Succeeded in activating audio session.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to activate audio session. Code: ${err.code}, message: ${err.message}`);
  });
  // [End set_session_behavior]
}

async function deactivateAudioSession(){
  // [EndExclude audio_session_v1]

  // 取消监听音频会话停用事件。
  audioSessionManager.off('audioSessionDeactivated');

  // [StartExclude audio_session_v1]
  // [EndExclude audio_session_v2]

  // 业务结束，取消监听AudioSession焦点和状态变化事件。
  audioSessionManager.off('audioSessionStateChanged');
  // [StartExclude audio_session_v2]

  // [EndExclude deactivate_audio_session_v1]

  // [EndExclude audio_session_v1]
  // 停用音频会话。
  // [StartExclude deactivate_audio_session_v1]
  // [StartExclude audio_session_v1]
  // [EndExclude deactivate_audio_session_v2]
  // [EndExclude audio_session_v2]

  // 停用AudioSession，即释放焦点并停用该应用正在播放的所有音频流。
  // [EndExclude deactivate_audio_session_v1]
  // [EndExclude audio_session_v1]
  audioSessionManager.deactivateAudioSession().then(() => {
    console.info('Succeeded in deactivating audio session.');
    // [StartExclude deactivate_audio_session_v1]
    // [StartExclude audio_session_v1]
    // [StartExclude deactivate_audio_session_v2]
    // [StartExclude audio_session_v2]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in deactivating audio session.', false);
    }
    // [EndExclude deactivate_audio_session_v1]
    // [EndExclude audio_session_v1]
    // [EndExclude deactivate_audio_session_v2]
    // [EndExclude audio_session_v2]
  }).catch((err: BusinessError) => {
    console.error(`Failed to deactivate audio session. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude deactivate_audio_session_v1]
    // [StartExclude audio_session_v1]
    // [StartExclude deactivate_audio_session_v2]
    // [StartExclude audio_session_v2]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to deactivate audio session. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude deactivate_audio_session_v1]
    // [EndExclude audio_session_v1]
    // [EndExclude deactivate_audio_session_v2]
    // [EndExclude audio_session_v2]
  });
  // [End deactivate_audio_session_v1]
  // [End audio_session_v1]
  // [End deactivate_audio_session_v2]
  // [End audio_session_v2]
}

async function setDefaultOutputDeviceToSpeaker(){
  // [EndExclude set_default_output_device]
  // 设置默认输出设备为听筒。
  audioSessionManager.setDefaultOutputDevice(audio.DeviceType.EARPIECE).then(() => {
    console.info('Succeeded in setting default output device.');
    // [StartExclude set_default_output_device]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in setting default output device.', false);
    }
    // [EndExclude set_default_output_device]
  }).catch((err: BusinessError) => {
    console.error(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude set_default_output_device]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude set_default_output_device]
  });
  // [StartExclude set_default_output_device]
}

async function setDefaultOutputDeviceToDefault(){
  // [EndExclude set_default_output_device]

  // 设置默认输出设备为默认设备,即取消应用设置的默认设备,交由系统选择设备。
  audioSessionManager.setDefaultOutputDevice(audio.DeviceType.DEFAULT).then(() => {
    console.info('Succeeded in setting default output device.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`);
  });
  // [End set_default_output_device]
}

async function printAudioSessionInfo(context: common.UIAbilityContext){
  // [EndExclude print_session_info]
  // 设置音频并发模式。
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS
  };
  // 激活音频会话。
  await audioSessionManager.activateAudioSession(strategy);

  // 创建音频调试管理器。
  let audioDebuggingManager: audio.AudioDebuggingManager = audioManager.getDebuggingManager();

  // 输出到hilog日志。
  audioDebuggingManager.printSessionInfo(audioSessionManager, -1);

  // fd 文件描述符，实际使用时请根据具体情况获取
  let filePath = context.filesDir + '/audio_session_info.txt';
  let fd = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC).fd;
  // 输出到文件。
  audioDebuggingManager.printSessionInfo(audioSessionManager, fd);
  fs.closeSync(fd);
  // [End print_session_info]
  console.info('print audio session info filePath: ' + filePath);
}

@Entry
@Component
struct Index {
  @State private runningResult: string = '暂无运行结果';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

  aboutToAppear(): void {
    // 设置全局回调。
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
    globalCallbackUpdate = (msg) => this.updateCallbackInfo(msg);
  }

  // 更新日志信息。
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  // 更新回调信息。
  updateCallbackInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.callbackMessages = `[${timestamp}] ${msg}`;
  }

  build(): void {
    Scroll() {
      Column() {
        // 信息显示区域。
        Column() {
          Text('实时状态信息')
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          // 运行结果。
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

          // 日志信息。
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

          // 回调信息。
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

        // 功能按钮。
        Row() {
          Button() {
            Text('初始化audioRenderer').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            await initArguments(context);
            await init();
            this.runningResult = 'Init audioRenderer success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('监听audioRenderer焦点变化').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await onAudioInterrupt();
            this.runningResult = 'Register audioInterruptCallback success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('使用音频会话修改焦点策略').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await useAudioSessionV1();
            this.runningResult = 'Activate audioSession V1 success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('使用音频会话申请焦点策略').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await useAudioSessionV2();
            this.runningResult = 'Activate audioSession V2 success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('使用音频会话行为设置策略').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await setSessionBehavior();
            this.runningResult = 'Set session behavior and activate audioSession V2 success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('初始化audioCapturer').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let hasPermission = await requestMicrophonePermission(context);
            if (!hasPermission) {
              this.runningResult = 'Microphone permission denied.';
              this.updateLogInfo('Microphone permission denied.', true);
              return;
            }
            const isSuccess = await initAudioCapturerForSession();
            this.runningResult = isSuccess ? 'Init audioCapturer success.' : 'Init audioCapturer failed.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('开始录制').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            const isSuccess = await startAudioCapturerForSession();
            this.runningResult = isSuccess ? 'Start audioCapturer success.' : 'Start audioCapturer failed.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('设置会话录音静音提示').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            const isSuccess = await setSessionCapturerMuteHint(true);
            this.runningResult = isSuccess ? 'Report session capturer mute hint success.' :
              'Report session capturer mute hint failed.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('解除会话录音静音提示').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            const isSuccess = await setSessionCapturerMuteHint(false);
            this.runningResult = isSuccess ? 'Clear session capturer mute hint success.' :
              'Clear session capturer mute hint failed.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('开始播放').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await start();
            this.runningResult = 'Start audioRenderer success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('切换到听筒播放').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await setDefaultOutputDeviceToSpeaker();
            this.runningResult = 'Succeeded in setting default output device.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('停止播放').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await stop();
            this.runningResult = 'Stop audioRenderer success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('释放audioCapturer').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            const isSuccess = await releaseAudioCapturerForSession();
            this.runningResult = isSuccess ? 'Release audioCapturer success.' : 'Release audioCapturer failed.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('停用音频会话').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            await deactivateAudioSession();
            this.runningResult = 'Deactivate audioSession success.';
          })
        }
        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.Center)

        Row() {
          Button() {
            Text('打印音频会话调试信息').fontSize(15).fontColor(Color.White)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            await printAudioSessionInfo(context);
            this.runningResult = 'Print audioSession info success.';
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
