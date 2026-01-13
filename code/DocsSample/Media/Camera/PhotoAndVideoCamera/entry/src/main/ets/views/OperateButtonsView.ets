/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { AVRecorderState, CameraManager, PhotoManager, VideoManager } from 'camera';
import PreviewViewModel from '../viewmodels/PreviewViewModel';

@Component
struct OperateButtonsView {
  @Link isDelayTakePhoto: boolean;
  @Link previewVM: PreviewViewModel;
  @Require cameraManager: CameraManager;
  @Link videoManager: VideoManager; // Do not use @prop, otherwise deep copying, some underlying data will be lost.
  @Require photoManager: PhotoManager;
  @Prop @Require photoDelayTime: number;
  @Link photoRemainder: number;
  private photoDelayTimer:number = 0;
  @State thumbnail: image.PixelMap | string = '';
  @State thumbnailUrl: string = '';
  @Require syncButtonSettings: () => void;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private setThumbnail: (pixelMap: image.PixelMap, url: string) => void = (pixelMap: image.PixelMap, url: string) => {
    this.thumbnail = pixelMap
    this.thumbnailUrl = url
  }
  @StorageLink('captureClick') captureClickFlag: number = 0;

  aboutToAppear(): void {
    this.photoManager.setCallback(this.setThumbnail);
    this.videoManager.setVideoCallback(this.setThumbnail);
  }

  @Builder
  photoButton() {
    Column() {
      Column()
        .width(48)
        .height(48)
        .borderRadius('50%')
        .border({
          color: Color.White,
          width: 24
        })
    }
    .id('Capture')
    .width(64)
    .height(64)
    .borderRadius('50%')
    .border({
      color: Color.White,
      width: 1
    })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (this.photoDelayTime) {
        this.isDelayTakePhoto = true;
        this.photoRemainder = this.photoDelayTime;
        this.photoDelayTimer = setInterval(()=>{
          this.photoRemainder--;
          if(this.photoRemainder === 0){
            this.photoManager.capture(this.previewVM.isFront);
            this.captureClickFlag++;
            this.isDelayTakePhoto = false;
            clearTimeout(this.photoDelayTimer);
          }
        },1000)
      } else {
        this.photoManager.capture(this.previewVM.isFront);
        this.captureClickFlag++;
      }
    })
  }

  @Builder
  videoStartButton() {
    Column() {
      Column()
        .width(52)
        .height(52)
        .backgroundColor(Color.Red)
        .borderRadius('50%')
        .border({
          color: Color.White,
          width: 8
        })
    }
    .id('VideoStartButton')
    .width(64)
    .height(64)
    .borderRadius('50%')
    .border({
      color: Color.White,
      width: 1
    })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.videoManager.start(this.previewVM.isFront);
    })
  }

  @Builder
  videoStopButton() {
    Column() {
      Column()
        .width(28)
        .height(28)
        .borderRadius(10)
        .backgroundColor(Color.Red)
    }
    .id('VideoStopButton')
    .width(64)
    .height(64)
    .borderRadius('50%')
    .border({
      color: Color.White,
      width: 1
    })
    .justifyContent(FlexAlign.Center)
    .onClick(async () => {
      if (this.videoManager.state === AVRecorderState.STARTED || this.videoManager.state === AVRecorderState.PAUSED) {
        await this.videoManager.stop();
        await this.cameraManager.release();
        const cameraPosition = this.previewVM.getCameraPosition();
        const sceneMode = this.previewVM.getSceneMode();
        await this.cameraManager.start(this.previewVM.surfaceId,
          cameraPosition, sceneMode, this.previewVM.getPreviewRatio());
        this.syncButtonSettings();
      }
    })
  }

  @Builder
  videoPauseButton() {
    SymbolGlyph($r('sys.symbol.pause'))
      .fontColor([Color.White])
      .fontSize(22)
      .fontWeight(FontWeight.Bolder)
      .padding(11)
      .borderWidth(1)
      .borderColor(Color.White)
      .borderRadius('50%')
      .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
      .onClick(async () => {
        this.videoManager.pause();
      })
  }

  @Builder
  videoResumeButton() {
    SymbolGlyph($r('sys.symbol.play'))
      .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
      .fontColor([Color.White])
      .fontSize(22)
      .padding(11)
      .borderWidth(1)
      .borderColor(Color.White)
      .borderRadius('50%')
      .onClick(async () => {
        this.videoManager.resume();
      })
  }

  @Builder
  thumbnailButton() {
    Image(this.thumbnail)
      .id('Thumbnail')
      .width(48)
      .height(48)
      .borderRadius('50%')
      .borderWidth(this.thumbnail ? 1 : 0)
      .borderColor(Color.White)
      .clip(true)
      .onClick(()=>{
        if(this.thumbnailUrl){
          this.context.startAbility({
            parameters: { uri: this.thumbnailUrl },
            action: 'ohos.want.action.viewData',
            bundleName: 'com.huawei.hmos.photos',
            abilityName: 'com.huawei.hmos.photos.MainAbility'
          });
        }
      })
  }

  @Builder
  delayTakePhotoCancelButton() {
    SymbolGlyph($r('sys.symbol.pause'))
      .fontColor([Color.White])
      .fontSize(22)
      .fontWeight(FontWeight.Bolder)
      .padding(11)
      .borderWidth(1)
      .borderColor(Color.White)
      .borderRadius('50%')
      .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
      .onClick(async () => {
        this.isDelayTakePhoto = false;
        clearTimeout(this.photoDelayTimer);
        this.photoRemainder = 0;
      })
  }

  // [Start toggleCameraPositionButton]
  @Builder
  toggleCameraPositionButton() {
    Image($r('app.media.toggle_position'))
      .width(48)
      .height(48)
      .onClick(async () => {
        // [StartExclude toggleCameraPositionButton]
        this.previewVM.openPreviewBlur();
        this.previewVM.rotatePreviewBlur();
        // [EndExclude toggleCameraPositionButton]
        this.previewVM.isFront = !this.previewVM.isFront;
        const cameraPosition = this.previewVM.getCameraPosition();
        const sceneMode = this.previewVM.getSceneMode();
        await this.cameraManager.release();
        await this.cameraManager.start(this.previewVM.surfaceId,
          cameraPosition, sceneMode, this.previewVM.getPreviewRatio());
        // [StartExclude toggleCameraPositionButton]
        this.syncButtonSettings();
        // [EndExclude toggleCameraPositionButton]
      })
  }
  // [End toggleCameraPositionButton]

  build() {
    Row() {
      this.thumbnailButton()
      if (this.previewVM.isPhotoMode()) {
        this.photoButton()
      } else {
        if (this.videoManager.isRecording()) {
          this.videoStopButton()
        } else {
          this.videoStartButton()
        }
      }
      if (!this.videoManager.isRecording()) {
        this.toggleCameraPositionButton()
      }
      if (this.previewVM.isVideoMode() && this.videoManager.state === AVRecorderState.STARTED) {
        this.videoPauseButton()
      } else if (this.previewVM.isVideoMode() && this.videoManager.state === AVRecorderState.PAUSED) {
        this.videoResumeButton()
      }
    }
    .justifyContent(FlexAlign.SpaceAround)
    .id('operateButtonsView')
    .alignRules({
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
    })
    .margin({ bottom: 90 })
    .width('90%')
  }
}

export default OperateButtonsView;