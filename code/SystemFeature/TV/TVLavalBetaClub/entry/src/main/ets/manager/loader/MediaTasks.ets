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
import { PhotoModel } from '../../models/PhotoModel';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { PHOTO_FETCH_COLUMNS } from './LoadUtil';
import { dataSharePredicates } from '@kit.ArkData';
import { fileIo as fs } from '@kit.CoreFileKit';
import LogManager from '../../common/Log/LogManager';

export const USE_TASK = true

@Concurrent
export async function getAllMediaItems(tag: string, context: Context): Promise<PhotoModel[]> {
  LogManager.hilogIWithTag(tag, `getAllMediaItems start`);
  let fileAssets: PhotoModel[] = [];
  let photoFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset>;
  let predicates = new dataSharePredicates.DataSharePredicates();
  let photoFetchOption: photoAccessHelper.FetchOptions = {
    fetchColumns: PHOTO_FETCH_COLUMNS,
    predicates: predicates
  };
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  LogManager.hilogIWithTag(tag, `getAllMediaItems phAccessHelper===${JSON.stringify(phAccessHelper)}`);
  photoFetchResult = await phAccessHelper.getAssets(photoFetchOption);
  LogManager.hilogIWithTag(tag, `getAllMediaItems phAccessHelper===${JSON.stringify(photoFetchResult)}`);
  let fileAssetList = await photoFetchResult.getAllObjects();
  for (let photoAsset of fileAssetList) {
    fileAssets.push({
      uri: photoAsset.uri,
      displayName: photoAsset.displayName,
      dateAdded: photoAsset.get(photoAccessHelper.PhotoKeys.DATE_DAY) as number,
      photoAsset: photoAsset
    });
  }
  fileAssets.sort((a, b) => {
    if (a.dateAdded > b.dateAdded) {
      return -1;
    } else {
      return 1;
    }
  })

  LogManager.hilogIWithTag(tag, `getAllMediaItems end ` + fileAssets.length);
  return fileAssets;
}

@Concurrent
export async function getSubTypeMediaItems(tag: string, context: Context,
  subType: photoAccessHelper.AlbumSubtype): Promise<PhotoModel[]> {
  LogManager.hilogIWithTag(tag, `getAlbumsNextPhoto start ` + subType);
  let fileAssets: PhotoModel[] = [];
  let photoFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset>;
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let photoFetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: PHOTO_FETCH_COLUMNS,
    predicates: predicates
  };

  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  let albumList: photoAccessHelper.FetchResult<photoAccessHelper.Album> =
    await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, subType);
  for (let i = 0; i < albumList.getCount(); i++) {
    let album = await albumList.getObjectByPosition(i)
    photoFetchResult = await album.getAssets(photoFetchOptions);
    let fileAssetList = await photoFetchResult.getAllObjects();
    for (let photoAsset of fileAssetList) {
      fileAssets.push({
        uri: photoAsset.uri,
        displayName: photoAsset.displayName,
        dateAdded: photoAsset.get(photoAccessHelper.PhotoKeys.DATE_DAY) as number,
        photoAsset: photoAsset,
      });
    }
  }
  return fileAssets;
}
