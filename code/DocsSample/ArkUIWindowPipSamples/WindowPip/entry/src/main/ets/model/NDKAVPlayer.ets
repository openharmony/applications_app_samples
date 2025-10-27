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

// [Start ndk_implement_avplayer]
// model/AVPlayer.ets
// 视频播放器简单实现
import media from '@ohos.multimedia.media';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import resourceManager from '@ohos.resourceManager';
import { Logger } from '../util/LogUtil';

export class AVPlayer {
  public avPlayer?: media.AVPlayer;
  private count: number = 0;
  private surfaceID: string; // surfaceID用于播放画面显示，具体的值需要通过Xcomponent接口获取，相关文档链接见上面Xcomponent创建方法
  public jumpNext: boolean = false;
  public type: number = 0; // 用于区分主界面的player还是pip界面的player
  public state_: string = ''
  public playStatus: boolean = true;

  constructor(surfaceID: string, type: number) {
    this.surfaceID = surfaceID;
    this.type = type
  }

  setSurfaceId(id: string) {
    if (this.avPlayer) {
      this.surfaceID = id;
      this.avPlayer.surfaceId = id;
    }
  }

  updatePlayStatus(status: boolean) {
    this.playStatus = status;
  }
  // 注册avplayer回调函数
  setAVPlayerCallback() {
    // seek操作结果回调函数
    this.avPlayer?.on('seekDone', (seekDoneTime: number) => {
      Logger.info(`PipMain AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    })
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用reset接口触发重置流程
    this.avPlayer?.on('error', (err: BusinessError) => {
      Logger.error(`PipMain Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      this.avPlayer?.reset(); // 调用reset重置资源，触发idle状态
    })
    // 状态机变化回调函数
    this.avPlayer?.on('stateChange', async (state, reason) => {
      if (!this.avPlayer) {
        return;
      }
      this.state_ = state;
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          Logger.info('AVPlayer state idle called.');
          if (!this.jumpNext) {
            this.avPlayer.release(); // 调用release接口销毁实例对象
          } else {
            let uiContext: UIContext = AppStorage.get('UIAbilityContext') as UIContext;
            let context = uiContext.getHostContext() as common.UIAbilityContext;
            let fileDescriptor: resourceManager.RawFileDescriptor;
            fileDescriptor = await context.resourceManager.getRawFd('640x360.mp4');
            // 为fdSrc赋值触发initialized状态机上报
            this.avPlayer.fdSrc = fileDescriptor;
          }
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          Logger.info('initialized called.');
          this.avPlayer.surfaceId = this.surfaceID; // 设置显示画面，当播放的资源为纯音频时无需设置
          this.avPlayer.prepare().then(() => {
            Logger.info('AVPlayer prepare succeeded.');
          }, (err: BusinessError) => {
            Logger.error(`Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          Logger.info('AVPlayer state prepared called.');
          this.avPlayer.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          Logger.info('AVPlayer state playing called.');
          this.jumpNext = false;
          this.count++;
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          Logger.info('AVPlayer state paused called.');
          // this.avPlayer.play(); // 再次播放接口开始播放
          break;
        case 'completed': // 播放结束后触发该状态机上报
          Logger.info('AVPlayer state completed called.');
          this.playNext();
          ; //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          Logger.info('AVPlayer state stopped called.');
          this.avPlayer.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          Logger.info('AVPlayer state released called.');
          break;
        default:
          Logger.info('AVPlayer state unknown called.');
          break;
      }
    })
    this.avPlayer?.on('videoSizeChange', (width: number, height: number) => {
      Logger.info('videoSizeChange width:' + width + ' height:' + height);
      let context = AppStorage.get('UIAbilityContext') as common.UIAbilityContext;
    })
  }

  // 以下demo为使用资源管理接口获取打包在HAP内的媒体资源文件并通过fdSrc属性进行播放示例
  async avPlayerFdSrc() {
    // 创建avPlayer实例对象
    Logger.info('avPlayerFdSrc');
    this.avPlayer = await media.createAVPlayer();

    // 创建状态机变化回调函数
    this.setAVPlayerCallback();
    // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址
    // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度

    let context = AppStorage.get('UIAbilityContext') as common.UIAbilityContext;
    let fileDescriptor = await context.resourceManager.getRawFd('640x360.mp4');
    Logger.info('getRawFd');
    // 为fdSrc赋值触发initialized状态机上报
    this.avPlayer.fdSrc = fileDescriptor;
  }

  async playNext() {
    if (this.avPlayer === null) {
      return;
    }
    this.jumpNext = true;
    this.avPlayer?.stop();
  }

  play() {
    if (this.state_ === 'paused') {
      this.avPlayer?.play();
    }
  }

  pause() {
    if (this.state_ === 'playing') {
      this.avPlayer?.pause();
    }
  }

  stopAvPlayer() {
    Logger.info('stopAvPlayer>>>')
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.stop();
    Logger.info('stopping>>>');
    this.avPlayer.reset();
  }
}
// [End ndk_implement_avplayer]