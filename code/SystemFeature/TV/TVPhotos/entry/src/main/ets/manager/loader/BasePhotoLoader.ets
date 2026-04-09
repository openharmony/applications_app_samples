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
import { AlbumModel, AlbumType, PhotoModel } from '../../models/PhotoModel';
import { ILoader } from './ILoader';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import Logger from '../../common/Logger';
import { fileModelsEquals, getThumbByUri } from './LoadUtil';
import { image } from '@kit.ImageKit';
import { common, Context } from '@kit.AbilityKit';
import { deviceInfo } from '@kit.BasicServicesKit';

const REGISTER_CALLBACK_DELAY = 200

export abstract class BasePhotoLoader implements ILoader<PhotoModel> {
  private albumModel: AlbumModel = new AlbumModel(AlbumType.ALL, $r('app.string.album_name_all'));
  private fileAssets: PhotoModel[] = []
  public context?: common.UIAbilityContext
  private callbacks: Array<(photos: PhotoModel[], albumAllPhoto: AlbumModel) => void> = []
  private refreshing = false

  abstract getAlbumModel(): AlbumModel

  abstract getTag(): string

  init(context: common.UIAbilityContext): void {
    Logger.info(this.getTag(), 'do init ');
    this.context = context
    this.albumModel = this.getAlbumModel()
    this.refresh()
  }


  registerChangeCallback(callback: (photos: PhotoModel[], albumAllPhoto: AlbumModel) => void): void {
    Logger.info(this.getTag(), 'registerChangeCallback ');
    this.callbacks.push(callback)
    setTimeout(() => {
      callback(this.fileAssetsCopy(), this.albumModel)
    }, REGISTER_CALLBACK_DELAY)
  };

  unRegisterChangeCallback(callback: (photos: PhotoModel[], albumAllPhoto: AlbumModel) => void): void {
    Logger.info(this.getTag(), 'unRegisterChangeCallback ');
    this.callbacks = this.callbacks.filter((cb) => {
      return (cb !== callback)
    })
  };

  async onFileAssetChange() {
    this.albumModel.count = this.fileAssets.length;
    let temporaryArray: PhotoModel[] = [];

    if (this.albumModel.count > 0) {
      const filteredArray = [...this.fileAssets].filter(
        (item: PhotoModel) => !item.displayName.startsWith('PRESET_')
      );

      temporaryArray = filteredArray.length > 0
        ? filteredArray
        : [...this.fileAssets].filter(item => item.displayName.startsWith('PRESET_'));

      if (temporaryArray.length > 0) {
        temporaryArray.reverse();
        this.albumModel.cover = await getThumbByUri(
          this.context as Context,
          temporaryArray[0],
          'loader_' + this.getTag()
        );
      } else {
        this.albumModel.cover = undefined;
      }
    } else {
      this.albumModel.cover = undefined;
    }

    Logger.info(this.getTag(), 'albumModel = ' + JSON.stringify(this.albumModel));
    Logger.info(this.getTag(), 'fileAssets = ' + JSON.stringify(this.fileAssets.map(value => value.uri)));

    this.callbacks.forEach((callback) => {
      callback(this.fileAssetsCopy(), this.albumModel);
    });
  }

  fileAssetsCopy(): PhotoModel[] {
    const copy: PhotoModel[] = []
    copy.push(...this.fileAssets)
    return copy
  }

  async delete(photos: PhotoModel[]): Promise<void> {
    Logger.info(this.getTag(), 'do delete ' + JSON.stringify(photos));

    await this.doDelete(photos)
    for (let index = 0; index < photos.length; index++) {
      const i = this.fileAssets.findIndex((asset) => {
        return (asset.uri === photos[index].uri)
      })
      this.fileAssets.splice(i, 1)
    }
    this.onFileAssetChange()
  };

  doDelete(photos: PhotoModel[]): Promise<void> {
    let uris: string[] = photos.map(photo => photo.uri)
    return photoAccessHelper.MediaAssetChangeRequest.deleteAssets(this.context, [...uris])
  }

  async refresh(): Promise<void> {
    Logger.info(this.getTag(), 'do refresh ' + this.refreshing);
    if (!this.refreshing) {
      this.refreshing = true
      try {
        let newFileAssets = await this.getMediaItems(this.context!!)
        await this.refreshData(newFileAssets, false)
      } catch (e) {
        Logger.error(this.getTag(), 'do refresh ' + JSON.stringify(e));
      }
      this.refreshing = false
    }
  }

  destroy(): void {
    Logger.info(this.getTag(), 'do destroy ');
  }

  async recover(photos: PhotoModel[]): Promise<void> {
    await this.doRecover(photos)
    for (let index = 0; index < photos.length; index++) {
      const i = this.fileAssets.findIndex((asset) => {
        return (asset.uri === photos[index].uri)
      })
      this.fileAssets.splice(i, 1)
    }
    this.onFileAssetChange()
  }

  async doRecover(photos: PhotoModel[]): Promise<void> {

  }

  async refreshData(photos: PhotoModel[], force: boolean) {
    Logger.info(this.getTag(), 'do refreshData ');
    let needUpdate = force
    if (!force) {
      needUpdate = !fileModelsEquals(this.fileAssets, photos)
    }
    Logger.info(this.getTag(), 'need update ' + photos.length + '  ' + needUpdate);

    if (needUpdate) {
      for (let index = 0; index < photos.length; index++) {
        let model = this.fileAssets.find((oldModel) => {
          return (oldModel.uri === photos[index].uri)
        })

        if (model) {
          photos[index] = model
        } else {
          photos[index] = await this.createFullModel(photos[index])
        }
      }
      this.fileAssets = photos
      this.onFileAssetChange()
    }
  }

  // 获取照片和视频
  abstract getMediaItems(context: Context): Promise<PhotoModel[]>

  async getThumb(photoAsset: photoAccessHelper.PhotoAsset) {
    let thumbnail: image.PixelMap | undefined = undefined;
    try {
      thumbnail = await photoAsset.getThumbnail();
    } catch (err) {
      Logger.error(this.getTag(), 'getAlbumsNextPhoto get thumbnail failed with err: ' + err);
    }
    return thumbnail
  }

  async createFullModel(photo: PhotoModel): Promise<PhotoModel> {
    if (photo.photoAsset) {
      photo.photoType = photo.photoAsset.photoType
      if (deviceInfo.sdkApiVersion > 11) {
        photo.duration = photo.photoAsset.get(photoAccessHelper.PhotoKeys.DURATION) as number
        photo.dateAdded = photo.photoAsset.get(photoAccessHelper.PhotoKeys.DATE_DAY) as number
        photo.dateTrashed = photo.photoAsset.get(photoAccessHelper.PhotoKeys.DATE_TRASHED_MS) as number
        photo.width = photo.photoAsset.get(photoAccessHelper.PhotoKeys.WIDTH) as number
        photo.height = photo.photoAsset.get(photoAccessHelper.PhotoKeys.HEIGHT) as number
      } else {
        photo.duration = 0
        photo.dateAdded = 0
        photo.dateTrashed = 0
        photo.width = 0
        photo.height = 0
      }
    }
    return photo
  }
}