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

import { ItemDataSource } from '../common/ItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem'
import { Broadcast } from '../common/Broadcast'
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

export class MenuContext {
  items: UserFileDataItem[] = [];
  dataSource: ItemDataSource;

  albumInfo: SimpleAlbumDataItem;

  albumObject: photoAccessHelper.Album;

  broadCast: Broadcast;
  onOperationStart: Function;
  onOperationCancel: Function;
  onOperationEnd: Function;

  jumpSourceToMain: number;
  deviceId: string;

  albumId: string;
  deletePageFromType: number; // 0. photoBrowser  1. photoGridPage

  withDeletePageFromType(deletePageFromType: number): MenuContext {
    this.deletePageFromType = deletePageFromType;
    return this;
  }

  withItems(items: UserFileDataItem[]): MenuContext {
    this.items = items;
    return this;
  }

  withAlbumId(albumId: string): MenuContext {
    this.albumId = albumId;
    return this;
  }

  withAlbumObject(albumObject: photoAccessHelper.Album): MenuContext {
    this.albumObject = albumObject;
    return this;
  }

  withDataSource(dataSource): MenuContext {
    this.dataSource = dataSource;
    return this;
  }

  withOperationStartCallback(onOperationStart: Function): MenuContext {
    this.onOperationStart = onOperationStart;
    return this;
  }

  withOperationEndCallback(onOperationEnd: Function): MenuContext {
    this.onOperationEnd = onOperationEnd;
    return this;
  }

  withOperationCancelCallback(onOperationCancel: Function): MenuContext {
    this.onOperationCancel = onOperationCancel;
    return this;
  }

  withBroadCast(param: Broadcast): MenuContext {
    this.broadCast = param;
    return this;
  }

  withJumpSourceToMain(jumpSourceToMain: number): MenuContext {
    this.jumpSourceToMain = jumpSourceToMain;
    return this;
  }

  withRemoteDevice(deviceId): MenuContext {
    this.deviceId = deviceId;
    return this;
  }

  withAlbumInfo(albumInfo: SimpleAlbumDataItem): MenuContext {
    this.albumInfo = albumInfo;
    return this;
  }
}