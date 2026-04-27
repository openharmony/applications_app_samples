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

import { timeConvert } from '../utils/TimeUtils';
import DlnaServiceStub from '../DlnaService/DlnaServiceStub'
import dmrnapi from '@ohos.dmrnapi'
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'VideoOperate '

@Preview
@Component
export struct VideoOperate {
  @Link currentTime: number;
  @Link durationTime: number;
  @Link DlnaServiceStub: DlnaServiceStub;
  @Link flag: boolean;
  private timeSecond: number = 15000
  @Link @Watch('showVolumePop')videoVolume: number;
  @Link @Watch('hidePop') isScreenClick: boolean;
  @State isVolumePopup: boolean = false;
  @State noVideo: boolean = false;
  @State @Watch('isHide') isTouch: boolean = false;
  private interval: number = 0
  private intervalForward: number = 0
  private intervalBackWord: number = 0
  aboutToAppear() {
    this.getVideoVolume();
    this.interval = setInterval(() => {
      if (this.isScreenClick) {
        this.isScreenClick = false
        console.log('isHide setInterval!!!')
      }
    }, 1000 * 3)
  }

  aboutToDisappear() {
    clearInterval(this.interval)
  }

  setVideoVolume() {
    // 设置声音
    dmrnapi.SetVolume(this.videoVolume);
    console.log(TAG + 'SetVolume:' + JSON.stringify(this.videoVolume));
    if (this.videoVolume === 0) {
      this.noVideo = true
    } else {
      this.noVideo = false
    }
  }

  showVolumePop() {
    this.isScreenClick = true;
    this.isVolumePopup = true;
    this.isTouch != this.isTouch;
  }

  getVideoVolume() {
    // 声音数值获取
    let getVolume: number[] = dmrnapi.getVolume();
    console.log(TAG + 'getVolume:' + JSON.stringify(getVolume));
    let getVideoVolume = getVolume[0]
    this.videoVolume = getVideoVolume
    console.log(TAG + 'videoVolume:' + JSON.stringify(this.videoVolume));
    if (this.videoVolume === 0) {
      this.noVideo = true
    } else {
      this.noVideo = false
    }
  }

  setVideoStatus() {
    //设置播放/暂停
    if (this.flag) {
      dmrnapi.Pause();
      this.flag = false;
    } else {
      dmrnapi.Play();
      this.flag = true;
    }
  }

  hidePop() {
    if (this.isScreenClick === false) {
      this.isVolumePopup = false
    }
  }

  isHide() {
    clearTimeout(this.interval)
    console.log('isHide setInterval!!!')
    this.interval = setTimeout(() => {
      if (this.isScreenClick) {
        this.isScreenClick = false;
      }
      if(this.isVolumePopup) {
        this.isVolumePopup = false;
      }
    }, 1000 * 3)
  }

  @Builder
  popupBuilder() {
    Row() {
      Slider({
        value: this.videoVolume,
        min: 0,
        max: 100,
        step: 1,
        style: SliderStyle.OutSet,
        reverse: true,
        direction: Axis.Vertical,
      })
        .trackColor(Color.White)
        .showTips(true, JSON.stringify(this.videoVolume))
        .onChange((value: number, mode: SliderChangeMode) => {
          this.videoVolume = Math.floor(value)
          this.setVideoVolume()
          console.info(TAG + 'value:' + value + 'mode:' + mode.toString())
        })
    }.width($r('app.float.size_100'))
    .height($r('app.float.size_200'))
    .justifyContent(FlexAlign.End)
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.double_left'))//后退
          .width($r('app.float.size_40'))
          .height($r('app.float.size_40'))
          .margin({ right: $r('app.float.distance_5') })
          .onClick(() => {
            clearTimeout(this.intervalBackWord);
            dmrnapi.Pause();
            this.currentTime = this.currentTime - 15000;
            dmrnapi.Seek(this.currentTime);
            console.info(TAG + 'GetPosition 1:'+this.currentTime);
            this.intervalBackWord = setTimeout(() => {
              console.info(TAG + 'setTimeout :'+this.currentTime);
              dmrnapi.Play();
            }, 1000 * 2)
            this.isTouch = !this.isTouch
          })
        Image(this.flag ? $r('app.media.ic_video_play') : $r('app.media.ic_video_pause'))// 暂停/播放
          .id('play')
          .width($r('app.float.size_40'))
          .height($r('app.float.size_40'))
          .onClick(() => {
            this.setVideoStatus();
          })
        Image($r('app.media.double_right'))// 快进
          .width($r('app.float.size_40'))
          .height($r('app.float.size_40'))
          .margin({ left: $r('app.float.distance_5') })
          .onClick(() => {

            clearTimeout(this.intervalForward);
            dmrnapi.Pause();
            this.currentTime = this.currentTime + 15000;
            dmrnapi.Seek(this.currentTime);

            console.info(TAG + 'GetPosition Forward:'+this.currentTime);
            this.intervalForward = setTimeout(() => {
              console.info(TAG + 'setTimeout :'+this.currentTime);
              dmrnapi.Play();
            }, 1000 * 2)
            this.isTouch = !this.isTouch
          })

        // 左侧时间
        Text(timeConvert(this.currentTime))
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Regular)
          .margin({ left: $r('app.float.size_10') })
      }

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
          .selectedColor($r('app.color.slider_selected'))
          .showTips(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            if (mode == SliderChangeMode.Begin) {
              dmrnapi.Pause();
              this.flag = false;
            }
            dmrnapi.Seek(value)
            if (mode == SliderChangeMode.End) {
              dmrnapi.Play();
              this.flag = true;
            }
            this.isTouch = !this.isTouch
          })
      }
      .layoutWeight(1)

      Row() {
        // 右侧时间
        Text(timeConvert(this.durationTime))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Regular)
          .margin({ right: $r('app.float.distance_5') })

        Image(this.noVideo ? $r('app.media.speaker_slash') : $r('app.media.speaker'))//音量
          .width($r('app.float.size_40'))
          .height($r('app.float.size_40'))
          .margin({ left: $r('app.float.distance_5') })
          .onClick(() => {
            this.isVolumePopup = !this.isVolumePopup
            this.isTouch = !this.isTouch
          })
          .bindPopup(this.isVolumePopup, {
            builder: this.popupBuilder,
            placement: Placement.Top,
            mask: { color: '#33000000' },
            popupColor: Color.Transparent,
            enableArrow: false,
            showInSubWindow: false,
            offset: { x: -30, y: 0 },
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.isVolumePopup = false
              }
            }
          })
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: $r('app.float.size_25'), right: $r('app.float.size_25') })
    .width('100%')
  }
}
