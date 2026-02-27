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
import { second2Time } from '../common/utils/TimeConvert';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { SpeedChoose } from './CommonView';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'AVPlayerControllerView'

@Component
export struct VolumeControllerView {
  @Prop volumeValue: number = 0;

  build() {
    Column() {
      RelativeContainer() {
        Progress({ value: this.volumeValue * 100, total: 100, type: ProgressType.Ring })
          .width(47)
          .height(47)
          .style({ strokeWidth: 3 })
          .color('rgb(10,89,247)')
        SymbolGlyph($r('sys.symbol.speaker_wave_3'))
          .fontSize(24)
          .width(24)
          .height(24)
          .fontColor([Color.White])
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Center },
            left: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .offset({
            x: -12,
            y: -12
          })
      }
      .width(47)
      .height(47)
      .margin({
        bottom: 4
      })

      Text($r('app.string.volume'))
        .fontSize(14)
        .fontColor(Color.White)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width(104)
    .backgroundColor('rgba(0,0,0,0.6)')
    .height(104)
    .borderRadius(8)
  }
}

@Component
export struct AVPlayerControllerView {
  @State @Watch('isSpeedSheetShowChange') isSpeedSheetShow: boolean = false;
  @State @Watch('speedChooseChange') speedChoosen: string = '1.0X';
  @StorageLink('avPlayerController') avPlayerController?: VideoPlayerController = undefined;
  @Link currentTime: number;
  @Link durationTime: number;
  @Link isPlaying: boolean;
  @Link isShowAVPlayerController: boolean;
  @Link avPlayerControllerTimeID: number;

  @Builder
  speedChooseBuilder() {
    SpeedChoose({ speedChoosen: this.speedChoosen, isSpeedSheetShow: this.isSpeedSheetShow })
  }

  isSpeedSheetShowChange() {
    if (!this.isSpeedSheetShow) {
      this.showAVPlayerController();
    }
  }

  showAVPlayerController() {
    this.isShowAVPlayerController = true;
    clearTimeout(this.avPlayerControllerTimeID);
    this.avPlayerControllerTimeID = setTimeout(() => {
      this.isShowAVPlayerController = false;
    }, 2000)
  }

  speedChooseChange() {
    if(!this.avPlayerController){
      return;
    }
    try {
      switch (this.speedChoosen) {
        case '2.0X':
          this.avPlayerController.setAVPlayerSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
          break;
        case '1.5X':
          this.avPlayerController.setAVPlayerSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_50_X);
          break;
        case '1.0X':
          this.avPlayerController.setAVPlayerSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
          break;
        case '1.25X':
          this.avPlayerController.setAVPlayerSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
          break;
        case '0.5X':
          this.avPlayerController.setAVPlayerSpeed(media.PlaybackSpeed.SPEED_FORWARD_0_50_X);
          break;
        default:
          break
      }
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'change speed failed, cause: %{public}s', JSON.stringify(err));
      }
    }

  }

  async slideOnChange(value: number, mode: SliderChangeMode) {
    if(!this.avPlayerController){
      return;
    }
    switch (mode) {
      case SliderChangeMode.Begin:
        this.avPlayerController.setAVPlayerPause();
        break;
      case SliderChangeMode.Moving:
        this.avPlayerController.setAVPlayerPause();
        break;
      case SliderChangeMode.Click:
        await this.avPlayerController.avPlayerSeek(value, media.SeekMode.SEEK_CLOSEST).catch((err: BusinessError)=>{
          if (err.code) {
            hilog.error(0x0000, TAG, 'testTag', 'avPlayer seek failed, cause: %{public}s', JSON.stringify(err));
          }
        });
        await this.avPlayerController.setAVPlayerPlaying();
        this.showAVPlayerController();
        break;
      case SliderChangeMode.End:
        await this.avPlayerController.avPlayerSeek(value, media.SeekMode.SEEK_CLOSEST).catch((err: BusinessError)=>{
          if (err.code) {
            hilog.error(0x0000, TAG, 'testTag', 'avPlayer seek failed, cause: %{public}s', JSON.stringify(err));
          }
        });
        this.avPlayerController.setAVPlayerPlaying();
        this.showAVPlayerController();
        break;
      default:
        break;
    }
  }

  build() {
    Row() {
      SymbolGlyph(this.isPlaying ? $r('sys.symbol.pause_fill') : $r('sys.symbol.play_fill'))
        .fontSize(24)
        .fontColor([Color.White])
        .width(24)
        .height(24)
        .margin({
          right: 8
        })
        .onClick(() => {
          if(!this.avPlayerController){
            return;
          }
          if (this.isPlaying ) {
            this.avPlayerController.setAVPlayerPause();
          } else {
            this.avPlayerController.setAVPlayerPlaying();
          }
          this.showAVPlayerController();
        })
      Text(second2Time(this.currentTime))
        .width(36)
        .fontSize(9)
        .fontColor(Color.White)
        .margin({
          right: 12
        })
      Slider({
        value: this.currentTime,
        step: 0.1,
        min: 0,
        max: this.durationTime,
      })
        .layoutWeight(1)
        .margin({
          right: 12
        })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.slideOnChange(value, mode);
        })
      Text(second2Time(this.durationTime))
        .width(36)
        .fontSize(9)
        .fontColor(Color.White)
        .margin({
          right: 12
        })
      Text($r('app.string.speed'))
        .fontSize(14)
        .fontColor(Color.White)
        .onClick(() => {
          this.isSpeedSheetShow = true;
          clearTimeout(this.avPlayerControllerTimeID);
          this.isShowAVPlayerController = true;
        })
        .bindSheet($$this.isSpeedSheetShow, this.speedChooseBuilder(), {
          height: SheetSize.FIT_CONTENT,
          title: { title: $r('app.string.speed') },
          backgroundColor: $r('sys.color.comp_background_primary')
        })
    }
  }
}