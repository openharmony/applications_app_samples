/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { getResourceString } from '../utils/ResourceUtils';

const TAG = 'UserFileDataHelper';

export class Rotatable {
  rotatable: boolean;
  orientation: number;
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
  } else if (name === MediaConstants.ALBUM_ID_MOVING_PHOTO) {
    return await getResourceString($r('app.string.album_moving_photo'));
  }
  return null;
}

export async function getSystemAlbumDisplayName(): Promise<string[]> {
  let albumNames = [];
  albumNames.push(await getResourceString($r('app.string.album_all')));
  albumNames.push(await getResourceString($r('app.string.album_video')));
  albumNames.push(await getResourceString($r('app.string.album_recycle')));
  albumNames.push(await getResourceString($r('app.string.album_camera')));
  albumNames.push(await getResourceString($r('app.string.album_favor')));
  albumNames.push(await getResourceString($r('app.string.album_remote_device')));
  albumNames.push(await getResourceString($r('app.string.album_screen_shot')));
  albumNames.push(await getResourceString($r('app.string.album_moving_photo')));
  return albumNames;
}