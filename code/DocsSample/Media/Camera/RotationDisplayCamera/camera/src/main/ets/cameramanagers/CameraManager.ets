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
import { BusinessError } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig } from './OutputManager';
import { PreviewManager } from './PreviewManager';

const TAG = 'CameraManager';

function  getMaxDisplaySize(ratio: number): Size {
  const defaultDisplay: display.Display = display.getDefaultDisplaySync();
  const windowWidth: number = defaultDisplay.width;
  const windowHeight: number = defaultDisplay.height;
  const rotation = display.getDefaultDisplaySync().rotation * 90;
  if (rotation === 90 || rotation === 270) {
    ratio = 1 / ratio;
  }
  // Calculate the height based on the screen width.
  const calculatedHeight = windowWidth * ratio;
  if (calculatedHeight <= windowHeight) {
    return {
      width: windowWidth,
      height: calculatedHeight
    };
  } else {
    return {
      width: windowHeight / ratio,
      height: windowHeight
    };
  }
}

export class CameraManager {
  private cameraManager: camera.CameraManager;
  public session?: camera.PhotoSession | camera.VideoSession;
  private cameraInput?: camera.CameraInput;
  private outputManagers: OutputManager[] = [];
  private xComponentSurfaceId: string = '';
  private cameraPosition: camera.CameraPosition = camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED;
  private sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;

  getPreviewRatio() {
    return this.sceneMode === camera.SceneMode.NORMAL_PHOTO
      ? 4 / 3
      : 16 / 9;
  }

  public getProfile: (cameraOrientation: number, picFormat: camera.CameraFormat) => camera.Profile =
    (cameraOrientation, picFormat) => {
      const displaySize: Size = getMaxDisplaySize(this.getPreviewRatio());
      const displayRotation = display.getDefaultDisplaySync().rotation * 90;
      const isRevert = (cameraOrientation + displayRotation) % 180 !== 0;
      return {
        format: picFormat,
        size: {
          height: isRevert ? displaySize.width : displaySize.height,
          width: isRevert ? displaySize.height : displaySize.width
        }
      };
    }

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

  async start(
    xComponentSurfaceId: string,
    cameraPosition: camera.CameraPosition,
    sceneMode: camera.SceneMode,
    getProfile: (cameraOrientation: number, picFormat: camera.CameraFormat) => camera.Profile
  ) {
    this.xComponentSurfaceId = xComponentSurfaceId;
    this.cameraPosition = cameraPosition;
    this.sceneMode = sceneMode;
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
      const config: CreateOutputConfig = {
        cameraManager: this.cameraManager,
        device,
        sceneMode,
        profile: getProfile(device.cameraOrientation, camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP),
        surfaceId: xComponentSurfaceId
      };
      // [EndExclude session]
      for (const outputManager of this.outputManagers) {
        if (outputManager.isActive) {
          const output = await outputManager.createOutput(config);
          session.addOutput(output);
        }
      };
      await session.commitConfig();
      for (const outputManager of this.outputManagers) {
        if (outputManager.isActive && outputManager instanceof PreviewManager) {
            outputManager.setRotate();
            display.off('change');
            display.on('change', () => {
              outputManager.setRotate();
            });
        }
      };
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
    await this.start(this.xComponentSurfaceId, this.cameraPosition, this.sceneMode, this.getProfile);
  }

  // [Start release]
  async release() {
    display.off('change');
    await this.session?.stop();
    for (const outputManager of this.outputManagers) {
      if (outputManager.isActive) {
        await outputManager.release();
      }
    };
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
    } catch(e) {
      Logger.error(TAG, 'setFocusMode error ' + JSON.stringify(e));
    }
  }
  // [End setFocusMode]

  // [Start setFocusPoint]
  setFocusPoint(point: camera.Point) {
    try {
      this.session?.setFocusPoint(point);
    } catch(e) {
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
    } catch(e) {
      Logger.error(TAG, 'setExposureMode error ' + JSON.stringify(e));
    }
  }
  // [End setExposureMode]

  // [Start setMeteringPoint]
  setMeteringPoint(point: camera.Point) {
    try {
      this.session?.setMeteringPoint(point);
    } catch(e) {
      Logger.error(TAG, 'setMeteringPoint error ' + JSON.stringify(e));
    }
  }
  // [End setMeteringPoint]

  setZoomRatio(zoom: number) {
    try {
      this.session?.setZoomRatio(zoom);
    } catch(e) {
      Logger.error(TAG, 'setZoomRatio error ' + JSON.stringify(e));
    }
  }

  // [Start setSmoothZoom]
  setSmoothZoom(zoom: number) {
    try {
      this.session?.setSmoothZoom(zoom);
    } catch(e) {
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
    } catch(e) {
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

  setWhiteBalanceMode(whiteBalanceMode: camera.WhiteBalanceMode) {
    let isSupported: boolean | undefined = false;
    isSupported = this.session?.isWhiteBalanceModeSupported(whiteBalanceMode);
    if (isSupported) {
      this.session?.setWhiteBalanceMode(whiteBalanceMode);
    }
    let curMode = this.session?.getWhiteBalanceMode();
    if (curMode === whiteBalanceMode) {
      console.info(TAG, `setWhiteBalance success, curMode: ${curMode}`);
    } else {
      console.error(TAG, `setWhiteBalance failed, curMode: ${curMode}, setMode: ${whiteBalanceMode}`);
    }
  }
}