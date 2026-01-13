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

import { camera } from '@kit.CameraKit';
import { AVRecorderState, CameraManager, PhotoManager, PreviewManager, VideoManager } from 'camera';
import { showToast } from '../utils/CommonUtil';
import PreviewViewModel from '../viewmodels/PreviewViewModel';

interface FlashItem {
  mode: camera.FlashMode;
  image: Resource;
  title: ResourceStr;
  toast: ResourceStr;
}

@Component
struct SettingButtonsView {
  private flashItems: FlashItem[] = [
    {
      mode: camera.FlashMode.FLASH_MODE_CLOSE,
      image: $r('sys.symbol.camera_flash_slash'),
      title: 'off',
      toast: $r('app.string.flash_close')
    },
    {
      mode: camera.FlashMode.FLASH_MODE_OPEN,
      image: $r('sys.symbol.camera_flash'),
      title: 'on',
      toast: $r('app.string.flash_open')
    },
    {
      mode: camera.FlashMode.FLASH_MODE_AUTO,
      image: $r('sys.symbol.camera_flash_auto'),
      title: 'auto',
      toast: $r('app.string.flash_auto')
    },
    {
      mode: camera.FlashMode.FLASH_MODE_ALWAYS_OPEN,
      image: $r('sys.symbol.lightbulb_1'),
      title: 'always_on',
      toast: $r('app.string.flash_always')
    }
  ];
  private photoFlashModes: camera.FlashMode[] = [
    camera.FlashMode.FLASH_MODE_CLOSE,
    camera.FlashMode.FLASH_MODE_OPEN,
    camera.FlashMode.FLASH_MODE_AUTO,
    camera.FlashMode.FLASH_MODE_ALWAYS_OPEN
  ];
  private videoFlashModes: camera.FlashMode[] = [
    camera.FlashMode.FLASH_MODE_CLOSE,
    camera.FlashMode.FLASH_MODE_ALWAYS_OPEN
  ];
  @State flashMode: camera.FlashMode = camera.FlashMode.FLASH_MODE_CLOSE;
  @Link isLivePhoto: boolean;
  @Require cameraManager: CameraManager;
  @Require previewManager: PreviewManager;
  @Require photoManager: PhotoManager;
  @Link videoManager: VideoManager;
  @Link photoDelayTime: number;
  @State isStabilizationEnabled: boolean = false;
  @Link isSinglePhoto: boolean;
  @Link isHdr: boolean;
  @Link previewVM: PreviewViewModel;

  getFlashItem(mode: camera.FlashMode) {
    return this.flashItems.find(item => item.mode === mode);
  }

  @Builder
  flashButton(flashModes: camera.FlashMode[]) {
    SymbolGlyph(this.getFlashItem(this.flashMode)?.image)
      .fontSize(22)
      .fontColor([Color.White])
      .bindMenu(flashModes.map(mode => {
        const flashItem = this.getFlashItem(mode)!;
        const menuElement: MenuElement = {
          value: flashItem.title,
          action: () => {
            this.flashMode = mode!;
            this.cameraManager.setFlashMode(mode);
            showToast(this.getUIContext(), flashItem.toast);
          }
        };
        return menuElement;
      }))
  }

  @Builder
  videoTimerBuilder() {
    if (this.videoManager.isRecording()) {
      Row({ space: 5 }) {
        SymbolGlyph(this.videoManager.state === AVRecorderState.STARTED ? $r('sys.symbol.record_circle') :
        $r('sys.symbol.pause'))
          .fontSize(22)
          .fontColor(this.videoManager.state === AVRecorderState.STARTED ? [Color.Red, 'rgba(255,0,0,0)'] :
            [Color.White])
          .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
        Text(this.videoManager.state === AVRecorderState.STARTED ? $r('app.string.recording') : $r('app.string.paused'))
          .fontColor(Color.White)
          .fontSize(12)
      }
    }
  }

  @Builder
  livePhotoButton() {
    SymbolGlyph(this.isLivePhoto
      ? $r('sys.symbol.livephoto')
      : $r('sys.symbol.livephoto_slash'))
      .onClick(() => {
        this.isLivePhoto = !this.isLivePhoto;
        this.photoManager.enableMovingPhoto(this.isLivePhoto);
        const message = this.isLivePhoto ? $r('app.string.moving_open') : $r('app.string.moving_close');
        showToast(this.getUIContext(), message);
      })
      .fontSize(22)
      .fontColor([Color.White])
  }

  @Builder
  rateButton() {
    if (this.previewVM.rates) {
      Text(`${this.previewVM.currentRate} fps`)
        .fontColor(Color.White)
        .fontSize(16)
        .bindMenu(this.previewVM.rates.map(rate => {
          const menuElement: MenuElement = {
            value: rate + 'fps',
            action: () => {
              this.previewManager.setFrameRate(rate, rate);
              this.previewVM.currentRate = rate;
              showToast(this.getUIContext(), $r('app.string.preview_rate', rate + 'fps'));
            }
          };
          return menuElement;
        }))
    }
  }

  @Builder
  delayPhotoButton(photoDelayTimeElements: MenuElement[]) {
    if (this.photoDelayTime) {
      Text(`${this.photoDelayTime}s`)
        .fontColor(Color.White)
        .fontSize(16)
        .bindMenu(photoDelayTimeElements)
    } else {
      SymbolGlyph($r('sys.symbol.time_lapse'))
        .fontSize(22)
        .fontColor([Color.White])
        .bindMenu(photoDelayTimeElements)
    }
  }

  getPhotoDelayTimeElements(): MenuElement[] {
    const menuTextMap: Map<string, number> = new Map([
      ['off', 0],
      ['2s', 2],
      ['5s', 5],
      ['10s', 10]
    ])
    return Array.from(menuTextMap.keys()).map(text => {
      const time = menuTextMap.get(text);
      const menuElement: MenuElement = {
        value: text,
        action: () => {
          this.photoDelayTime = time!;
          const message = time ? $r('app.string.delay', text) : $r('app.string.delay_close');
          showToast(this.getUIContext(), message);
        }
      };
      return menuElement;
    });
  }

  @Builder
  stabilizationButton() {
    SymbolGlyph(this.isStabilizationEnabled
      ? $r('sys.symbol.motion_stabilization')
      : $r('sys.symbol.motion_stabilization_slash'))
      .onClick(() => {
        this.isStabilizationEnabled = !this.isStabilizationEnabled;
        this.cameraManager.setVideoStabilizationMode(camera.VideoStabilizationMode.AUTO);
        const message = this.isStabilizationEnabled ? $r('app.string.stabilization_enable') : $r('app.string.stabilization_disabled');
      })
      .fontSize(22)
      .fontColor([Color.White])
  }

  @Builder
  togglePhotoModeButton() {
    SymbolGlyph(this.isSinglePhoto
      ? $r('sys.symbol.picture')
      : $r('sys.symbol.picture_on_square_1'))
      .onClick(() => {
        this.isSinglePhoto = !this.isSinglePhoto;
        this.photoManager.setPhotoOutputCallback(this.isSinglePhoto);
        if (this.isSinglePhoto) {
          this.isLivePhoto = false;
        } else {
          this.cameraManager.restartCamera();
        }
        this.photoManager.enableMovingPhoto(this.isLivePhoto);
        const message = this.isSinglePhoto ? $r('app.string.photo_single') : $r('app.string.photo_double');
        showToast(this.getUIContext(), message);
      })
      .fontSize(22)
      .fontColor([Color.White])
  }

  @Builder
  toggleHDRButton() {
    SymbolGlyph(this.isHdr
      ? $r('sys.symbol.hdr')
      : $r('sys.symbol.hdr'))
      .onClick(async () => {
        this.isHdr = !this.isHdr;
        this.cameraManager.setHdr(this.isHdr);
        const message = this.isHdr ? $r('app.string.photo_hdr_open') : $r('app.string.photo_hdr_close');
        showToast(this.getUIContext(), message);
      })
      .fontSize(22)
      .fontColor([Color.White])
  }

  build() {
    Row() {
      if (this.previewVM.isPhotoMode()) {
        this.flashButton(this.photoFlashModes)
        this.delayPhotoButton(this.getPhotoDelayTimeElements())
        this.toggleHDRButton()
        if (!this.isSinglePhoto) {
          this.livePhotoButton()
        }
        this.togglePhotoModeButton()
      } else {
        if (this.videoManager.isRecording()) {
          this.videoTimerBuilder()
        } else {
          this.rateButton()
          this.flashButton(this.videoFlashModes)
          this.stabilizationButton()
        }
      }
    }
    .id('settingButtonsView')
    .width('100%')
    .margin({ top: 50 })
    .justifyContent(FlexAlign.SpaceAround)
    .alignRules({ top: { anchor: '__container__', align: VerticalAlign.Top } })
  }
}

export default SettingButtonsView;