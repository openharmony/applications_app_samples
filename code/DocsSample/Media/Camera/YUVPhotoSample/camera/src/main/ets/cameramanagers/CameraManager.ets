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
  public session?: camera.PhotoSession;
  private cameraInput?: camera.CameraInput;
  private outputManagers: OutputManager[] = [];
  private isHdr: boolean = false;

  constructor(context: Context, outputManagers: OutputManager[]) {
    console.log('CameraManager constructor')
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

  getBestProfile(sceneMode: camera.SceneMode, outputType: OutputType, capability: camera.CameraOutputCapability,
    targetRatio: number, isHdr: boolean): camera.Profile | undefined {
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
    Logger.info(TAG, `getProfile profileArr outputtype:${JSON.stringify(outputType)}, size:${profileArr.length}`);
    for (let i = 0; i < profileArr.length; i++) {
      Logger.info(TAG, `getProfile profileArr:${JSON.stringify(profileArr[i])}`);
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
      }
      profile = profileArr.find(t => t.format === format &&
        Math.abs(t.size.width / t.size.height - targetRatio) < 0.2);
    } else if (outputType === OutputType.PHOTO) {
      profile = profileArr.find(t => t.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP &&
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
      Logger.info(TAG, `createOutput isHdr: ${this.isHdr}`)
      let capability: camera.CameraOutputCapability =
        this.cameraManager.getSupportedFullOutputCapability(device, sceneMode);
      Logger.info(TAG, `createOutput 111: ${capability.photoProfiles}`)
      Logger.info(TAG, `createOutput 111: ${sceneMode}`)
      // [EndExclude session]
      for (const outputManager of this.outputManagers) {
        Logger.info(TAG, `createOutput 222: ${sceneMode}`)
        if (outputManager.isActive) {
          Logger.info(TAG, `createOutput 333: ${sceneMode}`)
          let bestProfile: camera.Profile | undefined = this.getBestProfile(sceneMode, outputManager.type, capability,
            ratio, this.isHdr);
          if (bestProfile === undefined) {
            Logger.info(TAG, `createOutput faild: ${sceneMode}`)
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
      Logger.info(TAG, `createOutput 444: ${sceneMode}`)

      try {
        if (sceneMode === camera.SceneMode.NORMAL_PHOTO) {
          const session = this.session as camera.PhotoSession;
          this.getSupportedColorSpaces()
          session.setColorSpace(this.isHdr ? colorSpaceManager.ColorSpace.DISPLAY_P3 :
            colorSpaceManager.ColorSpace.SRGB)
        }
      } catch (e) {
        Logger.error(TAG, `SetColorSpaceErr:${JSON.stringify(e)}`);
      }

      await session.commitConfig();

      await session.start();
      // [End session]
      this.session = session as (camera.PhotoSession);
      this.setFocusMode(camera.FocusMode.FOCUS_MODE_AUTO);
      this.setExposureMode(camera.ExposureMode.EXPOSURE_MODE_AUTO);
    } catch (e) {
      Logger.error(TAG, `Failed to start camera session. Cause ${JSON.stringify(e)}`);
    }
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

  getSupportedColorSpaces(): Array<colorSpaceManager.ColorSpace> {
    let colorSpaces: colorSpaceManager.ColorSpace[] = [];
    const session = this.session as (camera.PhotoSession);
    try {
      colorSpaces = session.getSupportedColorSpaces();
      console.info(`getSupportedColorSpaces colorSpaces: ${JSON.stringify(colorSpaces)}`);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`The getSupportedColorSpaces call failed. error code: ${err.code}`);
    }
    return colorSpaces;
  }

}