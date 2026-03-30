/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { audio } from '@kit.AudioKit';
import { router } from  '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { wantAgent, WantAgent } from '@kit.AbilityKit'

export class AudioPlayer {
  private  player: media.AVPlayer | null = null;
  private isLoop: boolean = false;
  private durationMs: number = 60000;
  private streamUsage: audio.StreamUsage = audio.StreamUsage.STREAM_USAGE_MUSIC;
  private timeoutTimer: number = 0;
  private isManuallyStopped: boolean = false;

  async avSetAudio(streamUsage: audio.StreamUsage, file: string, isLoop: boolean) {
    const context = getContext(this) as common.UIAbilityContext;
    const fileDescriptor = await context.resourceManager.getRawFd(file);
    let avFileDescriptor: media.AVFileDescriptor =
      { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };

    if (this.player) {
      console.info('init avPlayer release2createNew');
      this.player.release();
      await this.msleepAsync(1500);
    }

    //创建avPlayer实例对象
    this.player = await media.createAVPlayer();

    await this.setAVPlayerCallback();

    this.isLoop = isLoop;
    this.player.fdSrc = avFileDescriptor;
    this.streamUsage = streamUsage;
  }

  async msleepAsync(ms: number): Promise<boolean> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve(true)
      }, ms)
    });
  }

  async setAVPlayerCallback(): Promise<void> {
    if (this.player == null) {
      return;
    }
    // 状态机变化回调函数
    this.player.on('stateChange', async (state, reason) => {
      if (this.player == null) {
        return;
      }
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('setAVPlayerCallback AVPlayer state idle called.');
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('setAVPlayerCallback AVPlayer state initialized called.');
          this.player.audioRendererInfo = { usage: this.streamUsage, rendererFlags: 0 };
          this.player.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('setAVPlayerCallback AVPlayer state prepared called.');
          this.player.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
            console.info(`bufferingUpdate called, infoType value: ${infoType}, value:${value}}`);
          })
          if (this.isLoop) {
            this.startLoop();
          } else {
            this.play();
          }
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('setAVPlayerCallback AVPlayer state playing called.');
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('setAVPlayerCallback AVPlayer state completed called.');
          this.player.off('bufferingUpdate')
          break;
        case 'released':
          console.info('setAVPlayerCallback released called.');
          break
        case 'stopped':
          console.info('setAVPlayerCallback AVPlayer state stopped called.');
          break
        case 'error':
          console.error('setAVPlayerCallback AVPlayer state error called.');
          break
        case 'paused':
          console.info('setAVPlayerCallback AVPlayer state paused called.');
          break
        default:
          console.info('setAVPlayerCallback AVPlayer state unknown called.');
          break;
      }
    });
  }

  async play(): Promise<void> {
    if (this.player) {
      await this.player.play();
    }
  }

  async startLoop(): Promise<void> {
    if (!this.player) {
      return;
    }

    this.player.loop = true;
    await this.player.play();
    this.isManuallyStopped = false;

    return new Promise<void>((resolve) => {
      this.timeoutTimer = setTimeout(() => {
        if (this.isManuallyStopped) {
          console.info('Audio was manually stopped, skip timeout dialog');
          resolve();
          return;
        }
        
        if (this.player) {
          this.player.loop = false;
          this.player.stop();
          this.player.release();
          this.player = null;
        }
        resolve();
        AlertDialog.show({
          title: '提示',
          message: '响铃超时',
          autoCancel: false,
          confirm: {
            value: '确认',
            action: ()=> {
              router.back({ url: 'pages/Index' });
          }
          }
        });
      }, this.durationMs)
    });
  }
  stop():void {
    this.isManuallyStopped = true;
    if (this.timeoutTimer !== 0) {
      clearTimeout(this.timeoutTimer);
      this.timeoutTimer = 0;
    }
    if (this.player) {
      this.player.stop();
    }
  }

  release(): void {
    if (this.player) {
      this.player.release();
      this.player = null;
    }
  }

  // 开启长时任务
  startContinuousTask(context: Context) {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: 'com.example.backgroundmusic',
          abilityName: 'MainAbility'
        }
      ],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 0,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
    };

    try {
      // 通过wantAgent模块下getWantAgent方法获取WantAgent对象
      wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
        try {
          let list: string[] = ['audioPlayback'];
          backgroundTaskManager.startBackgroundRunning(context, list, wantAgentObj)
            .then(() => {
              console.info('Operation startBackgroundRunning succeeded');
            })
            .catch((error: BusinessError) => {
              console.error(`Failed to Operation startBackgroundRunning. code is ${error.code} message is ${error.message}`);
            });
        } catch (error) {
          console.error(`Failed to Operation startBackgroundRunning. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
        }
        ;
      });
    } catch (error) {
      console.error(`Failed to Operation getWantAgent. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  // 取消长时任务
  stopContinuousTask(context: Context) {
    backgroundTaskManager.stopBackgroundRunning(context).then(() => {
      console.info(`Succeeded in operationing stopBackgroundRunning.`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
    });
  }
}