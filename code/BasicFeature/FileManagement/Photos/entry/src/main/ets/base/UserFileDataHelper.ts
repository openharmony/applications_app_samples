/*
 * Copyright (c) 2022 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import image from '@ohos.multimedia.image';
import userFileManager from '@ohos.filemanagement.userFileManager';
import { userFileModel } from './UserFileModel';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { getResourceString } from '../utils/ResourceUtils';

const TAG = 'UserFileDataHelper'

export class Rotatable {
  rotatable: boolean
  orientation: number
}

export async function setOrientation(fileAsset: userFileManager.FileAsset, orientation: number): Promise<void> {
  Log.info(TAG, 'setOrientation')
  try {
    let fd: number = await userFileModel.openAsset('RW', fileAsset);
    let imageSourceApi: image.ImageSource = image.createImageSource(fd);
    await imageSourceApi.modifyImageProperty('Orientation', getPropertyValidOrientation(orientation));
    imageSourceApi.release();
    userFileModel.closeAsset(fd, fileAsset);
  } catch (err) {
    Log.error(TAG, 'setOrientation err ' + JSON.stringify(err));
    try {
      fileAsset.set(userFileManager.ImageVideoKey.ORIENTATION.toString(), orientation.toString());
      await fileAsset.commitModify();
    } catch (err) {
      Log.error(TAG, 'setOrientation err ' + JSON.stringify(err));
    }
  }
}

function getPropertyValidOrientation(orientation: number): string {
  Log.info(TAG, 'getPropertyValidOrientation ' + orientation);
  if (orientation === MediaConstants.ROTATE_NONE) {
    return '1';
  } else if (orientation === MediaConstants.ROTATE_THIRD) {
    return '8';
  } else if (orientation === MediaConstants.ROTATE_TWICE) {
    return '3';
  } else if (orientation === MediaConstants.ROTATE_ONCE) {
    return '6';
  }
  return '';
}

export async function getAlbumDisplayName(name: string): Promise<string> {
  if (name === MediaConstants.ALBUM_ID_ALL) {
    return await getResourceString($r('app.string.album_all'));
  } else if (name === MediaConstants.ALBUM_ID_VIDEO) {
    return await getResourceString($r('app.string.album_video'));
  } else if (name === MediaConstants.ALBUM_ID_RECYCLE) {
    return await getResourceString($r('app.string.album_recycle'));
  } else if (name === MediaConstants.ALBUM_ID_CAMERA) {
    return await getResourceString($r('app.string.album_camera'));
  } else if (name === MediaConstants.ALBUM_ID_FAVOR) {
    return await getResourceString($r('app.string.album_favor'));
  } else if (name === MediaConstants.ALBUM_ID_REMOTE) {
    return await getResourceString($r('app.string.album_remote_device'));
  } else if (name === MediaConstants.ALBUM_ID_SNAPSHOT) {
    return await getResourceString($r('app.string.album_screen_shot'));
  }
  return null;
}