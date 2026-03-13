/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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
import Logger from '../common/Logger';

export default class CameraService {
  private tag: string = 'CameraService';
  private context: any = undefined;
  private cameraManager: camera.CameraManager = undefined;
  private cameras: Array<camera.CameraDevice> = undefined;
  private cameraInput: camera.CameraInput = undefined;
  private previewOutput: camera.PreviewOutput = undefined;
  private cameraOutputCapability: camera.CameraOutputCapability = undefined;
  private captureSession: camera.CaptureSession = undefined;

  constructor(context: any) {
    this.context = context;
  }

  // 拿到相机设备列表
  getCamerasList(): Array<camera.CameraDevice> {
    this.cameraManager = camera.getCameraManager(this.context);
    this.cameras = this.cameraManager.getSupportedCameras();
    return this.cameras;
  }

  async hasLocalCamera(): Promise<boolean> {
    Logger.info(this.tag, 'hasLocalCamera');
    this.cameraManager = camera.getCameraManager(this.context);
    Logger.info(this.tag, 'hasLocalCamera getCameraManager success');

    try {
      this.cameras = this.cameraManager.getSupportedCameras();
      Logger.info(this.tag, `hasLocalCamera getSupportedCameras len:${this.cameras.length}`);
    } catch (err) {
      Logger.info(this.tag, 'hasLocalCamera getSupportedCameras failed');
      return false;
    }
    if (this.cameras) {
      for (let cameraIndex = 0; cameraIndex < this.cameras.length; cameraIndex++) {
        Logger.info(this.tag, `hasLocalCamera cameraIndex:${cameraIndex}`);
        Logger.info(this.tag, `hasLocalCamera connectionType:${this.cameras[cameraIndex].connectionType}`);
        if (this.cameras[cameraIndex].connectionType !== camera.ConnectionType.CAMERA_CONNECTION_REMOTE) {
          return true;
        }
      }
    }
    return false;
  }

  async initCamera(surfaceId: string, cameraDevice?: camera.CameraDevice) {
    await this.releaseCamera();
    this.cameraManager = camera.getCameraManager(this.context);
    this.cameras = this.cameraManager.getSupportedCameras();

    // 默认取本地摄像头，防止初始化时错误加载远端摄像头
    let mCamera: camera.CameraDevice | undefined = this.cameras.find((item) => item.connectionType === 0);

    // 如果不存在本地摄像头，初始化远端摄像头
    if (mCamera === null) {
      mCamera = this.cameras[0];
    }

    if (cameraDevice) {
      // 处理入参
      mCamera = cameraDevice;
    }

    this.cameraInput = this.cameraManager.createCameraInput(mCamera);
    await this.cameraInput.open();
    this.cameraOutputCapability =
      this.cameraManager.getSupportedOutputCapability(mCamera, camera.SceneMode.NORMAL_PHOTO);
    let previewProfiles: Array<camera.Profile> = this.cameraOutputCapability.previewProfiles;
    let previewProfile: camera.Profile = previewProfiles[0];

    try {
      this.previewOutput = this.cameraManager.createPreviewOutput(previewProfile, surfaceId);
      this.captureSession = this.cameraManager.createCaptureSession();
      this.captureSession.beginConfig();
      this.captureSession.addInput(this.cameraInput);
      this.captureSession.addOutput(this.previewOutput);
      await this.captureSession.commitConfig();
      await this.captureSession.start();
    } catch (err) {
      Logger.error(this.tag, 'captureSession err ' + JSON.stringify(err));
    }
  }

  async releaseCamera() {
    Logger.info(this.tag, 'releaseCamera');
    if (this.cameraInput) {
      await this.cameraInput.close();
    }
    if (this.previewOutput) {
      await this.previewOutput.release();
    }
    if (this.captureSession) {
      await this.captureSession.release();
    }
  }
};
