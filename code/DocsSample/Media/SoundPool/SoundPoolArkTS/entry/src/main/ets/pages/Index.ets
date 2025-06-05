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
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private soundPool: media.SoundPool | undefined = undefined;
  private soundId: number = 0;
  private streamId: number = 0;

  async aboutToAppear(): Promise<void> {
    this.create();
  }

  async aboutToDisappear() {
    this.release();
  }

  build() {
    RelativeContainer() {
      Row() {
        Button($r('app.string.playSoundPool'))
          .width(100)
          .height(100)
          .onClick(() => {
            this.PlaySoundPool()
          })
          .id('playSoundPoolButton')
          .type(ButtonType.Circle)
      }.alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
  }

  async create() {
    try {
      // audioRenderInfo中的参数usage取值为STREAM_USAGE_UNKNOWN，STREAM_USAGE_MUSIC，STREAM_USAGE_MOVIE。
      // STREAM_USAGE_AUDIOBOOK时，SoundPool播放短音时为混音模式，不会打断其他音频播放。
      let audioRendererInfo: audio.AudioRendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型：音乐。根据业务场景配置，参考StreamUsage。
        rendererFlags: 1 // 音频渲染器标志。
      }
      //创建soundPool实例。
      this.soundPool = await media.createSoundPool(14,audioRendererInfo);
      //注册监听。
      this.loadCallback();
      this.finishPlayCallback();
      this.setErrorCallback();

      // 加载音频资源。
      let context = this.getUIContext().getHostContext();;
      let fileDescriptor = await context!.resourceManager.getRawFd('test.ogg');
      this.soundId = await this.soundPool!.load(fileDescriptor.fd, fileDescriptor.offset, fileDescriptor.length);
      console.info(`load soundPool soundId: ${this.soundId}`)
    } catch (e) {
      console.error('createSoundPool error: ' + e);
    }
  }

  async loadCallback() {
    // 加载完成回调。
    this.soundPool!.on('loadComplete', (soundId_: number) => {
      this.soundId = soundId_;
      console.info('loadComplete soundId: ' + soundId_);
    })
  }

  //设置播放完成监听。
  async finishPlayCallback() {
    this.soundPool!.on('playFinished', () => {
      console.info('receive play finished message');
      // 可进行下次播放。
    })
  }
  //设置错误类型监听。
  async setErrorCallback() {
    this.soundPool!.on('error', (error: BusinessError) => {
      console.error('error happened,message is :' + error.code);
      console.error('error happened,message is :' + error.message);
    })
  }

  async PlaySoundPool() {
    let playParameters: media.PlayParameters = {
      loop: 1, // 循环1次，即播放2次。
      rate: 1, // 1倍速播放。
      leftVolume: 0.5, // 取值范围0.0-1.0。
      rightVolume: 0.5, // 取值范围0.0-1.0。
      priority: 0, // 最低优先级。
    };
    // 开始播放，这边play也可带播放播放的参数PlayParameters，请在音频资源加载完毕，即收到loadComplete回调之后再执行play操作。
    this.soundPool!.play(this.soundId, playParameters, (error, streamID: number) => {
      if (error) {
        console.error(`play sound Error: errCode is ${error.code}, errMessage is ${error.message}`)
      } else {
        this.streamId = streamID;
        console.info('play success soundid:' + this.streamId);
      }
    });
    // 设置循环播放次数。
    await this.soundPool!.setLoop(this.streamId, 2); // 播放3次。
    // 设置对应流的优先级。
    await this.soundPool!.setPriority(this.streamId, 1);
    // 设置音量。
    await this.soundPool!.setVolume(this.streamId, 0.5, 0.5);
  }

  async release() {
    // 终止指定流的播放。
    await this.soundPool!.stop(this.streamId);
    // 卸载音频资源。
    await this.soundPool!.unload(this.soundId);
    //关闭监听。
    this.setOffCallback();
    // 释放SoundPool。
    await this.soundPool!.release();
  }



  async setOffCallback() {
    this.soundPool!.off('loadComplete');
    this.soundPool!.off('playFinished');
    this.soundPool!.off('error');
  }
}