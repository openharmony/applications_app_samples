/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { BusinessError } from '@kit.BasicServicesKit';

export interface AVPlayerListener {
  onPlaying() : void;
  onPaused() : void;
  onDurationChanged(duration: number) : void;
  onBufferedTimeChanged(buffered: number) : void;
  onTimeUpdate(time: number) : void;
  onEnded() : void;
  onError() : void;
  onVideoSizeChanged(width: number, height: number): void;
  onDestroyed(): void;
}

interface PlayerParam {
  url: string;
  listener?: AVPlayerListener;
  httpHeaders?: Record<string, string>;
}

interface PlayCommand {
  func: Function;
  name?: string;
}

interface CheckPlayCommandResult {
  ignore: boolean;
  indexToRemove: number;
}

export class AVPlayerDemo {
  // surfaceID用于播放画面显示，具体的值需要通过Xcomponent接口获取，相关文档链接见上面Xcomponent创建方法
  private surfaceID: string = '';

  public avPlayer?: media.AVPlayer;
  public prepared: boolean = false;

  public commands: PlayCommand[] = [];

  setSurfaceID(id: string) {
    console.log(`AVPlayerDemo.setSurfaceID : ${id}`);
    this.surfaceID = id;
  }
  // 注册avplayer回调函数
  setAVPlayerCallback(avPlayer: media.AVPlayer, listener?: AVPlayerListener) {
    // seek操作结果回调函数
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用reset接口触发重置流程
    avPlayer.on('error', (err: BusinessError) => {
      console.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      listener?.onError();
      avPlayer.reset(); // 调用reset重置资源，触发idle状态
    });
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('AVPlayer state idle called.');
          avPlayer.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('AVPlayer state initialized called.');
          avPlayer.surfaceId = this.surfaceID; // 设置显示画面，当播放的资源为纯音频时无需设置
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.');
          this.prepared = true;
          this.schedule();
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('AVPlayer state playing called.');
          listener?.onPlaying();
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.');
          listener?.onPaused();
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.');
          listener?.onEnded();
          break;
        case 'released':
          this.prepared = false;
          listener?.onDestroyed();
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    });
    avPlayer.on('durationUpdate', (duration: number) => {
      console.info(`AVPlayer state durationUpdate success,new duration is :${duration}`);
      listener?.onDurationChanged(duration/1000);
    });
    avPlayer.on('timeUpdate', (time:number) => {
      listener?.onTimeUpdate(time/1000);
    });
    avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      console.info(`AVPlayer state bufferingUpdate success,and infoType value is:${infoType}, value is : ${value}`);
      if (infoType == media.BufferingInfoType.BUFFERING_PERCENT) {
      }
      listener?.onBufferedTimeChanged(value);
    })
    avPlayer.on('videoSizeChange', (width: number, height: number) => {
      console.info(`AVPlayer state videoSizeChange success,and width is:${width}, height is : ${height}`);
      listener?.onVideoSizeChanged(width, height);
    })
  }

  // 以下demo为通过url设置网络地址来实现播放直播码流的demo
  async avPlayerLiveDemo(playerParam: PlayerParam) {
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数
    this.setAVPlayerCallback(this.avPlayer, playerParam.listener);

    let mediaSource: media.MediaSource = media.createMediaSourceWithUrl(playerParam.url, playerParam.httpHeaders);
    let strategy: media.PlaybackStrategy = {
      preferredWidth: 100,
      preferredHeight: 100,
      preferredBufferDuration: 100,
      preferredHdr: false
    };
    this.avPlayer.setMediaSource(mediaSource, strategy);
    console.log(`AVPlayer url:[${playerParam.url}]`);
  }

  schedule() {
    if (!this.avPlayer) {
      return;
    }
    if (!this.prepared) {
      return;
    }
    if (this.commands.length > 0) {
      let command = this.commands.shift();
      if (command) {
        command.func();
      }
      if (this.commands.length > 0) {
        setTimeout(() => {
          this.schedule();
        });
      }
    }
  }

  private checkCommand(selfName: string, oppositeName: string) {
    let indexToRemove = -1;
    let ignoreThisAction = false;
    let index = this.commands.length - 1;
    while (index >= 0) {
      if (this.commands[index].name == selfName) {
        ignoreThisAction = true;
        break;
      }
      if (this.commands[index].name == oppositeName) {
        indexToRemove = index;
        break;
      }
      index--;
    }

    let result : CheckPlayCommandResult = {
      ignore: ignoreThisAction,
      indexToRemove: indexToRemove,
    };
    return result;
  }

  play() {
    let commandName = 'play';
    let checkResult = this.checkCommand(commandName, 'pause');
    if (checkResult.ignore) {
      console.log(`AVPlayer ${commandName} ignored.`);
      this.schedule();
      return;
    }
    if (checkResult.indexToRemove >= 0) {
      let removedCommand = this.commands.splice(checkResult.indexToRemove, 1);
      console.log(`AVPlayer ${JSON.stringify(removedCommand)} removed.`);
      return;
    }
    this.commands.push({ func: ()=>{
      console.info('AVPlayer.play()');
      this.avPlayer?.play();
    }, name: commandName});
    this.schedule();
  }
  pause() {
    let commandName = 'pause';
    let checkResult = this.checkCommand(commandName, 'play');
    console.log(`checkResult:${JSON.stringify(checkResult)}`);
    if (checkResult.ignore) {
      console.log(`AVPlayer ${commandName} ignored.`);
      this.schedule();
      return;
    }
    if (checkResult.indexToRemove >= 0) {
      let removedCommand = this.commands.splice(checkResult.indexToRemove, 1);
      console.log(`AVPlayer ${JSON.stringify(removedCommand)} removed.`);
      return;
    }
    this.commands.push({ func: ()=>{
      console.info('AVPlayer.pause()');
      this.avPlayer?.pause();
    }, name: commandName});
    this.schedule();
  }
  release() {
    this.commands.push({ func: ()=>{
      console.info('AVPlayer.release()');
      this.avPlayer?.release();
    }});
    this.schedule();
  }
  seek(time: number) {
    this.commands.push({ func: ()=>{
      console.info(`AVPlayer.seek(${time})`);
      this.avPlayer?.seek(time * 1000);
    }});
    this.schedule();
  }
  setVolume(volume: number) {
    this.commands.push({ func: ()=>{
      console.info(`AVPlayer.setVolume(${volume})`);
      this.avPlayer?.setVolume(volume);
    }});
    this.schedule();
  }
  setPlaybackRate(playbackRate: number) {
    let speed = media.PlaybackSpeed.SPEED_FORWARD_1_00_X;
    let delta = 0.05;
    playbackRate += delta;
    if (playbackRate < 1) {
      speed = media.PlaybackSpeed.SPEED_FORWARD_0_75_X;
    } else if (playbackRate < 1.25) {
      speed = media.PlaybackSpeed.SPEED_FORWARD_1_00_X;
    } else if (playbackRate < 1.5) {
      speed = media.PlaybackSpeed.SPEED_FORWARD_1_25_X;
    } else if (playbackRate < 2) {
      speed = media.PlaybackSpeed.SPEED_FORWARD_1_75_X;
    } else {
      speed = media.PlaybackSpeed.SPEED_FORWARD_2_00_X;
    }
    this.commands.push({ func: ()=>{
      console.info(`AVPlayer.setSpeed(${speed})`);
      this.avPlayer?.setSpeed(speed);
    }});
    this.schedule();
  }
}
