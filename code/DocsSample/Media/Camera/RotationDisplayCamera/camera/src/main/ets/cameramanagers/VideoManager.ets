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

import { media } from '@kit.MediaKit';
import { camera } from '@kit.CameraKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { sensor } from '@kit.SensorServiceKit';
import { Decimal } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { colorSpaceManager } from '@kit.ArkGraphics2D';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig } from './OutputManager';
import CameraConstant from '../constants/CameraConstants';

const TAG_LOG = 'video';

enum QualityLevel {
  NORMAL,
  HIGHER
}

export enum AVRecorderState {
  IDLE = 'idle',
  PREPARED = 'prepared',
  STARTED = 'started',
  PAUSED = 'paused',
  STOPPED = 'stopped',
  RELEASED = 'released',
  ERROR = 'error'
}

export class VideoManager implements OutputManager {
  private avRecorder: media.AVRecorder | undefined = undefined;
  private avConfig: media.AVRecorderConfig | undefined = undefined;
  private avProfile: media.AVRecorderProfile | undefined = undefined;
  private videoProfile: camera.VideoProfile | undefined = undefined;
  private context: Context | undefined = undefined;
  private cameraPosition: number = 0;
  private qualityLevel: QualityLevel = QualityLevel.NORMAL;
  public output: camera.VideoOutput | undefined = undefined;
  private videoUri: string = '';
  private file: fileIo.File | undefined = undefined;
  public state: media.AVRecorderState = AVRecorderState.IDLE;
  public isActive: boolean = false;
  private callback: (pixelMap: image.PixelMap, url: string) => void = () => {
  };

  constructor(context: Context) {
    this.context = context;
  }

  setIsActive(isActive: boolean) {
    this.isActive = isActive;
  }

  async createOutput(config: CreateOutputConfig) {
    try {
      this.avRecorder = await media.createAVRecorder();
      this.avRecorder.on('stateChange', state => {
        this.state = state;
        Logger.info(TAG_LOG, 'on avRecorder state change: ', state)
      });
    } catch (error) {
      Logger.info(TAG_LOG, 'createAVRecorder call failed. error code: %{public}s', error.code);
    }
    if (this.avRecorder === undefined || this.avRecorder === null) {
      return;
    }
    this.setVideoProfile(config.cameraManager, config.profile, config.device);
    await this.setAVConfig();
    await this.prepare();
    await this.createVideoOutput(config.cameraManager);
    return this.output;
  }

  async prepare() {
    try {
      if (this.avRecorder?.state === AVRecorderState.IDLE && this.avConfig) {
        await this.avRecorder.prepare(this.avConfig);
        Logger.info(TAG_LOG, 'Succeeded in preparing');
      }
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to prepare and catch error is  ${error.message}`);
    }
  }

  // [Start is_support_mirror]
  isSupportMirror() {
    let isSupported: boolean | undefined = this.output?.isMirrorSupported();
    return isSupported;
  }
  // [End is_support_mirror]

  // [Start start_video]
  async start(isFront: boolean) {
    try {
      if (this.avRecorder?.state === AVRecorderState.PREPARED) {
        if (this.isSupportMirror() && isFront) {
          this.output?.enableMirror(true)
        }
        // [StartExclude start_video]
        // [Start update_rotation]
        await this.avRecorder.updateRotation(this.getVideoRotation(await this.getGravity()));
        // [End update_rotation]
        // [EndExclude start_video]
        await this.output?.start();
        await this.avRecorder?.start();
      }
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to start and catch error is  ${error.message}`);
    }
  }
  // [End start_video]

  // [Start stop_video]
  async stop() {
    try {
      if (this.avRecorder?.state === AVRecorderState.STARTED ||
        this.avRecorder?.state === AVRecorderState.PAUSED) {
        await this.avRecorder.stop();
        await this.output?.stop();
        const thumbnail = await this.getVideoThumbnail();
        if (thumbnail) {
          this.callback(thumbnail, this.videoUri);
        }
      }
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to stop and catch error is  ${error.message}`);
    }
  }
  // [End stop_video]

  // [Start pause_video]
  async pause() {
    try {
      if (this.avRecorder?.state === AVRecorderState.STARTED) {
        await this.avRecorder.pause();
        await this.output?.stop();
      }
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to pause and catch error is  ${error.message}`);
    }
  }
  // [End pause_video]

  // [Start resume_video]
  async resume() {
    try {
      if (this.avRecorder?.state === AVRecorderState.PAUSED) {
        await this.output?.start();
        await this.avRecorder.resume();
      }
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to resume and catch error is  ${error.message}`);
    }
  }
  // [End resume_video]

  // [Start release_video]
  async release() {
    await this.avRecorder?.release();
    await this.output?.release();
    this.file && await fileIo.close(this.file.fd);
    this.avRecorder?.off('stateChange');
    this.avRecorder = undefined;
    this.output = undefined;
    this.file = undefined;
  }
  // [End release_video]

  getCurrentOutput() {
    return this.output;
  }

  setVideoCallback(callback: (pixelMap: image.PixelMap, url: string) => void) {
    this.callback = callback;
  }

  // [Start create_video_output]
  async createVideoOutput(cameraManager: camera.CameraManager) {
    if (!this.avRecorder || this.avRecorder.state !== AVRecorderState.PREPARED) {
      return;
    }
    try {
      // [Start get_surface_id]
      let videoSurfaceId = await this.avRecorder.getInputSurface();
      // [End get_surface_id]
      this.output = cameraManager.createVideoOutput(this.videoProfile, videoSurfaceId);
    } catch (error) {
      Logger.error(TAG_LOG,
        `Failed to create the output instance. error code: ${error.code}`);
    }
  }

  setVideoProfile(cameraManager: camera.CameraManager, targetProfile: camera.Profile,
    device: camera.CameraDevice) {
    this.cameraPosition = device.cameraPosition;
    let cameraOutputCap: camera.CameraOutputCapability | undefined =
      cameraManager.getSupportedOutputCapability(device,
        camera.SceneMode.NORMAL_VIDEO);
    let videoProfilesArray: camera.VideoProfile[] | undefined = cameraOutputCap?.videoProfiles;
    if (videoProfilesArray?.length) {
      try {
        const displayRatio = targetProfile.size.width / targetProfile.size.height;
        const profileWidth = targetProfile.size.width;
        const videoProfile = videoProfilesArray
          .sort((a, b) => Math.abs(a.size.width - profileWidth) - Math.abs(b.size.width - profileWidth))
          .find(pf => {
            const pfDisplayRatio = pf.size.width / pf.size.height;
            return Math.abs(pfDisplayRatio - displayRatio) <= CameraConstant.PROFILE_DIFFERENCE &&
              pf.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP;
          });
        if (!videoProfile) {
          Logger.error(TAG_LOG, 'Failed to get video profile');
          return;
        }
        this.videoProfile = videoProfile;
      } catch (error) {
        Logger.error(TAG_LOG, `Failed to createPhotoOutput. error: ${JSON.stringify(error)}`);
      }
    }
  }
  // [End create_video_output]

  getCameraImageRotation(): camera.ImageRotation {
    return this.cameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT
      ? camera.ImageRotation.ROTATION_270
      : camera.ImageRotation.ROTATION_90
  }

  async setAVConfig() {
    // [Start create_file]
    let options: photoAccessHelper.CreateOptions = {
      title: Date.now().toString()
    };
    let accessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
    this.videoUri = await accessHelper.createAsset(photoAccessHelper.PhotoType.VIDEO, 'mp4', options);
    this.file = fileIo.openSync(this.videoUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    // [End create_file]

    // [Start av_profile]
    this.avProfile = {
      audioBitrate: 48000,
      audioChannels: 2,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      audioSampleRate: 48000,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      videoBitrate: 32000000,
      videoCodec: (this.qualityLevel === QualityLevel.HIGHER && this.cameraPosition === 0) ?
      media.CodecMimeType.VIDEO_HEVC : media.CodecMimeType.VIDEO_AVC,
      videoFrameWidth: this.videoProfile?.size.width,
      videoFrameHeight: this.videoProfile?.size.height,
      videoFrameRate: this.cameraPosition === 0 ? 60 : 30,
    }
    // [End av_profile]

    // [Start av_config]
    this.avConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_CAMCORDER,
      videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
      profile: this.avProfile,
      url: `fd://${this.file.fd}`,
      metadata: {
        videoOrientation: this.getCameraImageRotation().toString()
      }
    }
    // [End av_config]
  }

  // [Start get_data_gravity]
  getRealData(data: sensor.GravityResponse): number {
    let getDeviceDegree: number = 0;
    let x = data.x;
    let y = data.y;
    let z = data.z;
    // Determine if the device is approaching a vertical position (perpendicular to the ground)
    if ((x * x + y * y) * 3 < z * z) {
      return getDeviceDegree;
    } else {
      // Calculate the inverse tangent value
      let sd: Decimal = Decimal.atan2(y, -x);
      // Convert radian values to angle values;
      let sc: Decimal = Decimal.round(Number(sd) / 3.141592653589 * 180);
      // Adjust angle to be relative to vertical orientation
      getDeviceDegree = 90 - Number(sc);
      // Normalize angle to 0-360 degrees range
      getDeviceDegree = getDeviceDegree >= 0 ? getDeviceDegree % 360 : getDeviceDegree % 360 + 360;
    }
    return getDeviceDegree;
  }

  async getGravity(): Promise<number> {
    try {
      let isSupportedGravity: boolean = false;
      let data = await sensor.getSensorList();
      for (let i = 0; i < data.length; i++) {
        if (data[i].sensorId === sensor.SensorId.GRAVITY) {
          isSupportedGravity = true;
          break;
        }
      }
      if (isSupportedGravity === true) {
        const promise: Promise<number> = new Promise((resolve) => {
          sensor.once(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
            resolve(this.getRealData(data));
          });
        })
        return promise;
      } else {
        const promise: Promise<number> = new Promise((resolve) => {
          sensor.once(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
            resolve(this.getRealData(data as sensor.GravityResponse));
          });
        })
        return promise;
      }
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to getGravity and catch error is  ${error.message}`);
      return 0
    }
  }
  // [End get_data_gravity]

  // [Start get_video_rotation]
  getVideoRotation(deviceDegree: number): camera.ImageRotation {
    let videoRotation: camera.ImageRotation = this.getCameraImageRotation();
    try {
        videoRotation = this.output!.getVideoRotation(deviceDegree);
        Logger.info(TAG_LOG, `Video rotation is: ${videoRotation}`);
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to getVideoRotation and catch error is: ${error.message}`);
    }
    return videoRotation;
  }
  // [End get_video_rotation]

  async getVideoThumbnail() {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator();
      let dataSrc: media.AVFileDescriptor = {
        fd: this.file!.fd,
      };
      avImageGenerator.fdSrc = dataSrc;
      let timeUs = 0;
      let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
      let param: media.PixelMapParams = {
        width: 300,
        height: 300
      };
      pixelMap = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param);
      avImageGenerator.release();
    } catch (error) {
      Logger.info(TAG_LOG, `Failed to getVideoThumbnail and catch error is  ${error.message}`);
    }
    return pixelMap;
  }

  isRecording() {
    return this.state === AVRecorderState.STARTED || this.state === AVRecorderState.PAUSED;
  }


  // [Start set_video_stabilization]
  setVideoStabilizationMode(session: camera.VideoSession): boolean {
    let mode: camera.VideoStabilizationMode = camera.VideoStabilizationMode.AUTO;
    // Check whether video stabilization is supported
    let isSupported: boolean = session.isVideoStabilizationModeSupported(mode);
    if (!isSupported) {
      Logger.info(TAG_LOG, `videoStabilizationMode: ${mode} is not support`);
      return false;
    }
    Logger.info(TAG_LOG, `setVideoStabilizationMode: ${mode}`);
    // Set video stabilization
    session.setVideoStabilizationMode(mode);
    let activeVideoStabilizationMode = session.getActiveVideoStabilizationMode();
    Logger.info(TAG_LOG, `activeVideoStabilizationMode: ${activeVideoStabilizationMode}`);
    return isSupported;
  }
  // [End set_video_stabilization]

  // [Start set_video_color_space]
  getSupportedColorSpaces(session: camera.VideoSession): Array<colorSpaceManager.ColorSpace> {
    let colorSpaces: colorSpaceManager.ColorSpace[] = [];
    try {
      colorSpaces = session.getSupportedColorSpaces();
    } catch (error) {
      Logger.error(TAG_LOG, `The getSupportedColorSpaces call failed. error code: ${error.message}`);
    }
    return colorSpaces;
  }

  setColorSpaceAfterCommitConfig(session: camera.VideoSession, isHdr: boolean): void {
    let colorSpace: colorSpaceManager.ColorSpace =
      isHdr ? colorSpaceManager.ColorSpace.BT2020_HLG_LIMIT : colorSpaceManager.ColorSpace.BT709_LIMIT;
    let colorSpaces: colorSpaceManager.ColorSpace[] = this.getSupportedColorSpaces(session);
    if (!colorSpaces.includes(colorSpace)) {
      Logger.info(TAG_LOG, `colorSpace: ${colorSpace} is not support`);
      return;
    }
    Logger.info(TAG_LOG, `setColorSpace: ${colorSpace}`);
    session.setColorSpace(colorSpace);
    try {
      let activeColorSpace: colorSpaceManager.ColorSpace = session.getActiveColorSpace();
      Logger.info(TAG_LOG, `activeColorSpace: ${activeColorSpace}`);
    } catch (error) {
      Logger.error(TAG_LOG, `getActiveColorSpace Faild: ${error.message}`);
    }
  }
  // [Start set_video_color_space]
}