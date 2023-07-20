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

export class SimpleAlbumDataItem {
  readonly id: string;
  readonly displayName: string;
  readonly uri: string; //as uri
  readonly deviceId: string;
  readonly deviceName: string;
  readonly albumType: number;
  readonly albumSubType: number;

  constructor(id: string, displayName: string, uri: string, deviceId: string, deviceName: string, albumType: number, albumSubType: number) {
    this.id = id;
    this.displayName = displayName;
    this.uri = uri;
    this.deviceId = deviceId;
    this.deviceName = deviceName;
    this.albumType = albumType;
    this.albumSubType = albumSubType;
  }
}