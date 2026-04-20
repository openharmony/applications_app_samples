/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import Logger from '../common/utils/Logger';
import CameraService from '../mode/CameraService';

const TAG: string = 'FlashingLightComponent';

interface FlashItem {
  mode: camera.FlashMode;
  image: Resource;
  title: ResourceStr;
  toast: ResourceStr;
}
// 闪关灯页面
@Component
export struct FlashingLightComponent {

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

  // 闪光灯模式
  @Link @Watch('flashModeChange') flashMode: camera.FlashMode;
  @State flashIconResource: Resource = $r('app.media.ic_camera_public_flash_off');

  @Link isMovingPhotoEnable: boolean;
  @State isMacroEnable: boolean = false;

  // Page judgment
  @State showOptions: boolean = false;
  @State firstBol: boolean = true;


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
            CameraService.hasFlashFn(mode);
            // showToast(this.getUIContext(), flashItem.toast);
          }
        };
        return menuElement;
      }))
  }

  @Builder
  livePhotoButton() {
    SymbolGlyph(this.isMovingPhotoEnable
      ? $r('sys.symbol.livephoto')
      : $r('sys.symbol.livephoto_slash'))
      .onClick(() => {
        this.isMovingPhotoEnable = !this.isMovingPhotoEnable;
        CameraService.enableMovingPhoto(this.isMovingPhotoEnable);
        // const message = this.isMovingPhotoEnable ? $('动态照片开启') : $('动态照片关闭');
        // showToast(this.getUIContext(), message);
      })
      .fontSize(22)
      .fontColor([Color.White])
  }

  flashModeChange(): void {
    switch (this.flashMode) {
      case camera.FlashMode.FLASH_MODE_OPEN:
        this.flashIconResource = $r('app.media.ic_camera_public_flash_on');
        break;
      case camera.FlashMode.FLASH_MODE_AUTO:
        this.flashIconResource = $r('app.media.ic_camera_public_flash_auto');
        break;
      case camera.FlashMode.FLASH_MODE_ALWAYS_OPEN:
        this.flashIconResource = $r('app.media.flash_always_on');
        break;
      case camera.FlashMode.FLASH_MODE_CLOSE:
      default:
        this.flashIconResource = $r('app.media.ic_camera_public_flash_off');
    }
  }

  build() {
    Row() {
      if (CameraService.getSceneMode() == camera.SceneMode.NORMAL_PHOTO) {
        this.flashButton(this.photoFlashModes);
        this.livePhotoButton();
      } else if (CameraService.getSceneMode() == camera.SceneMode.NORMAL_VIDEO) {
        this.flashButton(this.videoFlashModes);
      }

    }
    .id('flashingLightComponent')
    .width('100%')
    .margin({ top: 10 })
    .justifyContent(FlexAlign.SpaceAround)
    .alignRules({ top: { anchor: '__container__', align: VerticalAlign.Top } })
  }
}
