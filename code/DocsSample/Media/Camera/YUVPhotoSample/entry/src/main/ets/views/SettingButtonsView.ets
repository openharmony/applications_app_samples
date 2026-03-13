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
import { CameraManager, PhotoManager } from 'camera';
import { showToast } from '../utils/CommonUtil';

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
  @State flashMode: camera.FlashMode = camera.FlashMode.FLASH_MODE_CLOSE;
  @Require cameraManager: CameraManager;
  @Require photoManager: PhotoManager;
  @Link isSinglePhoto: boolean;

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
  togglePhotoModeButton() {
    SymbolGlyph(this.isSinglePhoto
      ? $r('sys.symbol.picture')
      : $r('sys.symbol.picture_on_square_1'))
      .onClick(() => {
        this.isSinglePhoto = !this.isSinglePhoto;
        this.photoManager.setPhotoOutputCallback(this.isSinglePhoto);
        const message = this.isSinglePhoto ? $r('app.string.photo_single') : $r('app.string.photo_double');
        showToast(this.getUIContext(), message);
      })
      .fontSize(22)
      .fontColor([Color.White])
  }

  build() {
    Row() {
      this.flashButton(this.photoFlashModes)
      this.togglePhotoModeButton()
    }
    .id('settingButtonsView')
    .width('100%')
    .margin({ top: 50 })
    .justifyContent(FlexAlign.SpaceAround)
    .alignRules({ top: { anchor: '__container__', align: VerticalAlign.Top } })
  }
}

export default SettingButtonsView;