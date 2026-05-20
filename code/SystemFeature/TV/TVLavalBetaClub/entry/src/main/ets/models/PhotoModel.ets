/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
  uri: string = '';
  displayName: string = '';
  dateAdded: number = 0;
  duration?: number;
  dateTrashed?: number;
  photoType?: photoAccessHelper.PhotoType;
  thumbnail?: image.PixelMap;
  imageUri?: string;
  width?: number;
  height?: number;
  photoAsset?: photoAccessHelper.PhotoAsset

  constructor() {
  }
}

@Observed
export class AlbumModel {
  type: AlbumType
  name: ResourceStr = ''
  count: number = 0
  cover?: PixelMap | ResourceStr | DrawableDescriptor

  constructor(type: AlbumType, name: ResourceStr) {
    this.type = type;
    this.name = name;
  }
}

@Observed
export class PhotoGroupModel {
  createTime: number = 0
  photoList: PhotoModel[] = []
}

export class PhotoPosition {
  groupIndex: number = 0
  rowIndex: number = 0
  columIndex: number = 0

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
  TRASH
}

export interface AlbumMenuModel {
  uri: string,
  name: string,
}

export interface DialogModel {
  uri: string,
  name: Resource,
}

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

export class PhotoGroupDataSource extends BasicDataSource<PhotoModel> {
  private dataArray: PhotoModel[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): PhotoModel {
    return this.dataArray[index];
  }

  public getAllData(): PhotoModel[] {
    return this.dataArray;
  }

  public addData(index: number, data: PhotoModel): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public setData(dataList: PhotoModel[]) {
    this.dataArray = dataList;
    this.notifyDataReload();
  }

  public pushData(data: PhotoModel): void {
    this.dataArray.unshift(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public clearData(): PhotoModel[] {
    this.dataArray.splice(0, this.totalCount());
    this.notifyDataReload();
    return [];
  }
}
