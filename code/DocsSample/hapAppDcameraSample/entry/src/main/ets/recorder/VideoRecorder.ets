/*
 * Copyright (C) 2023-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../utils/Logger';
import SaveCameraAsset from '../utils/SaveCameraAsset';
import { RemoteDeviceModel } from './RemoteDeviceModel';
import { TitleBarComponent } from '../common/TitleBarComponent';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';

const TAG: string = 'Sample_PhotoTaker';

@Entry
@Component
struct PhotoTaker {
  // --- UI State ---
  @State isLand: boolean = false;
  @State isShow: boolean = false;
  // --- Core Camera Objects ---
  private surfaceId: string = '';
  private xcomponentController: XComponentController = new XComponentController();
  private cameraManager?: camera.CameraManager;
  private cameras?: Array<camera.CameraDevice>;
  private cameraInput?: camera.CameraInput;
  private cameraSession?: camera.Session;
  private previewOutput?: camera.PreviewOutput;
  private photoReceiver?: image.ImageReceiver;
  private photoOutput?: camera.PhotoOutput;
  // --- Helper Objects ---
  private mFileAssetId?: number = 0;
  private cameraIndex: number = 0;
  private cameraOutputCapability?: camera.CameraOutputCapability;
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel();

  // --- Lifecycle & Callbacks ---
  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'aboutToDisappear called');
    this.releaseCamera();
  }
  async failureCallback(error: BusinessError): Promise<void> {
    Logger.error(TAG, `Operation failed: ${error.code}, ${error.message}`);
  }

  async catchCallback(error: BusinessError): Promise<void> {
    Logger.error(TAG, `Operation caught exception: ${error.message}`);
  }

  // --- Camera Initialization ---
  // [Start init_camera]
  async initCamera(): Promise<void> {
    Logger.info(TAG, 'initCamera called');
    if (this.cameraManager) {
      return;
    }
    this.cameraManager = camera.getCameraManager(globalThis.abilityContext);
    this.cameras = this.cameraManager.getSupportedCameras();
    if (this.cameras) {
      this.cameraIndex =
        this.cameras.findIndex(cam => cam.connectionType === camera.ConnectionType.CAMERA_CONNECTION_REMOTE);
      if (this.cameraIndex !== -1) {
        this.cameraOutputCapability = this.cameraManager.getSupportedOutputCapability(this.cameras[this.cameraIndex],
          camera.SceneMode.NORMAL_PHOTO);
      }
    }
  }
  // [End init_camera]

  // [Start camera_input]
  async createCameraInput(): Promise<void> {
    if (!this.cameras || this.cameraIndex === -1 || !this.cameraManager) {
      Logger.error(TAG, 'createCameraInput failed: prerequisites not met.');
      return;
    }
    const came = this.cameras[this.cameraIndex];
    this.cameraInput = this.cameraManager.createCameraInput(came);

    if (!this.cameraInput) {
      Logger.error(TAG, 'createCameraInput failed: cameraManager.createCameraInput returned undefined.');
      return;
    }
    try {
      await this.cameraInput.open();
      Logger.info(TAG, 'CameraInput opened successfully.');
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `cameraInput.open() failed with code: ${err.code}, message: ${err.message}`);
    }
  }
  // [End camera_input]

  // [Start create_preview]
  async createPreviewOutput(): Promise<void> {
    // Use optional chaining for a clean prerequisite check
    if (this.cameraOutputCapability?.previewProfiles && this.cameraManager && this.surfaceId) {
      // Select the first available preview profile
      const previewProfile = this.cameraOutputCapability.previewProfiles[0];

      this.previewOutput = this.cameraManager.createPreviewOutput(previewProfile, this.surfaceId);

      // Add a clear check to validate the result of the API call
      if (!this.previewOutput) {
        Logger.error(TAG, 'createPreviewOutput failed: cameraManager.createPreviewOutput returned undefined.');
      } else {
        Logger.info(TAG, 'PreviewOutput created successfully.');
      }
    } else {
      Logger.error(TAG, 'createPreviewOutput failed: prerequisites not met (capability, manager, or surfaceId missing).');
    }
  }
  // [End create_preview]

  // [Start create_photo]
  async createPhotoOutput() {
    if (!this.cameraManager || this.photoReceiver) {
      return;
    }

    const photoProfile: camera.Profile = {
      format: camera.CameraFormat.CAMERA_FORMAT_JPEG,
      size: { 'width': 1280, 'height': 720 }
    };

    try {
      this.photoReceiver = image.createImageReceiver(photoProfile.size, image.ImageFormat.JPEG, 8);
      this.photoReceiver.on('imageArrival', () => {
        (async () => {
          if (!this.photoReceiver) {
            Logger.error(TAG, 'photoReceiver is undefined in imageArrival callback.');
            return;
          }
          let receivedImage: image.Image | undefined = undefined;
          try {
            receivedImage = await this.photoReceiver.readNextImage();
            const component = await receivedImage.getComponent(image.ComponentType.JPEG);
            await this.getImageFileFd();
            await fileIo.write(this.mFileAssetId, component.byteBuffer);
            Logger.info(TAG, 'Photo saved successfully!');
          } catch (e) {
            Logger.error(TAG, `Error processing image: ${JSON.stringify(e)}`);
          } finally {
            if (receivedImage) {
              await receivedImage.release();
            }
            await this.closeFd();
          }
        })();
      });

      const surfaceId = await this.photoReceiver.getReceivingSurfaceId();
      this.photoOutput = this.cameraManager.createPhotoOutput(photoProfile, surfaceId);
    } catch (error) {
      Logger.error(TAG, `createPhotoOutput failed: ${JSON.stringify(error)}`);
    }
  }
  private mSaveCameraAsset: SaveCameraAsset = new SaveCameraAsset(TAG);

  async getImageFileFd(): Promise<void> {
    this.mFileAssetId = await this.mSaveCameraAsset.createImageFd();
  }

  async closeFd(): Promise<void> {
    if (this.mSaveCameraAsset) {
      await this.mSaveCameraAsset.closeImageFile();
    }
    this.mFileAssetId = undefined;
  }
  // [End create_photo]

  // [Start create_session]
  async createSession(): Promise<void> {
    Logger.info(TAG, 'createSession called');
    if (!this.cameraManager) {
      Logger.error(TAG, 'createSession failed: cameraManager is not initialized.');
      return;
    }
    this.cameraSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO);
    if (!this.cameraSession) {
      Logger.error(TAG, 'createSession failed: cameraManager.createSession returned undefined.');
      return;
    }

    try {
      Logger.info(TAG, 'cameraSession beginConfig');
      this.cameraSession.beginConfig();

      if (this.cameraInput) {
        Logger.info(TAG, 'cameraSession addInput: cameraInput');
        this.cameraSession.addInput(this.cameraInput);
      }
      if (this.previewOutput) {
        Logger.info(TAG, 'cameraSession addOutput: previewOutput');
        this.cameraSession.addOutput(this.previewOutput);
      }
      if (this.photoOutput) {
        Logger.info(TAG, 'cameraSession addOutput: photoOutput');
        this.cameraSession.addOutput(this.photoOutput);
      }

      Logger.info(TAG, 'cameraSession commitConfig');
      await this.cameraSession.commitConfig();
      Logger.info(TAG, 'cameraSession commitConfig successfully.');

    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `cameraSession configuration failed with code: ${err.code}, message: ${err.message}`);
      this.failureCallback(err);
    }
  }
  // [End create_session]

  // [Start start_session]
  async startSession(): Promise<void> {
    Logger.info(TAG, 'startSession called');
    if (!this.cameraSession) {
      Logger.error(TAG, 'startSession failed: captureSession does not exist!');
      return;
    }

    try {
      await this.cameraSession.start();
      Logger.info(TAG, 'cameraSession started successfully.');
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Failed to start session! Code: ${err.code}, Msg: ${err.message}`);
    }
  }
  // [End start_session]

  // [Start release_camera]
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, '--- STARTING CAMERA RELEASE SEQUENCE ---');

    try {
      // Step 1: Stop and release the session
      if (this.cameraSession) {
        Logger.info(TAG, 'Stopping capture session...');
        await this.cameraSession.stop();
        Logger.info(TAG, 'Releasing capture session...');
        await this.cameraSession.release();
        this.cameraSession = undefined;
      }

      // Step 2: Release the preview output
      if (this.previewOutput) {
        Logger.info(TAG, 'Releasing preview output...');
        await this.previewOutput.release();
        this.previewOutput = undefined;
      }

      // Step 3: Release the photo output and receiver
      if (this.photoOutput) {
        Logger.info(TAG, 'Releasing photo output...');
        await this.photoOutput.release();
        this.photoOutput = undefined;
      }
      if (this.photoReceiver) {
        Logger.info(TAG, 'Releasing photo receiver...');
        await this.photoReceiver.release();
        this.photoReceiver = undefined;
      }

      // Step 4: Close the camera input
      if (this.cameraInput) {
        Logger.info(TAG, 'Closing camera input...');
        await this.cameraInput.close();
        this.cameraInput = undefined;
      }

      Logger.info(TAG, 'All camera resources released.');

    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Error during camera release! Code: ${err.code}, Msg: ${err.message}`);
    } finally {
      // Ensure core objects are cleared even if an error occurs
      this.cameraManager = undefined;
      this.cameras = undefined;
      Logger.info(TAG, '--- CAMERA RELEASE SEQUENCE ENDED ---');
    }
  }
  // [End release_camera]
  async enterInit(): Promise<void> {
    Logger.info(TAG, 'enterInit called');
    await this.initCamera();
    await this.createCameraInput();
    await this.createPreviewOutput();
    await this.createPhotoOutput();
    await this.createSession();
    await this.startSession();
    Logger.info(TAG, 'end enterInit');
  }

  // --- User Actions ---
  async takePicture(): Promise<void> {
    if (!this.photoOutput) {
      Logger.error(TAG, 'photoOutput is not ready!');
      return;
    }
    Logger.info(TAG, 'takePicture called');
    await this.photoOutput.capture();
  }

  build() {
    Column() {
      Row() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          TitleBarComponent({
            isLand: this.isLand,
            startAbilityCallBack: () => {
            },
            remoteDeviceModel: this.remoteDeviceModel,
            isShow: this.isShow
          })
          Button('Connect Remote')
            .onClick(() => this.enterInit())
        }
      }

      Stack({ alignContent: Alignment.Bottom }) {
        XComponent({
          id: 'xcomponent1',
          type: 'surface',
          controller: this.xcomponentController
        })
          .onLoad(() => {
            this.xcomponentController.setXComponentSurfaceSize({ surfaceWidth: 1280, surfaceHeight: 720 });
            this.surfaceId = this.xcomponentController.getXComponentSurfaceId();
          })
          .width('100%').height('100%')

        // This is the new button, replacing the old one.
        Row() {
          Button() {
            Text()
              .width('240px')
              .height('240px')
              .borderRadius('120px')
              // Using a fixed color as requested
              .backgroundColor('#FFFFFF')
          }
          .border({ width: 3, color: 0xFFFFFF, radius: 70 })
          .width('300px')
          .height('300px')
          .margin({ left: 30, right: 30, bottom: 50 }) // Added bottom margin for spacing
          .backgroundColor('rgba(255,255,255,0.20)')
          .onClick(() => {
            // Correctly calls the takePicture function
            this.takePicture();
          })
          .id('takePictureButton')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

      }.width('100%').layoutWeight(1)
    }
  }
}