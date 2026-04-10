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
 
import { AlbumModel, AlbumType, PhotoModel } from '../../models/PhotoModel';
import { SubTypeLoader } from './SubTypeLoader';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG = 'PHOTOM_TrashPhotoLoader'

export class TrashPhotoLoader extends SubTypeLoader {
  getTag(): string {
    return TAG
  }

  getAlbumModel(): AlbumModel {
    return new AlbumModel(AlbumType.TRASH, $r('app.string.album_name_trash'))
  }

  getSubType(): photoAccessHelper.AlbumSubtype {
    return photoAccessHelper.AlbumSubtype.TRASH
  }

  //清空回收站
  async doDelete(photos: PhotoModel[]): Promise<void> {
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
    let fetchResult =
      await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.TRASH);
    let trashAlbum = await fetchResult.getFirstObject();
    let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
      new photoAccessHelper.MediaAlbumChangeRequest(trashAlbum);
    albumChangeRequest.deleteAssets(photos.map(v => v.photoAsset));
    await phAccessHelper.applyChanges(albumChangeRequest);
  }

  async doRecover(photos: PhotoModel[]) {
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
    let fetchResult =
      await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.TRASH);
    let trashAlbum = await fetchResult.getFirstObject();
    let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
      new photoAccessHelper.MediaAlbumChangeRequest(trashAlbum);
    albumChangeRequest.recoverAssets(photos.map(v => v.photoAsset));
    await phAccessHelper.applyChanges(albumChangeRequest);
  }
}
