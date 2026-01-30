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
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig, OutputType } from './OutputManager';
import { colorSpaceManager } from '@kit.ArkGraphics2D';

const TAG = 'CameraManager';

export class CameraManager {
  private cameraManager: camera.CameraManager;
  public session?: camera.PhotoSession | camera.VideoSession;
  private cameraInput?: camera.CameraInput;
  private outputManagers: OutputManager[] = [];
  private isHdr: boolean = false;
  private xComponentSurfaceId: string = '';
  private cameraPosition: camera.CameraPosition = camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED;
  private sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  private ratio: number = 0;

  constructor(context: Context, outputManagers: OutputManager[]) {
    // [Start cameraManager]
    this.cameraManager = camera.getCameraManager(context);
    // [End cameraManager]
    this.outputManagers = outputManagers;
    this.addCameraStatusListener();
  }

  addCameraStatusListener() {
    this.cameraManager.on('cameraStatus', (err: BusinessError, statusInfo: camera.CameraStatusInfo) => {
      if (err && err.message) {
        Logger.error(TAG, 'cameraStatus with errorMessage = ' + err.message);
        return;
      }
      Logger.info(TAG, `cameraStatusInfo: camera is ${statusInfo.camera.cameraId}, status is ${statusInfo.status}`);
    });
  }

  getCameraManager() {
    return this.cameraManager;
  }

  getBestProfile(sceneMode: camera.SceneMode, outputType: OutputType,
    capability: camera.CameraOutputCapability, targetRatio: number, isHdr: boolean): camera.Profile | undefined {
    Logger.info(TAG, `getProfile outputType:${outputType} targetRatio:${targetRatio}`);
    let profileArr: camera.Profile[] = [];
    if (outputType === OutputType.PREVIEW) {
      // preview
      profileArr = capability.previewProfiles;
    } else if (outputType === OutputType.PHOTO) {
      // photo
      profileArr = capability.photoProfiles;
    } else if (outputType === OutputType.VIDEO) {
      // video
      profileArr = capability.videoProfiles;
    }
    for (let i = 0; i < profileArr.length; i++) {
      Logger.debug(TAG, `getProfile profileArr:${JSON.stringify(profileArr[i])}`);
    }

    // sort profile arr
    profileArr.sort((a, b) => {
      if (a.size.width !== b.size.width) {
        return b.size.width - a.size.width;
      } else {
        return b.size.height - a.size.height;
      }
    });

    // find target ratio best profile
    let profile: camera.Profile | undefined = undefined;
    let format: camera.CameraFormat;
    if (outputType === OutputType.PREVIEW) {
      // previewOutput
      if (sceneMode === camera.SceneMode.NORMAL_PHOTO) {
        format = camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP;
      } else if (sceneMode === camera.SceneMode.NORMAL_VIDEO) {
        format = isHdr ? camera.CameraFormat.CAMERA_FORMAT_YCRCB_P010 : camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP
      }
      profile = profileArr.find(t => t.format === format &&
        (Math.abs(t.size.width / t.size.height - targetRatio) < 0.2) && t.size.width == 1920);
    } else if (outputType === OutputType.PHOTO) {
      // photoOutput
      profile = profileArr.find(t => t.format === camera.CameraFormat.CAMERA_FORMAT_JPEG &&
        Math.abs(t.size.width / t.size.height - targetRatio) < 0.2);
    } else if (outputType === OutputType.VIDEO) {
      // videoOutput
      if (sceneMode === camera.SceneMode.NORMAL_PHOTO) {
        format = camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP;
      } else if (sceneMode === camera.SceneMode.NORMAL_VIDEO) {
        format = isHdr ? camera.CameraFormat.CAMERA_FORMAT_YCRCB_P010 : camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP
      }
      profile = profileArr.find(t => t.format === format &&
        Math.abs(t.size.width / t.size.height - targetRatio) < 0.2);
    }
    Logger.info(TAG,
      `getProfile profileType:${outputType} format:${profile?.format} width:${profile?.size.width} height:${profile?.size.height}`);
    return profile;
  }

  async start(
    xComponentSurfaceId: string,
    cameraPosition: camera.CameraPosition,
    sceneMode: camera.SceneMode,
    ratio: number
  ) {
    this.xComponentSurfaceId = xComponentSurfaceId;
    this.cameraPosition = cameraPosition;
    this.sceneMode = sceneMode;
    this.ratio = ratio;
    try {
      const device = this.getCameraDevice(cameraPosition);
      if (!device) {
        return;
      }
      // [Start cameraInput]
      this.cameraInput = this.cameraManager.createCameraInput(device);
      await this.cameraInput.open();
      // [End cameraInput]
      // [Start session]
      const session = this.cameraManager.createSession(sceneMode);
      session.beginConfig();
      session.addInput(this.cameraInput);
      // [StartExclude session]
      Logger.info(TAG, `CameraTest createOutput isHdr: ${this.isHdr}`)
      let capability: camera.CameraOutputCapability =
        this.cameraManager.getSupportedOutputCapability(device, sceneMode);
      Logger.info(TAG, `CameraTest createOutput 111: ${sceneMode}`)
      // [EndExclude session]
      for (const outputManager of this.outputManagers) {
        Logger.info(TAG, `CameraTest createOutput 222: ${sceneMode}`)
        if (outputManager.isActive) {
          Logger.info(TAG, `CameraTest createOutput 333: ${sceneMode}`)
          let bestProfile: camera.Profile | undefined = this.getBestProfile(sceneMode,
            outputManager.type, capability, ratio, this.isHdr);
          if (bestProfile === undefined) {
            Logger.info(TAG, `CameraTest createOutput faild: ${sceneMode}`)
            return;
          }
          const config: CreateOutputConfig = {
            cameraManager: this.cameraManager,
            device: device,
            profile: bestProfile,
            sceneMode: sceneMode,
            cameraOrientation: device.cameraOrientation,
            surfaceId: xComponentSurfaceId
          };
          const output = await outputManager.createOutput(config);
          session.addOutput(output);
        }
      };
      Logger.info(TAG, `CameraTest createOutput 444: ${sceneMode}`)

      try {
        if (sceneMode === camera.SceneMode.NORMAL_PHOTO) {
          const session = this.session as camera.PhotoSession;
          this.getSupportedColorSpaces()
          session.setColorSpace(this.isHdr ? colorSpaceManager.ColorSpace.DISPLAY_P3 :
            colorSpaceManager.ColorSpace.SRGB)
        } else if (sceneMode === camera.SceneMode.NORMAL_VIDEO) {
          const session = this.session as camera.VideoSession;
          session.setColorSpace(this.isHdr ? colorSpaceManager.ColorSpace.BT2020_HLG_LIMIT :
            colorSpaceManager.ColorSpace.BT709_LIMIT)
        }
      } catch (e) {
        Logger.error(TAG, `CameraTest SetColorSpaceErr:${JSON.stringify(e)}`);
      }

      await session.commitConfig();

      await session.start();
      // [End session]
      this.session = session as (camera.PhotoSession | camera.VideoSession);
      this.setFocusMode(camera.FocusMode.FOCUS_MODE_AUTO);
      this.setExposureMode(camera.ExposureMode.EXPOSURE_MODE_AUTO);
    } catch (e) {
      Logger.error(TAG, `Failed to start camera session. Cause ${JSON.stringify(e)}`);
    }
  }

  async refreshOutput(oldOutput: camera.CameraOutput, newOutput: camera.CameraOutput) {
    await this.session?.stop();
    this.session?.beginConfig();
    this.session?.removeOutput(oldOutput);
    this.session?.addOutput(newOutput);
    await this.session?.commitConfig();
    await this.session?.start();
  }

  async restartCamera() {
    await this.release();
    await this.start(this.xComponentSurfaceId, this.cameraPosition, this.sceneMode, this.ratio);
  }

  // [Start release]
  async release() {
    await this.session?.stop();
    for (const outputManager of this.outputManagers) {
      if (outputManager.isActive) {
        await outputManager.release();
      }
    }
    ;
    await this.cameraInput?.close();
    await this.session?.release();
  }

  // [End release]

  // [Start getCameraDevice]
  getCameraDevice(cameraPosition: camera.CameraPosition) {
    const cameraDevices = this.cameraManager.getSupportedCameras();
    const device = cameraDevices?.find(device => device.cameraPosition === cameraPosition) || cameraDevices[0];
    if (!device) {
      Logger.error(TAG, `Failed to get camera device. cameraPosition: ${cameraPosition}`);
    }
    return device;
  }

  // [End getCameraDevice]

  // [Start getZoomRange]
  getZoomRange() {
    return this.session!.getZoomRatioRange();
  }

  // [End getZoomRange]

  // [Start setFocusMode]
  setFocusMode(focusMode: camera.FocusMode) {
    try {
      const isSupported = this.session?.isFocusModeSupported(focusMode);
      if (!isSupported) {
        Logger.error(TAG, `setFocusMode error: focus mode ${focusMode} is not supported`);
        return;
      }
      this.session?.setFocusMode(focusMode);
    } catch (e) {
      Logger.error(TAG, 'setFocusMode error ' + JSON.stringify(e));
    }
  }

  // [End setFocusMode]

  // [Start setFocusPoint]
  setFocusPoint(point: camera.Point) {
    try {
      this.session?.setFocusPoint(point);
    } catch (e) {
      Logger.error(TAG, 'setFocusPoint error ' + JSON.stringify(e));
    }
  }

  // [End setFocusPoint]

  // [Start setExposureMode]
  setExposureMode(exposureMode: camera.ExposureMode) {
    try {
      const isSupported = this.session?.isExposureModeSupported(exposureMode);
      if (!isSupported) {
        Logger.error(TAG, `setExposureMode error: focus mode ${exposureMode} is not supported`);
        return;
      }
      this.session?.setExposureMode(exposureMode);
    } catch (e) {
      Logger.error(TAG, 'setExposureMode error ' + JSON.stringify(e));
    }
  }

  // [End setExposureMode]

  // [Start setMeteringPoint]
  setMeteringPoint(point: camera.Point) {
    try {
      this.session?.setMeteringPoint(point);
    } catch (e) {
      Logger.error(TAG, 'setMeteringPoint error ' + JSON.stringify(e));
    }
  }

  // [End setMeteringPoint]

  setZoomRatio(zoom: number) {
    try {
      this.session?.setZoomRatio(zoom);
    } catch (e) {
      Logger.error(TAG, 'setZoomRatio error ' + JSON.stringify(e));
    }
  }

  // [Start setSmoothZoom]
  setSmoothZoom(zoom: number) {
    try {
      this.session?.setSmoothZoom(zoom);
    } catch (e) {
      Logger.error(TAG, 'setSmoothZoom error ' + JSON.stringify(e));
    }
  }

  // [End setSmoothZoom]

  // [Start setFlashMode]
  setFlashMode(flashMode: camera.FlashMode) {
    try {
      const isSupported = this.session?.isFlashModeSupported(flashMode);
      if (!isSupported) {
        Logger.error(TAG, `setFlashMode error: flash mode ${flashMode} is not supported`);
        return;
      }
      this.session?.setFlashMode(flashMode);
    } catch (e) {
      Logger.error(TAG, 'setFlashMode error ' + JSON.stringify(e));
    }
  }

  // [End setFlashMode]

  setVideoStabilizationMode(stabilizationMode: camera.VideoStabilizationMode) {
    try {
      const session = this.session as camera.VideoSession;
      const isSupported: boolean = session.isVideoStabilizationModeSupported(stabilizationMode);
      if (isSupported) {
        session.setVideoStabilizationMode(stabilizationMode);
      } else {
        Logger.error(TAG, 'stabilizationMode is not supported: ' + JSON.stringify(stabilizationMode));
      }
    } catch (e) {
      Logger.error(TAG, 'setVideoStabilizationMode error ' + JSON.stringify(e));
    }
  }

  setHdr(isHdr: boolean) {
    Logger.info(TAG, `CameraTest setHdr: ${isHdr}`)
    this.isHdr = isHdr;
  }

  getSupportedColorSpaces(): Array<colorSpaceManager.ColorSpace> {
    let colorSpaces: colorSpaceManager.ColorSpace[] = [];
    const session = this.session as (camera.PhotoSession | camera.VideoSession);
    try {
      colorSpaces = session.getSupportedColorSpaces();
      console.info(`getSupportedColorSpaces colorSpaces: ${JSON.stringify(colorSpaces)}`);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`The getSupportedColorSpaces call failed. error code: ${err.code}`);
    }
    return colorSpaces;
  }

  setColorSpaceBeforeCommitConfig(isHdr: boolean): void {
    let colorSpace: colorSpaceManager.ColorSpace =
      isHdr ? colorSpaceManager.ColorSpace.DISPLAY_P3 : colorSpaceManager.ColorSpace.SRGB;
    let colorSpaces: colorSpaceManager.ColorSpace[] = this.getSupportedColorSpaces();
    let isSupportedColorSpaces = colorSpaces.indexOf(colorSpace) >= 0;
    if (isSupportedColorSpaces) {
      console.info(`setColorSpace: ${colorSpace}`);
      const session = this.session as (camera.PhotoSession | camera.VideoSession);
      session.setColorSpace(colorSpace);
      let activeColorSpace: colorSpaceManager.ColorSpace = session.getActiveColorSpace();
      console.info(`activeColorSpace: ${activeColorSpace}`);
    } else {
      console.info(`colorSpace: ${colorSpace} is not support`);
    }
  }
}