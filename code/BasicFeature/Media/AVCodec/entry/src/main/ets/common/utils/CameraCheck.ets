/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import Logger from './Logger';
import { CameraDataModel } from '../../model/CameraDateModel';
import { CommonConstants as Const } from '../CommonConstants';

const TAG = 'CAMERA_CHECK';

function getPreviewProfile(previewProfiles: camera.Profile[], size: camera.Size,
  isHDRVivid: number): undefined | camera.Profile {
  let previewProfile: undefined | camera.Profile = previewProfiles.find((profile: camera.Profile) => {
    const resolutionMatch = profile.size.width === size.width && profile.size.height === size.height;

    if (!resolutionMatch) {
      return;
    }
    if (isHDRVivid) {
      return profile.format === camera.CameraFormat.CAMERA_FORMAT_YCRCB_P010 && resolutionMatch;
    } else {
      return profile.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP && resolutionMatch;
    }
  });
  return previewProfile;
}

function setFirstPreviewProfile(previewProfiles: camera.Profile[]) {
  return previewProfiles[0];
}

export function previewProfileCameraCheck(cameraManager: camera.CameraManager,
  cameraData: CameraDataModel): undefined | camera.Profile {
  let cameraDevices = cameraManager.getSupportedCameras();
  if (cameraDevices !== undefined && cameraDevices.length <= 0) {
    Logger.error(TAG, 'cameraManager.getSupportedCameras error!');
    return;
  }

  let profiles: camera.CameraOutputCapability =
    cameraManager.getSupportedOutputCapability(cameraDevices[0], camera.SceneMode.NORMAL_VIDEO);
  if (!profiles) {
    Logger.error(TAG, 'cameraManager.getSupportedOutputCapability error!');
    return;
  }

  let previewProfilesArray: camera.Profile[] = profiles.previewProfiles;
  if (!previewProfilesArray) {
    Logger.error('createOutput previewProfilesArray == null || undefined');
    return;
  }

  let videoSize: camera.Size = {
    width: 1920,
    height: 1080
  }
  let previewProfile: undefined | camera.Profile =
    getPreviewProfile(previewProfilesArray, videoSize, cameraData.isHDRVivid);
  if (!previewProfile) {
    Logger.error('previewProfile is not found, set to first profile');
    previewProfile = setFirstPreviewProfile(previewProfilesArray);
    return previewProfile;
  }
  return previewProfile;
}

export function setFirstCameraProfile(cameraManager: camera.CameraManager) {
  let cameraDevices = cameraManager.getSupportedCameras();
  if (cameraDevices !== undefined && cameraDevices.length <= 0) {
    Logger.error(TAG, 'cameraManager.getSupportedCameras error!');
    return;
  }

  let profiles: camera.CameraOutputCapability =
    cameraManager.getSupportedOutputCapability(cameraDevices[0], camera.SceneMode.NORMAL_VIDEO);
  if (!profiles) {
    Logger.error(TAG, 'cameraManager.getSupportedOutputCapability error!');
    return;
  }

  let encoderProfiles: camera.VideoProfile[] = profiles.videoProfiles;
  if (!encoderProfiles) {
    Logger.error(TAG, 'Get encoderProfiles error!');
    return;
  }
  return encoderProfiles[0];
}

export function encoderProfileCameraCheck(cameraManager: camera.CameraManager,
  cameraData: CameraDataModel): undefined | camera.VideoProfile {
  let cameraDevices = cameraManager.getSupportedCameras();
  if (cameraDevices !== undefined && cameraDevices.length <= 0) {
    Logger.error(TAG, 'cameraManager.getSupportedCameras error!');
    return;
  }

  let profiles: camera.CameraOutputCapability =
    cameraManager.getSupportedOutputCapability(cameraDevices[0], camera.SceneMode.NORMAL_VIDEO);
  if (!profiles) {
    Logger.error(TAG, 'cameraManager.getSupportedOutputCapability error!');
    return;
  }

  let encoderProfiles: camera.VideoProfile[] = profiles.videoProfiles;
  if (!encoderProfiles) {
    Logger.error(TAG, 'Get encoderProfiles error!');
    return;
  }
  if (cameraData.format == camera.CameraFormat.CAMERA_FORMAT_RGBA_8888) {
    return encoderProfiles[0];
  }
  let encoderProfile: undefined | camera.VideoProfile = encoderProfiles.find((profile: camera.VideoProfile) => {
    const resolutionMatch =
      profile.size.width === cameraData.cameraWidth &&
        profile.size.height === cameraData.cameraHeight;

    if (!resolutionMatch) {
      return;
    }
    if (cameraData.isHDRVivid) {
      if (cameraData.frameRate === Const.FRAMERATE_VIDEO_30FPS) {
        return resolutionMatch &&
          profile.format === camera.CameraFormat.CAMERA_FORMAT_YCBCR_P010 &&
          profile.frameRateRange.min === 1 &&
          profile.frameRateRange.max === 30;
      } else {
        return resolutionMatch &&
          profile.format === camera.CameraFormat.CAMERA_FORMAT_YCBCR_P010 &&
          profile.frameRateRange.min === cameraData.frameRate &&
          profile.frameRateRange.max === cameraData.frameRate;
      }
    } else {
      if (cameraData.frameRate === Const.FRAMERATE_VIDEO_30FPS) {
        return resolutionMatch &&
          profile.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP &&
          profile.frameRateRange.min === 1 &&
          profile.frameRateRange.max === 30;
      } else {
        return resolutionMatch &&
          profile.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP &&
          profile.frameRateRange.min === cameraData.frameRate &&
          profile.frameRateRange.max === cameraData.frameRate;
      }
    }
  });
  return encoderProfile;
}