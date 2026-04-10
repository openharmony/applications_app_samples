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
 
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import image from '@ohos.multimedia.image';


export const CACHE_ALBUM_MIN_WIDTH = 1920

export const DEFAULT_ALBUM_WIDTH = 640

@Observed
export class PhotoModel {
  public uri: string = '';
  public displayName: string = '';
  public dateAdded: number = 0;
  public duration?: number;
  public dateTrashed?: number;
  public photoType?: photoAccessHelper.PhotoType;
  public thumbnail?: image.PixelMap;
  public imageUri?: string;
  public width?: number;
  public height?: number;
  public photoAsset?: photoAccessHelper.PhotoAsset;
  public remoteUri?: string;
  public size?: number
  public photoTag?: string
  public pickVideoPreview?: string;
  constructor() {
  }
}

@Observed
export class AlbumModel {
  public type: AlbumType
  public name: ResourceStr = ''
  public count: number = 0
  public cover?: PixelMap | ResourceStr | DrawableDescriptor

  constructor(type: AlbumType, name: ResourceStr) {
    this.type = type;
    this.name = name;
  }
}

@Observed
export class PhotoGroupModel {
  public createTime: number = 0
  public photoList: PhotoModel[] = []
}

export class PhotoPosition {
  public groupIndex: number = 0
  public rowIndex: number = 0
  public columIndex: number = 0

  constructor(groupIndex: number, rowIndex: number, columIndex: number) {
    this.groupIndex = groupIndex;
    this.rowIndex = rowIndex;
    this.columIndex = columIndex;
  }
}

export enum AlbumType {
  ALL,
  FAVORITE,
  SCREENSHOT,
  TRASH,
  NAS_SESSION,
  NAS_CLIENT
}

export interface AlbumMenuModel {
  uri: string,
  name: string,
}

export interface DialogModel {
  uri: string,
  name: Resource,
}
