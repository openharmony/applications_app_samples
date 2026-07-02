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
import { AlbumType, PhotoModel } from '../models/PhotoModel';
import { AllPhotoLoader } from './loader/AllPhotoLoader';
import { ILoader } from './loader/ILoader';
import { common } from '@kit.AbilityKit';
import LogManager from '../common/Log/LogManager';

const TAG = 'PHOTOM_manager';

class PhotoManager {
  public loadRecord: Map<AlbumType, ILoader> = new Map();
  public inited = false;

  public init(context: common.UIAbilityContext) {
    if (this.inited) {
      return;
    }
    LogManager.hilogIWithTag(TAG, 'do init ');
    this.inited = true;
    this.loadRecord.set(AlbumType.ALL, new AllPhotoLoader());
    this.loadRecord.forEach((value) => {
      value.init(context);
    });
  }

  public refresh(albumType?: AlbumType) {
    this.loadRecord.forEach((loader) => {
      loader.refresh();
    });
  }

  public getLoader(albumType: AlbumType): ILoader | undefined {
    return this.loadRecord.get(albumType);
  }

  public async delete(albumType: AlbumType, photos: PhotoModel[]): Promise<void> {
    LogManager.hilogIWithTag(TAG, `do delete type = ${albumType}  modles = ${JSON.stringify(photos)}`);
    try {
      if (albumType === AlbumType.TRASH) {
        this.getLoader(AlbumType.TRASH)?.delete(photos);
      } else {
        await this.getLoader(albumType)?.delete(photos);
        this.loadRecord.forEach((loader) => {
          loader.refresh();
        });
      }
    } catch (e) {
      LogManager.hilogEWithTag(TAG, `do delete fail = ${JSON.stringify(e)}`);
    }
  }

  async recoverTrash(photos: PhotoModel[]) {
    await this.getLoader(AlbumType.TRASH)?.recover(photos);
    this.refresh();
  }

  public destroy() {
    this.loadRecord.forEach((loader) => {
      loader.destroy();
    });
  }
}

let photoManager = new PhotoManager();

export default photoManager;