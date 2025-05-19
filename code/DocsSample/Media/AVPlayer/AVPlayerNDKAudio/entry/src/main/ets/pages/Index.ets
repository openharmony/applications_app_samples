/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import display from '@ohos.display';
import { common } from '@kit.AbilityKit';
import media from '@ohos.multimedia.media';
import avPlayerNDK from 'libentry.so';

const SURFACE_W = 0.9; // 表面宽比例
const SURFACE_H = 1.78; // 表面高比例
const SET_INTERVAL = 300; // interval间隔时间
const TIME_ONE = 60000;
const TIME_TWO = 1000;
const SPEED_COUNT = 4;

@Entry
@Component
struct Index {
  tag: string = 'AVPlayManager';
  private context: common.UIAbilityContext | undefined = undefined;

  @State title: Resource = $r('app.string.EntryAbility_label');
  @State fileName: string = 'test_01.mp3';
  @State isPaused: boolean = true; // 暂停播放
  @State speedSelect: number = 0; // 倍速选择
  @State speedList: Resource[] = [$r('app.string.video_speed_1_0X'), $r('app.string.video_speed_1_25X'), $r('app.string.video_speed_1_75X'), $r('app.string.video_speed_2_0X')];
  @StorageLink('durationTime') durationTime: number = 0; // 视频总时长
  @StorageLink('currentTime') currentTime: number = 0; // 视频当前时间
  @StorageLink('speedName') speedName: Resource = $r('app.string.video_speed_1_0X');
  @StorageLink('speedIndex') speedIndex: number = 0; // 倍速索引
  @State surfaceW: number | null = null;
  @State surfaceH: number | null = null;
  @State percent: number = 0;
  @State windowWidth: number = 300;
  @State windowHeight: number = 200;

  updateTimer(): void {
    setInterval(() => { // 更新当前时间
      if (this.isPaused) {
        let duration = avPlayerNDK.getDuration()
        let currentTime = avPlayerNDK.getCurrentTime()
        if (duration > 0) {
          this.durationTime = duration
        }
        if (currentTime > 0) {
          this.currentTime = currentTime
        }
        if(currentTime == duration) {
          this.isPaused = false;
        }
        console.log(`${this.tag}: getDuration ${this.durationTime}`)
        console.log(`${this.tag}: getPlaybackSpeed enum ${avPlayerNDK.getSpeed()}`)
        console.log(`${this.tag}: IsPlaying  ${!this.isPaused}`)
      }
    }, SET_INTERVAL);
  }

  getDurationTime(): number {
    return this.durationTime;
  }

  getCurrentTime(): number {
    return this.currentTime;
  }

  timeConvert(time: number): string {
    let min: number = Math.floor(time / TIME_ONE);
    let second: string = ((time % TIME_ONE) / TIME_TWO).toFixed(0);
    // return `${min}:${(+second < TIME_THREE ? '0' : '') + second}`;
    second = second.padStart(2, '0');
    return `${min}:${second}`;
  }

  aboutToAppear() {
    this.windowWidth = display.getDefaultDisplaySync().width;
    this.windowHeight = display.getDefaultDisplaySync().height;
    this.surfaceW = this.windowWidth * SURFACE_W;
    this.surfaceH = this.surfaceW / SURFACE_H;
    this.isPaused = true;
    this.context = getContext(this) as common.UIAbilityContext;
  }

  aboutToDisappear() {
    avPlayerNDK.release();
  }

  onPageHide() {
    avPlayerNDK.pause();
    this.isPaused = false;
  }

  onPageShow() {
  }

  async avSetup() {
    if (this.context == undefined) return;
    let fileDescriptor = await this.context.resourceManager.getRawFd(this.fileName);
    avPlayerNDK.setup('sss', fileDescriptor.fd, fileDescriptor.offset, fileDescriptor.length);
    this.updateTimer();
  }

  build() {
    Column() {
      Stack() {
        Column() {
          XComponent({
            // 装载视频容器
            id: 'componentVideo',
            type: XComponentType.SURFACE,
            libraryname: "entry",
          })
            .id('VideoView')
            .onLoad(() => {
              if(this.context) {
                this.avSetup();
              }
            })
            .height(`${this.surfaceH}px`)
            .width(`${this.surfaceW}px`)
        }
        .align(Alignment.TopStart)
        .margin({ top: 80 })
        .id('VideoView')
        .justifyContent(FlexAlign.Center)

        Column() {
          Blank()
          Column() {
            // 进度条
            Row() {
              Row() {
                // 播放、暂停键
                Image(this.isPaused ? $r("app.media.ic_video_play") : $r("app.media.ic_video_pause")) // 暂停/播放
                  .id(this.isPaused ? 'pause' : 'play')
                  .width($r('app.float.size_40'))
                  .height($r('app.float.size_40'))
                  .onClick(() => {
                    if (this.isPaused) {
                      avPlayerNDK.pause();
                      this.isPaused = false;
                    } else {
                      avPlayerNDK.play();
                      this.isPaused = true;
                    }
                  })

                // 左侧时间
                Text(this.timeConvert(this.currentTime))
                  .id("currentTimeText")
                  .fontColor(Color.White)
                  .textAlign(TextAlign.End)
                  .fontWeight(FontWeight.Regular)
                  .margin({ left: $r('app.float.size_10') })
              }

              // 进度条
              Row() {
                Slider({
                  value: this.currentTime,
                  min: 0,
                  max: this.durationTime,
                  style: SliderStyle.OutSet
                })
                  .id('Slider')
                  .blockColor(Color.White)
                  .trackColor(Color.Gray)
                  .selectedColor($r("app.color.slider_selected"))
                  .showTips(false)
                  .onChange((value: number, mode: SliderChangeMode) => {
                    if (this.currentTime !== value) {
                      this.currentTime = value;
                      avPlayerNDK.seek(Number.parseInt(value.toFixed(0)), 2);
                    }
                  })
              }
              .layoutWeight(1)

              Row() {
                // 右侧时间
                Text(this.timeConvert(this.durationTime))
                  .id("durationTimeText")
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Regular)

                // 倍速按钮
                Button(this.speedName, { type: ButtonType.Normal })
                  .border({ width: $r('app.float.size_1'), color: Color.White })
                  .width(75)
                  .height($r('app.float.size_40'))
                  .fontSize($r('app.float.size_15'))
                  .borderRadius($r('app.float.size_24'))
                  .fontColor(Color.White)
                  .backgroundColor(Color.Black)
                  .opacity($r('app.float.size_1'))
                  .margin({ left: $r('app.float.size_10') })
                  .id('Speed')
                  .onClick(() => {
                    this.speedIndex = (this.speedIndex + 1) % SPEED_COUNT;
                    this.speedSelect = this.speedIndex;
                    this.speedName = this.speedList[this.speedIndex];
                    switch (this.speedSelect) {
                      case 0:
                        avPlayerNDK.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
                        break;
                      case 1:
                        avPlayerNDK.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
                        break;
                      case 2:
                        avPlayerNDK.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
                        break;
                      case 3:
                        avPlayerNDK.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
                        break;
                    }
                  })
              }
            }
            .justifyContent(FlexAlign.Center)
            .padding({ left: $r('app.float.size_25'), right: $r('app.float.size_30') })
            .width('100%')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
      .backgroundColor(Color.Black)
      .height('90%')
      .width('100%')

      Row() {
        Text(this.title)
          .fontSize($r('app.float.size_20'))
          .fontColor(Color.White)
          .opacity($r('app.float.size_zero_six'))
          .fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Center)
      }
    }.backgroundColor(Color.Black)
    .height('100%')
    .width('100%')
  }
}
