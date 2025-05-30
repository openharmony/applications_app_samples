/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import camera from '@ohos.multimedia.camera';
import deviceInfo from '@ohos.deviceInfo';
import fileIo from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import Logger from '../utlis/Logger';
import MediaModel from './MediaModel';


const FOUR = 4; // format
const EIGHT = 8; // capacity
const FOUR_THOUSAND_AND_SIXTY_NINE = 4096; // buffer大小

const cameraMode = {
  modePhoto: 0, // 拍照模式
  modeVideo: 1, // 录像模式
};

const cameraWH = {
  width: 480,
  height: 360,
};

/**
 * 分辨率
 */
export enum VideoFrame {
  VIDEOFRAME_1920_1080,
  VIDEOFRAME_1280_720,
  VIDEOFRAME_800_600,
};

type VideoFrameWH = {
  width: number;
  height: number;
};

const TAG = '[CameraModel]';

export default class CameraService {
  private mediaModel: MediaModel = undefined;
  private fileAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  private cameraMgr: camera.CameraManager = undefined;
  private camerasArray: Array<camera.CameraDevice> = undefined;
  private cameraInput: camera.CameraInput = undefined;
  private previewOutput: camera.PreviewOutput = undefined;
  private photoOutPut: camera.PhotoOutput = undefined;
  private capSession: camera.CaptureSession = undefined;
  private videoOutput: camera.VideoOutput = undefined;
  private capability: camera.CameraOutputCapability = undefined;

  private avRecorder: media.AVRecorder = undefined;
  private receiver: image.ImageReceiver = undefined;
  private photoPath: string = '';
  private fd: number = -1;
  private takePictureHandle: (photoUri: string) => void = undefined;
  private currentMode:number = cameraMode.modePhoto;

  private videoFrameWH: VideoFrameWH = {
    width: 480,
    height: 360,
  }; // 视频分辨率
  private imageRotation: camera.ImageRotation = camera.ImageRotation.ROTATION_0; // 图片旋转角度

  private videoProfile: media.VideoRecorderProfile = {
    audioChannels: 2,
    audioCodec: media.CodecMimeType.AUDIO_AAC,
    audioBitrate: 48000,
    audioSampleRate: 48000,
    fileFormat: media.ContainerFormatType.CFT_MPEG_4,
    videoBitrate: 48000,
    videoCodec: media.CodecMimeType.VIDEO_AVC,
    videoFrameWidth: 480,
    videoFrameHeight: 360,
    videoFrameRate: 30,
  };
  private videoSourceType: number = 0;

  constructor() {
    this.mediaModel = MediaModel.getMediaInstance();
    this.receiver = image.createImageReceiver(
      cameraWH.width,
      cameraWH.height,
      FOUR,
      EIGHT
    );
    Logger.info(TAG, 'createImageReceiver');
    this.receiver.on('imageArrival', () => {
      Logger.info(TAG, 'imageArrival');
      this.receiver.readNextImage((err, image) => {
        Logger.info(TAG, 'readNextImage');
        if (err || image === undefined) {
          Logger.error(TAG, 'failed to get valid image');
          return;
        }
        image.getComponent(FOUR, (errMsg, img) => {
          Logger.info(TAG, 'getComponent');
          if (errMsg || img === undefined) {
            Logger.info(TAG, 'failed to get valid buffer');
            return;
          }
          let buffer = new ArrayBuffer(FOUR_THOUSAND_AND_SIXTY_NINE);
          if (img.byteBuffer) {
            buffer = img.byteBuffer;
          } else {
            Logger.error(TAG, 'img.byteBuffer is undefined');
          }
          this.saveImage(buffer, image);
        });
      });
    });
  }

  /**
   * 设置分辨率
   * @param videoFrame
   */
  setVideoFrameWH(videoFrame: VideoFrame): void {
    switch (videoFrame) {
      case VideoFrame.VIDEOFRAME_800_600:
        this.videoFrameWH = {
          width: 800,
          height: 600,
        };
        Logger.info(
          TAG,
          `setVideoFrameWH videoFrameWH:${JSON.stringify(this.videoFrameWH)}`
        );
        break;
      case VideoFrame.VIDEOFRAME_1280_720:
        this.videoFrameWH = {
          width: 1280,
          height: 720,
        };
        Logger.info(
          TAG,
          `setVideoFrameWH videoFrameWH:${JSON.stringify(this.videoFrameWH)}`
        );
        break;
      case VideoFrame.VIDEOFRAME_1920_1080:
        this.videoFrameWH = {
          width: 1920,
          height: 1080,
        };
        Logger.info(
          TAG,
          `setVideoFrameWH videoFrameWH:${JSON.stringify(this.videoFrameWH)}`
        );
        break;
    }
  }
  /**
   * 设置图片旋转角度
   * @param imageRotation
   */
  setImageRotation(imageRotation: camera.ImageRotation): void {
    this.imageRotation = imageRotation;
  }

  /**
   * 保存图片
   * @param buffer
   * @param img
   */
  async saveImage(buffer: ArrayBuffer, img: image.Image): Promise<void> {
    Logger.info(TAG, 'savePicture');
    this.fileAsset = await this.mediaModel.createAndGetUri(photoAccessHelper.PhotoType.IMAGE);
    this.photoPath = this.fileAsset.uri;
    Logger.info(TAG, `this.photoUri = ${this.photoPath}`);
    this.fd = await this.mediaModel.getFdPath(this.fileAsset);
    Logger.info(TAG, `this.fd = ${this.fd}`);
    await fileIo.write(this.fd, buffer);
    await this.fileAsset.close(this.fd);
    await img.release();
    Logger.info(TAG, 'save image done');
    if (this.takePictureHandle) {
      this.takePictureHandle(this.photoPath);
    }
  }

  /**
   * 初始化相机
   * @param surfaceId
   */
  async initCamera(surfaceId: string): Promise<void> {
    Logger.info(TAG, `initCamera surfaceId:${surfaceId}`);
    await this.cameraRelease();
    Logger.info(TAG, `deviceInfo.deviceType = ${deviceInfo.deviceType}`);
    if (deviceInfo.deviceType === 'default') {
      Logger.info(TAG, `deviceInfo.deviceType default 1 = ${deviceInfo.deviceType}`);
      this.videoSourceType = 1;
      Logger.info(TAG, `deviceInfo.deviceType default 2 = ${deviceInfo.deviceType}`);
    } else {
      Logger.info(TAG, `deviceInfo.deviceType other 1 = ${deviceInfo.deviceType}`);
      this.videoSourceType = 0;
      Logger.info(TAG, `deviceInfo.deviceType other 2 = ${deviceInfo.deviceType}`);
    }
    Logger.info(TAG, 'getCameraManager begin');
    try {
      Logger.info(TAG, 'getCameraManager try begin');
      this.cameraMgr = camera.getCameraManager(globalThis.cameraContext);
      Logger.info(TAG, 'getCameraManager try end');
    } catch (e) {
      Logger.info(TAG, `getCameraManager catch e:${JSON.stringify(e)}`);
      Logger.info(TAG, `getCameraManager catch code:${JSON.stringify(e.code)}`);
      Logger.info(TAG, `getCameraManager catch message:${JSON.stringify(e.message)}`);
    }
    Logger.info(TAG, 'getCameraManager end');
    Logger.info(TAG, `getCameraManager ${JSON.stringify(this.cameraMgr)}`);
    this.camerasArray = this.cameraMgr.getSupportedCameras();
    Logger.info(TAG, `get cameras ${this.camerasArray.length}`);
    if (this.camerasArray.length === 0) {
      Logger.info(TAG, 'cannot get cameras');
      return;
    }

    let mCamera = this.camerasArray[0];
    this.cameraInput = this.cameraMgr.createCameraInput(mCamera);
    this.cameraInput.open();
    Logger.info(TAG, 'createCameraInput');
    this.capability = this.cameraMgr.getSupportedOutputCapability(mCamera);
    let previewProfile = this.capability.previewProfiles[0];
    this.previewOutput = this.cameraMgr.createPreviewOutput(
      previewProfile,
      surfaceId
    );
    Logger.info(TAG, 'createPreviewOutput');
    let rSurfaceId = await this.receiver.getReceivingSurfaceId();
    let photoProfile = this.capability.photoProfiles[0];
    this.photoOutPut = this.cameraMgr.createPhotoOutput(
      photoProfile,
      rSurfaceId
    );
    this.capSession = this.cameraMgr.createCaptureSession();
    Logger.info(TAG, 'createCaptureSession');
    this.capSession.beginConfig();
    Logger.info(TAG, 'beginConfig');
    this.capSession.addInput(this.cameraInput);
    this.capSession.addOutput(this.previewOutput);
    this.capSession.addOutput(this.photoOutPut);
    await this.capSession.commitConfig();
    await this.capSession.start();
    Logger.info(TAG, 'captureSession start');
  }

  setTakePictureHandleCallback(callback): void {
    this.takePictureHandle = callback;
  }

  /**
   * 拍照
   */
  async takePicture(): Promise<void> {
    Logger.info(TAG, 'takePicture');
    if (this.currentMode === cameraMode.modeVideo) {
      this.currentMode = cameraMode.modePhoto;
    }
    Logger.info(TAG, `takePicture imageRotation:${this.imageRotation}`);
    let photoSettings = {
      rotation: this.imageRotation,
      quality: camera.QualityLevel.QUALITY_LEVEL_MEDIUM,
      location: {
        // 位置信息，经纬度
        latitude: 12.9698,
        longitude: 77.75,
        altitude: 1000,
      },
      mirror: false,
    };
    await this.photoOutPut.capture(photoSettings);
    Logger.info(TAG, 'takePicture done');
  }

  /**
   * 开始录像
   */
  async startVideo(): Promise<void> {
    Logger.info(TAG, 'startVideo begin');
    Logger.info(TAG, 'startVideo 1');
    await this.capSession.stop();
    Logger.info(TAG, 'startVideo 2');
    this.capSession.beginConfig();
    Logger.info(TAG, 'startVideo 3');
    if (this.currentMode === cameraMode.modePhoto) {
      this.currentMode = cameraMode.modeVideo;
      if (this.photoOutPut) {
        this.capSession.removeOutput(this.photoOutPut);
        this.photoOutPut.release();
      }
    } else {
      if (this.videoOutput) {
        try {
          Logger.info(TAG, 'startVideo 4');
          this.capSession.removeOutput(this.videoOutput);
          Logger.info(TAG, 'startVideo 5');
        } catch (e) {
          Logger.info(TAG, `startVideo catch e:${JSON.stringify(e)}`);
          Logger.info(TAG, `startVideo catch code:${JSON.stringify(e.code)}`);
          Logger.info(TAG, `startVideo catch message:${JSON.stringify(e.message)}`);
        }
      }
    }
    if (this.videoOutput) {
      try {
        Logger.info(TAG, 'startVideo 6');
        this.capSession.removeOutput(this.videoOutput);
        Logger.info(TAG, 'startVideo 7');
      } catch (e) {
        Logger.info(TAG, `startVideo catch e:${JSON.stringify(e)}`);
        Logger.info(TAG, `startVideo catch code:${JSON.stringify(e.code)}`);
        Logger.info(TAG, `startVideo catch message:${JSON.stringify(e.message)}`);
      }
      try {
        Logger.info(TAG, 'startVideo release 1');
        await this.videoOutput.release();
        Logger.info(TAG, 'startVideo release 2');
      } catch (e) {
        Logger.info(TAG, `startVideo catch e:${JSON.stringify(e)}`);
        Logger.info(TAG, `startVideo catch code:${JSON.stringify(e.code)}`);
        Logger.info(TAG, `startVideo catch message:${JSON.stringify(e.message)}`);
      }
    }
    Logger.info(TAG, 'startVideo 8');
    this.fileAsset = await this.mediaModel.createAndGetUri(photoAccessHelper.PhotoType.VIDEO);
    Logger.info(TAG, `startVideo fileAsset:${this.fileAsset}`);
    this.fd = await this.mediaModel.getFdPath(this.fileAsset);
    Logger.info(TAG, `startVideo fd:${this.fd}`);
    media.createAVRecorder(async (error, recorder) => {
      Logger.info(TAG, `startVideo into createAVRecorder:${recorder}`);
      if (recorder != null) {
        Logger.info(TAG, `startVideo into recorder:${recorder}`);
        this.avRecorder = recorder;
        Logger.info(TAG, `startVideo createAVRecorder success:${this.avRecorder}`);
        // 当前录像配置
        let currConfig = {
          audioSourceType: 1,
          videoSourceType: this.videoSourceType,
          profile: this.videoProfile,
          url: `fd://${this.fd}`,
          rotation: 0
        };
        Logger.info(TAG, `startVideo into recorder:${recorder}`);
        await this.avRecorder.prepare(currConfig);
        Logger.info(TAG, `startVideo videoConfig:${JSON.stringify(currConfig)}`);
        let videoId = await this.avRecorder.getInputSurface();
        let videoProfile = this.capability.videoProfiles[0];
        Logger.info(TAG, `startVideo capability.videoProfiles[]=: ${JSON.stringify(this.capability.videoProfiles)}`);
        Logger.info(TAG, `startVideo videoProfile:${JSON.stringify(videoProfile)}`);
        this.videoOutput = this.cameraMgr.createVideoOutput(videoProfile, videoId);
        Logger.info(TAG, `startVideo videoOutput:${this.videoOutput}`);
        this.capSession.addOutput(this.videoOutput);
        Logger.info(TAG, 'startVideo addOutput');
        await this.capSession.commitConfig();
        Logger.info(TAG, 'startVideo commitConfig');
        await this.capSession.start();
        Logger.info(TAG, 'startVideo commitConfig capSession');
        await this.videoOutput.start();
        Logger.info(TAG, 'startVideo commitConfig videoOutput');
        try {
          Logger.info(TAG, 'startVideo avRecorder.start 1');
          await this.avRecorder.start();
          Logger.info(TAG, 'startVideo avRecorder.start 2');
        } catch (e) {
          Logger.info(TAG, `startVideo catch e:${JSON.stringify(e)}`);
        }

        Logger.info(TAG, 'startVideo end');

      } else {
        Logger.info(TAG, `startVideo createAVRecorder fail, error:${error}`);
      }
    });
  }

  /**
   * 停止录像
   */
  async stopVideo(): Promise<void> {
    Logger.info(TAG, 'stopVideo called');
    await this.avRecorder.stop();
    await this.avRecorder.release();
    await this.videoOutput.stop();
    await this.fileAsset.close(this.fd);
  }

  /**
   * 资源释放
   */
  async cameraRelease(): Promise<void> {
    Logger.info(TAG, 'releaseCamera');
    if (this.cameraInput) {
      await this.cameraInput.close();
    }
    if (this.previewOutput) {
      await this.previewOutput.release();
    }
    if (this.photoOutPut) {
      await this.photoOutPut.release();
    }
    if (this.videoOutput) {
      await this.videoOutput.release();
    }
    if (this.capSession) {
      await this.capSession.release();
    }
  }
}
