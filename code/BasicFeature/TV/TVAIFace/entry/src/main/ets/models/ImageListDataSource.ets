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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';

class ImageInfo {
  public fileAsset?: ResourceStr | photoAccessHelper.PhotoAsset; // 媒体文件的FileAsset,应该是资源类型
  public uri?: ResourceStr = ''; //媒体文件的uri,应该是资源类型不是any类型
  public name?: string = '';
  public type?: string = '';
  public smallImg?: image.PixelMap;
}

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: ImageInfo[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): ImageInfo {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    });
  }
}


class ImageListDataSource extends BasicDataSource {
  private dataArray: ImageInfo[] = [];

  public totalCount(): number {
    console.log('aidemo this.dataArray.length', this.dataArray.length);
    return this.dataArray.length;
  }

  public getData(index: number): ImageInfo {
    return this.dataArray[index];
  }

  public addData(index: number, data: ImageInfo): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ImageInfo): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public reloadData(data: ImageInfo[]): void {
    this.dataArray = data;
    this.notifyDataReload();
  }
}

export {
  ImageListDataSource
};