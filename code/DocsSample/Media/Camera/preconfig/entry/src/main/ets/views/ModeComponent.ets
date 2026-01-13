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

import CameraService from '../model/CameraService';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Constants } from '../common/Constants';
import { router } from '@kit.ArkUI';
import { camera } from '@kit.CameraKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';

const TAG = 'ModeComponent';

@Component
export struct ModeComponent {
  @StorageLink('isOpenEditPage') @Watch('changePageState') isOpenEditPage: boolean = false;
  @State sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  @StorageLink('isRecording') isRecording: boolean = false;
  @Link screenshotPixel: image.PixelMap | undefined;
  @Link isShowModeSwitchImg: boolean;

  changePageState() {
    if (this.isOpenEditPage) {
      this.onJumpClick();
    }
  }

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
    if (!CameraService.is2in1()) {
      CameraService.setSavePictureCallback(this.handleSavePicture);
    } else {
      CameraService.setSaveSinglePhotoCallback(this.photoBufferCallback);
    }
  }

  photoBufferCallback = (arrayBuffer: ArrayBuffer): void => {
    Logger.info(TAG, `photoBufferCallback is called arrayBuffer.byteLength: ${arrayBuffer.byteLength}`);
    GlobalContext.get().setObject('photoArrayBuffer', arrayBuffer);
    AppStorage.set<boolean>('isOpenEditPage', true);
  }
  handleResetDisplay = () => {
    this.isShowModeSwitchImg = false;
  }
  handleSavePicture = (photoAsset: photoAccessHelper.PhotoAsset) => {
    Logger.info(TAG, 'handleSavePicture');
    this.setImageInfo(photoAsset);
    AppStorage.set<boolean>('isOpenEditPage', true);
    Logger.info(TAG, 'setImageInfo end');
  }

  setImageInfo(photoAsset: photoAccessHelper.PhotoAsset) {
    Logger.info(TAG, 'setImageInfo');
    GlobalContext.get().setObject('photoAsset', photoAsset);
  }

  onJumpClick(): void {
    GlobalContext.get().setObject('sceneMode', this.sceneMode);
    router.pushUrl({
      url: 'pages/EditPage'
    }, router.RouterMode.Single, (err) => {
      if (err) {
        Logger.error(TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Invoke pushUrl succeeded.');
    });
  }

  build() {
    Column() {
      Row({ space: Constants.COLUMN_SPACE_24 }) {
        Column() {
          Text($r('app.string.photo'))
            .fontSize(Constants.FONT_SIZE_14)
            .fontColor(Color.White)
        }
        .width(Constants.CAPTURE_COLUMN_WIDTH)
        .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_PHOTO ? $r('app.color.theme_color') : '')
        .borderRadius(Constants.BORDER_RADIUS_14)
        .onTouch(async (event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            Logger.info(TAG, `TouchType.Down`);
            this.screenshotPixel = CameraService.generateSnapshotImg();
            Logger.info(TAG, `TouchType.Down screenshotPixel: ${this.screenshotPixel === undefined}`);
          }
          if (event.type == TouchType.Up) {
            if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
              return;
            }
            this.sceneMode = camera.SceneMode.NORMAL_PHOTO;
            CameraService.setSceneMode(this.sceneMode);
            let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
            let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');
            this.isShowModeSwitchImg = true;
            let mConfigRatio = GlobalContext.get().getT<number>('configRatio');
            let preconfigType = GlobalContext.get().getT<camera.PreconfigType>('PreconfigType');
            await CameraService.initCamera(surfaceId, curCameraPosition, preconfigType, mConfigRatio);
          }
        })

        Column() {
          Text($r('app.string.video'))
            .fontSize(Constants.FONT_SIZE_14)
            .fontColor(Color.White)
        }
        .width(Constants.CAPTURE_COLUMN_WIDTH)
        .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_VIDEO ? $r('app.color.theme_color') : '')
        .borderRadius(Constants.BORDER_RADIUS_14)
        .onTouch(async (event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            this.screenshotPixel = CameraService.generateSnapshotImg();
          }
          if (event.type == TouchType.Up) {
            if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
              return;
            }
            this.sceneMode = camera.SceneMode.NORMAL_VIDEO;
            CameraService.setSceneMode(this.sceneMode);
            let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
            let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');
            this.isShowModeSwitchImg = true;
            let mConfigRatio = GlobalContext.get().getT<number>('configRatio');
            let preconfigType = GlobalContext.get().getT<camera.PreconfigType>('PreconfigType');
            await CameraService.initCamera(surfaceId, curCameraPosition, preconfigType, mConfigRatio);
          }
        })
      }
      .height(Constants.CAPTURE_ROW_HEIGHT)
      .width(Constants.FULL_PERCENT)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Row() {
        Column() {
        }
        .width($r('app.float.size_200'))

        // Camera/Video button
        Column() {
          if (!this.isRecording) {
            Row() {
              Button() {
                Text()
                  .width($r('app.float.size_120'))
                  .height($r('app.float.size_120'))
                  .borderRadius($r('app.float.size_40'))
                  .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_VIDEO ?
                  $r('app.color.theme_color') : Color.White)
              }
              .border({
                width: Constants.CAPTURE_BUTTON_BORDER_WIDTH,
                color: $r('app.color.border_color'),
                radius: Constants.CAPTURE_BUTTON_BORDER_RADIUS
              })
              .width($r('app.float.size_200'))
              .height($r('app.float.size_200'))
              .backgroundColor(Color.Black)
              .onClick(async () => {
                if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
                  await CameraService.takePicture();
                } else {
                  await CameraService.startVideo();
                  this.isRecording = true;
                }
              })
            }
          } else {
            Row() {
              // Recording stop button
              Button() {
                Image($r('app.media.ic_camera_video_close'))
                  .size({ width: Constants.IMAGE_SIZE, height: Constants.IMAGE_SIZE })
              }
              .width($r('app.float.size_120'))
              .height($r('app.float.size_120'))
              .backgroundColor($r('app.color.theme_color'))
              .onClick(() => {
                this.isRecording = !this.isRecording;
                CameraService.stopVideo().then(() => {
                  this.isOpenEditPage = true;
                  Logger.info(TAG, 'stopVideo success');
                })
              })
            }
            .width($r('app.float.size_200'))
            .height($r('app.float.size_200'))
            .borderRadius($r('app.float.size_60'))
            .backgroundColor($r('app.color.theme_color'))
            .justifyContent(FlexAlign.SpaceAround)
          }
        }.id('CaptureOrVideoButton')

        // Switching between the front and rear cameras
        Column() {
          Row() {
            Button() {
              Image($r('app.media.switch_camera'))
                .width($r('app.float.size_120'))
                .height($r('app.float.size_120'))
            }
            .width($r('app.float.size_200'))
            .height($r('app.float.size_200'))
            .backgroundColor('rgba(255,255,255,0.20)')
            .borderRadius($r('app.float.size_40'))
            .onTouch(async (event: TouchEvent) => {
              if (event.type == TouchType.Down) {
                Logger.info(TAG, `TouchType.Down`);
                this.screenshotPixel = CameraService.generateSnapshotImg();
                this.isShowModeSwitchImg = true;
                Logger.info(TAG, `zc TouchType.Down screenshotPixel: ${this.screenshotPixel === undefined}`);
              }
              if (event.type == TouchType.Up) {
                let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
                let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');
                if (curCameraPosition === camera.CameraPosition.CAMERA_POSITION_BACK) {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_FRONT;
                } else if (curCameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT) {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;
                } else {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;
                }
                GlobalContext.get().setObject('curCameraPosition', curCameraPosition);
                let mConfigRatio = GlobalContext.get().getT<number>('configRatio');
                let preconfigType = GlobalContext.get().getT<camera.PreconfigType>('PreconfigType');
                await CameraService.initCamera(surfaceId, curCameraPosition, preconfigType, mConfigRatio);
              }
            })
          }
        }
        .visibility(this.isRecording ? Visibility.Hidden : Visibility.Visible)
      }
      .padding({ left: Constants.CAPTURE_BUTTON_COLUMN_PADDING, right: Constants.CAPTURE_BUTTON_COLUMN_PADDING })
      .width(Constants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.End)
    .height(Constants.TEN_PERCENT)
    .padding({ left: Constants.CAPTURE_BUTTON_COLUMN_PADDING, right: Constants.CAPTURE_BUTTON_COLUMN_PADDING })
    .margin({ bottom: Constants.CAPTURE_BUTTON_COLUMN_MARGIN })
    .position({ x: Constants.ZERO_PERCENT, y: Constants.EIGHTY_FIVE_PERCENT })
  }
}