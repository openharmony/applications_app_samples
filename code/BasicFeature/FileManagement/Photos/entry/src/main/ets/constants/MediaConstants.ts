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

import photoAccessHelper from '@ohos.file.photoAccessHelper';

export class MediaConstants {
  // Media item status
  static readonly UNDEFINED = 0;
  static readonly PART_LOADED = 1
  static readonly LOADED = 2;
  static readonly TRASHED = 3;
  // Media type
  static readonly MEDIA_TYPE_IMAGE: string = 'image';
  static readonly MEDIA_TYPE_VIDEO: string = 'video';
  static readonly MEDIA_TYPE_ALBUM: string = 'album';
  static readonly MEDIA_TYPE_DEVICE: string = 'device';
  static readonly MEDIA_TYPE_REMOTE: string = 'remote';

  static readonly DEVICE_STATE_ONLINE: string = 'online';
  static readonly DEVICE_STATE_OFFLINE: string = 'offline';
  static readonly DEVICE_STATE_CHANGE: string = 'change';
  static readonly ROTATE_NONE = 0;
  static readonly ROTATE_ONCE = 90;
  static readonly ROTATE_TWICE = 180;
  static readonly ROTATE_THIRD = 270;
  static readonly ROTATE_AROUND = 360;
  static readonly DEFAULT_SIZE = 256;
  static readonly DEFAULT_THUMBNAIL_SIZE = 1920;
  // select type
  static readonly SELECT_TYPE_ALL = 0;
  static readonly SELECT_TYPE_VIDEO = 1;
  static readonly SELECT_TYPE_IMAGE = 2;
  //album type
  static readonly ALBUM_TYPE_ALL = -1;
  static readonly ABSTRACT_ALBUM_TYPE_MOVING_PHOTO = -2;
  static readonly ALBUM_TYPE_USER = photoAccessHelper.AlbumType.USER;
  static readonly ALBUM_TYPE_SYSTEM = photoAccessHelper.AlbumType.SYSTEM;
  // album subtype
  static readonly ALBUM_SUBTYPE_ALL = photoAccessHelper.AlbumSubtype.ANY
  static readonly ALBUM_SUBTYPE_CAMERA = photoAccessHelper.AlbumSubtype.CAMERA;
  static readonly ALBUM_SUBTYPE_VIDEO = photoAccessHelper.AlbumSubtype.VIDEO;
  static readonly ALBUM_SUBTYPE_RECYCLE = photoAccessHelper.AlbumSubtype.TRASH;
  static readonly ALBUM_SUBTYPE_FAVOR = photoAccessHelper.AlbumSubtype.FAVORITE;
  static readonly ALBUM_SUBTYPE_SNAPSHOT = photoAccessHelper.AlbumSubtype.SCREENSHOT;
  static readonly ALBUM_SUBTYPE_HIDDEN = photoAccessHelper.AlbumSubtype.HIDDEN;
  static readonly ALBUM_SUBTYPE_USER_GENERIC = photoAccessHelper.AlbumSubtype.USER_GENERIC;
  static readonly ALBUM_SUBTYPE_REMOTE = -1;
  // album id
  static readonly ALBUM_ID_USER = 'default_user';
  static readonly ALBUM_ID_ALL = 'default_all';
  static readonly ALBUM_ID_HIDDEN = 'default_hidden';
  static readonly ALBUM_ID_CAMERA = 'default_camera';
  static readonly ALBUM_ID_VIDEO = 'default_video';
  static readonly ALBUM_ID_RECYCLE = 'default_recycle';
  static readonly ALBUM_ID_FAVOR = 'default_favor';
  static readonly ALBUM_ID_SNAPSHOT = 'default_snapshot';
  static readonly ALBUM_ID_REMOTE = 'default_remote';
  static readonly ALBUM_ID_MOVING_PHOTO = 'default_moving_photo';
  static readonly ALBUM_DISABLE_COPY_LIST: Set<string> = new Set<string>([
  MediaConstants.ALBUM_ID_ALL,
  MediaConstants.ALBUM_ID_VIDEO,
  MediaConstants.ALBUM_ID_RECYCLE,
  MediaConstants.ALBUM_ID_FAVOR,
  MediaConstants.ALBUM_ID_CAMERA,
  MediaConstants.ALBUM_ID_SNAPSHOT,
  MediaConstants.ALBUM_ID_MOVING_PHOTO
  ] as string[]);
  static readonly ALBUM_DISABLE_DELETE_LIST: Set<string> = new Set<string>([
  MediaConstants.ALBUM_ID_ALL,
  MediaConstants.ALBUM_ID_CAMERA,
  MediaConstants.ALBUM_ID_VIDEO,
  MediaConstants.ALBUM_ID_RECYCLE,
  MediaConstants.ALBUM_ID_FAVOR,
  MediaConstants.ALBUM_ID_SNAPSHOT,
  MediaConstants.ALBUM_ID_MOVING_PHOTO
  ] as string[]);
  static readonly ALBUM_DISABLE_NEW_LIST: Set<string> = new Set<string>([
  MediaConstants.ALBUM_ID_ALL,
  MediaConstants.ALBUM_ID_CAMERA,
  MediaConstants.ALBUM_ID_VIDEO,
  MediaConstants.ALBUM_ID_RECYCLE,
  MediaConstants.ALBUM_ID_FAVOR,
  MediaConstants.ALBUM_ID_SNAPSHOT,
  MediaConstants.ALBUM_ID_MOVING_PHOTO
  ] as string[]);
  static readonly ALBUM_DISABLE_RENAME_LIST: Set<string> = new Set<string>([
  MediaConstants.ALBUM_ID_ALL,
  MediaConstants.ALBUM_ID_CAMERA,
  MediaConstants.ALBUM_ID_VIDEO,
  MediaConstants.ALBUM_ID_RECYCLE,
  MediaConstants.ALBUM_ID_FAVOR,
  MediaConstants.ALBUM_ID_SNAPSHOT,
  MediaConstants.ALBUM_ID_MOVING_PHOTO
  ] as string[]);
  static readonly ALBUM_DEFAULT_SORT_LIST: string[] = [
  MediaConstants.ALBUM_ID_ALL,
  MediaConstants.ALBUM_ID_CAMERA,
  MediaConstants.ALBUM_ID_VIDEO,
  MediaConstants.ALBUM_ID_SNAPSHOT,
  MediaConstants.ALBUM_ID_MOVING_PHOTO,
  MediaConstants.ALBUM_ID_FAVOR
  ];
  static readonly CAMERA_ALBUM_PATH = 'Camera'
  static readonly REMOTE_ALBUM_PATH = 'FromOtherDevices'
  static readonly SNAPSHOT_ALBUM_PATH = 'Screenshots'
  static readonly PHOTO_SUBTYPE = photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString();
  static readonly MOVING_PHOTO = photoAccessHelper.PhotoSubtype.MOVING_PHOTO;

  // 需要过滤的媒体文件类型
  static readonly FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';
  static readonly FILTER_MEDIA_TYPE_IMAGE: string = 'FILTER_MEDIA_TYPE_IMAGE';
  static readonly FILTER_MEDIA_TYPE_VIDEO: string = 'FILTER_MEDIA_TYPE_VIDEO';
  //TODO delete
  static readonly DIR_CAMERA = 0
  static readonly DIR_VIDEO = 1
  static readonly DIR_IMAGE = 2
  static readonly DIR_AUDIO = 3
  static readonly DIR_DOCUMENTS = 4
  static readonly DIR_DOWNLOAD = 5
  static readonly EMPTY_FETCH_COLUMNS = []
  static readonly FILE_ASSET_FETCH_COLUMNS = [photoAccessHelper.PhotoKeys.URI,
  photoAccessHelper.PhotoKeys.PHOTO_TYPE,
  photoAccessHelper.PhotoKeys.DISPLAY_NAME,
  photoAccessHelper.PhotoKeys.SIZE,
  photoAccessHelper.PhotoKeys.DATE_ADDED,
  photoAccessHelper.PhotoKeys.DATE_MODIFIED,
  photoAccessHelper.PhotoKeys.DURATION,
  photoAccessHelper.PhotoKeys.WIDTH,
  photoAccessHelper.PhotoKeys.HEIGHT,
  photoAccessHelper.PhotoKeys.DATE_TAKEN,
  photoAccessHelper.PhotoKeys.ORIENTATION,
  photoAccessHelper.PhotoKeys.FAVORITE,
  photoAccessHelper.PhotoKeys.TITLE,
  photoAccessHelper.PhotoKeys.POSITION,
  photoAccessHelper.PhotoKeys.DATE_TRASHED,
  photoAccessHelper.PhotoKeys.HIDDEN]
  static readonly ALBUM_ASSET_FETCH_COLUMNS = [photoAccessHelper.AlbumKeys.URI, photoAccessHelper.AlbumKeys.ALBUM_NAME]
}