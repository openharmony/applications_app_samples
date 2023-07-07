/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Caller from '../bean/Caller';
import OptionModel, { OptCallback } from '../model/OptionModel';
import BufferModel from '../model/BufferModel';
import AudioManagerModel from '../model/AudioManagerModel';
import Logger from '../utils/Logger';
import Constants from '../Constants';
import emitter from '@ohos.events.emitter';
import TimerUtil, { Observer } from '../utils/TimerUtil';
import common from '@ohos.app.ability.common';
import FloatWindowController from './FloatWindowController';
import SoundUtil from '../utils/SoundUtil';

const TAG = 'IndexController';

/**
 * Controller for ui
 */
export default class IndexController implements OptCallback {
  private observer: Observer;
  private ctx: common.UIAbilityContext;

  // -----------------初始化和销毁---------------------
  beforeInit(ctx: common.UIAbilityContext): boolean {
    Logger.info(`${TAG} beforeInit`);
    this.ctx = ctx;
    let event = OptionModel.readWant();
    if (event > 0) {
      emitter.emit({
        eventId: event
      });
    } else {
      ctx.terminateSelf();
      return false;
    }
    return true;
  }

  init(): void {
    Logger.info(`${TAG} init`);
    TimerUtil.startTimer();
    OptionModel.registerCallback(this);
    OptionModel.subscriber();
    BufferModel.init(() => {
      //流媒体服务断开了
      this.hangUp();
    });

    AudioManagerModel.initManager();
    this.exitVoiceCall();
    // 先打开声音和mic
    this.setSpeaker(false);
    this.setMicrophoneMute(false);
    this.playSound();
    this.observer = TimerUtil.registerObserver((count: number) => {
      this.timeoutCallback(count);
    });
  }

  timeoutCallback(count: number): void {
    Logger.info(`${TAG} timeoutCallback count : ${count}`);
    if (count > 30) {
      this.exit();
    }
  }

  // 主动退出
  exit(): void {
    Logger.info(`${TAG} exit`);
    this.clearSound();
    this.exitVoiceCall(); // 停止录音和播放，切换音频场景
    TimerUtil.stopTimer(); // 停掉计时器
    OptionModel.destroy();
    setTimeout(() => {
      BufferModel.destroy(); // 停止线程延迟200ms，给stop执行一些时间
      this.ctx.terminateSelf(); // 停止应用
    }, 400);
  }


  destroy(): void {
    this.exitVoiceCall(); // 停止录音和播放，切换音频场景
  }

  getCaller(): Caller {
    return OptionModel.getCaller();
  }

  answer(): void {
    Logger.info(`${TAG} answer`);
    OptionModel.answer();
    this.enterVoiceCall();
  }

  hangUp(): void {
    Logger.info(`${TAG} hangUp`);
    OptionModel.hangUp();
    this.exit();
  }

  //对端接听
  onRemoteAnswer(): void {
    Logger.info(`${TAG} onRemoteAnswer`);
    this.enterVoiceCall();
  }
  //对端挂断/拒接
  onRemoteHangUp(): void {
    Logger.info(`${TAG} onRemoteHangUp`);
    FloatWindowController.destroyFloatWindow();
    this.exit();
  }

  // 是否已静音
  async isMicrophoneMute(): Promise<boolean> {
    return await AudioManagerModel.isMicrophoneMute();
  }

  setMicrophoneMute(mute: boolean): void {
    AudioManagerModel.setMicrophoneMute(mute);
  }

  // 设置通话场景
  setVoiceScene(calling: boolean): void {
    AudioManagerModel.setVoiceScene(calling);
  }

  // 设置是否打开扬声器
  setSpeaker(speaker: boolean): void {
    AudioManagerModel.setSpeaker(speaker);
  }

  // 扬声器是否激活
  async isSpeakerActive(): Promise<boolean> {
    return await AudioManagerModel.isSpeakerActive();
  }

  async playSound(): Promise<void> {
    let fd = await this.ctx.resourceManager.getRawFd('wechat_voice_ring.mp3');
    SoundUtil.playFd(fd);
  }

  // 清除铃声
  clearSound(): void {
    SoundUtil.release();
  }


  // 开启录音，切换mic 录音成绩
  private enterVoiceCall(){
    Logger.info(`${TAG} enterVoiceCall`);
    try {
      TimerUtil.clearCount();
      TimerUtil.removeObserver(this.observer);

      this.clearSound();

      AudioManagerModel.setVoiceScene(true);
    } catch (err) {
      Logger.error(`${TAG}: enterVoiceCall failed, code is ${err.code}, message is ${err.message}`);
    } finally {
      Logger.info(`${TAG} enterVoiceCall emit ui`);
      emitter.emit({
        eventId: Constants.EVENT_UI_VOICE
      })
      BufferModel.startWorkTask();
    }
  }
  // 停止录音，切换声音模式
  private exitVoiceCall() {
    Logger.info(`${TAG} exitVoiceCall`);
    AudioManagerModel.setVoiceScene(false);
    BufferModel.stopWorkTask();
  }
}