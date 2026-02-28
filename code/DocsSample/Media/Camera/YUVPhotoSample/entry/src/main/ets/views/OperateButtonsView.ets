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

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { CameraManager, PhotoManager } from 'camera';
import PreviewViewModel from '../viewmodels/PreviewViewModel';

@Component
struct OperateButtonsView {
  @Link previewVM: PreviewViewModel;
  @Require cameraManager: CameraManager;
  @Require photoManager: PhotoManager;
  @State thumbnail: image.PixelMap | string = '';
  @State thumbnailUrl: string = '';
  @Require syncButtonSettings: () => void;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private setThumbnail: (pixelMap: image.PixelMap, url: string) => void = (pixelMap: image.PixelMap, url: string) => {
    this.thumbnail = pixelMap;
    this.thumbnailUrl = url;
  }
  @StorageLink('captureClick') captureClickFlag: number = 0;

  aboutToAppear(): void {
    this.photoManager.setCallback(this.setThumbnail);
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
    .id('TakePicture')
    .width(64)
    .height(64)
    .borderRadius('50%')
    .border({
      color: Color.White,
      width: 1
    })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
        this.photoManager.capture(this.previewVM.isFront);
        this.captureClickFlag++;
    })
  }

  @Builder
  thumbnailButton() {
    Image(this.thumbnail || $r('app.media.camera_thumbnail_4x'))
      .id('Album')
      .width(48)
      .height(48)
      .borderRadius('50%')
      .borderWidth(this.thumbnail ? 1 : 0)
      .borderColor(Color.White)
      .clip(true)
      .onClick(()=>{
        this.context.startAbility({
          bundleName: 'com.huawei.hmos.photos',
          abilityName: 'com.huawei.hmos.photos.MainAbility'
        })
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
        await this.cameraManager.start(this.previewVM.surfaceId, cameraPosition, sceneMode,
          this.previewVM.getPreviewRatio());
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
      }
        this.toggleCameraPositionButton()
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