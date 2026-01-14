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

import { curves, display } from '@kit.ArkUI';
import { camera } from '@kit.CameraKit';
import WindowUtil from '../utils/WindowUtil';
import CameraConstant from '../constants/Constants';

export enum CameraMode {
  PHOTO,
  VIDEO
}

/**
 * States and methods related to preview.
 */
class PreviewViewModel {
  private uiContext: UIContext;
  // [Start isFront]
  public isFront: boolean = false;
  // [StartExclude isFront]
  public cameraMode: CameraMode = CameraMode.PHOTO;
  public xComponentController: XComponentController = new XComponentController();
  public surfaceId: string = '';
  public previewSize: Size = WindowUtil.getMaxDisplaySize(CameraConstant.RATIO_PHOTO);
  public rates?: number[] = [];
  public currentRate: number = 0;
  public blurRadius: number = 0;
  public blurRotation: RotateOptions = { y: 0.5, angle: 0};

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
  }

  // [EndExclude isFront]
  getCameraPosition() {
    return this.isFront
      ? camera.CameraPosition.CAMERA_POSITION_FRONT
      : camera.CameraPosition.CAMERA_POSITION_BACK;
  }
  // [End isFront]

  getPreviewRatio() {
    return this.cameraMode === CameraMode.PHOTO
      ? CameraConstant.RATIO_PHOTO
      : CameraConstant.RATIO_VIDEO;
  }

  getSceneMode() {
    return this.cameraMode === CameraMode.PHOTO
      ? camera.SceneMode.NORMAL_PHOTO
      : camera.SceneMode.NORMAL_VIDEO;
  }

  // [Start getProfile]
  public getProfile: (cameraOrientation: number,
    picFormat: camera.CameraFormat) => camera.Profile = (cameraOrientation, picFormat) => {
    const displaySize: Size = WindowUtil.getMaxDisplaySize(this.getPreviewRatio());
    const displayRotation = display.getDefaultDisplaySync().rotation * 90;
    const isRevert = (cameraOrientation + displayRotation) % 180 !== 0;
    return {
      // format: camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP,
      format: picFormat,
      size: {
        height: isRevert ? displaySize.width : displaySize.height,
        width: isRevert ? displaySize.height : displaySize.width
      }
    };
  }
  // [End getProfile]

  // [Start setPreviewSize]
  setPreviewSize() {
    const displaySize: Size = WindowUtil.getMaxDisplaySize(this.getPreviewRatio());
    this.previewSize = displaySize;
    this.xComponentController.setXComponentSurfaceRect({
      surfaceWidth: displaySize.width,
      surfaceHeight: displaySize.height
    });
  }
  // [End setPreviewSize]

  getPreviewTop() {
    const previewRatio = this.getPreviewRatio();
    return WindowUtil.getWindowRatio() > previewRatio ? 85 : 0;
  }

  getPreviewWidth() {
    return this.uiContext.px2vp(this.previewSize.width);
  }

  getPreviewHeight() {
    return this.uiContext.px2vp(this.previewSize.height);
  }

  isPhotoMode() {
    return this.cameraMode === CameraMode.PHOTO;
  }

  isVideoMode() {
    return this.cameraMode === CameraMode.VIDEO;
  }

  isCurrentCameraMode(mode: CameraMode) {
    return this.cameraMode === mode;
  }

  openPreviewBlur() {
    animateToImmediately({
      duration: 200,
      curve: Curve.Friction
    }, () => {
      this.blurRadius = 150;
    });
  }

  rotatePreviewBlur() {
    animateToImmediately({
      delay: 50,
      duration: 200,
      curve: curves.cubicBezierCurve(0.2, 0, 0.83, 1),
      onFinish: () => {
        this.rotatePreviewBlurSecond();
      }
    }, () => {
      this.blurRotation = { y: 0.5, angle: 90 };
    });
  }

  rotatePreviewBlurSecond() {
    this.blurRotation = { y: 0.5, angle: 270 };
    animateToImmediately({
      duration: 200,
      curve: curves.cubicBezierCurve(0.17, 0, 0.2, 1),
      onFinish: () => {
        this.blurRotation = { y: 0.5, angle: 0 };
      }
    }, () => {
      this.blurRotation = { y: 0.5, angle: 360 };
    });
  }

  closePreviewBlur() {
    animateToImmediately({
      duration: 200,
      curve: Curve.FastOutSlowIn
    }, () => {
      this.blurRadius = 0;
    });
  }
}

export default PreviewViewModel;