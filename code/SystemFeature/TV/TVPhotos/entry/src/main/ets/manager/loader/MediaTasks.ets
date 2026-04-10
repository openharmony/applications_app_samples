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
import Logger from '../../common/Logger';
import { PhotoModel } from '../../models/PhotoModel';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { PHOTO_FETCH_COLUMNS } from './LoadUtil';
import { dataSharePredicates } from '@kit.ArkData';
import { fileIo as fs } from '@kit.CoreFileKit';
import { fileUri } from '@kit.CoreFileKit';
import { relationalStore } from '@kit.ArkData';
import { PHOTO_TABLE_NAME, rdbManager, STORE_CONFIG, URI_PHOTO_KEY } from '../RdbManager';
import { dfsManager } from '../DfsManager';

export const USE_TASK = true

@Concurrent
export async function getAllMediaItems(tag: string, context: Context): Promise<PhotoModel[]> {
  Logger.info(tag, `getAllMediaItems start`);
  let fileAssets: PhotoModel[] = [];
  let photoFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset>;
  let predicates = new dataSharePredicates.DataSharePredicates();
  let photoFetchOption: photoAccessHelper.FetchOptions = {
    fetchColumns: PHOTO_FETCH_COLUMNS,
    predicates: predicates
  };
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  photoFetchResult = await phAccessHelper.getAssets(photoFetchOption);
  let fileAssetList = await photoFetchResult.getAllObjects();
  for (let photoAsset of fileAssetList) {
    let srcFileUri = new fileUri.FileUri(photoAsset.uri);
    let remoteUri: string = fileUri.getUriFromPath(context.distributedFilesDir + '/' + srcFileUri.name);
    let size = 0
    try {
      size = photoAsset.get(photoAccessHelper.PhotoKeys.SIZE) as number
    }catch (e){
      console.log('getAllMediaItems size failed');
    }
    try {
      // 5.0图库获取图片
      fileAssets.push({
        uri: photoAsset.uri,
        displayName: photoAsset.displayName,
        dateAdded: photoAsset.get(photoAccessHelper.PhotoKeys.DATE_DAY) as number,
        photoAsset: photoAsset,
        remoteUri: remoteUri,
        size:size
      });
    } catch (e) {
      // 4.1图库获取图片
      fileAssets.push({
        uri: photoAsset.uri,
        displayName: photoAsset.displayName,
        dateAdded: 0,
        photoAsset: photoAsset,
        remoteUri: remoteUri,
        size:size
      });
      console.error(`getAllMediaItems error: ${e}`);
    }
  }
  fileAssets.sort((a, b) => {
    if (a.dateAdded > b.dateAdded) {
      return -1;
    } else {
      return 1;
    }
  })

  Logger.info(tag, `getAllMediaItems end ` + fileAssets.length);
  return fileAssets;
}


@Concurrent
export async function getSubTypeMediaItems(tag: string, context: Context,
  subType: photoAccessHelper.AlbumSubtype): Promise<PhotoModel[]> {
  Logger.info(tag, `getAlbumsNextPhoto start ` + subType);
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
      let size = 0
      try {
        size = photoAsset.get(photoAccessHelper.PhotoKeys.SIZE) as number
      }catch (e){
        console.log('getAllMediaItems size failed');
      }
      fileAssets.push({
        uri: photoAsset.uri,
        displayName: photoAsset.displayName,
        dateAdded: photoAsset.get(photoAccessHelper.PhotoKeys.DATE_DAY) as number,
        photoAsset: photoAsset,
        size:size
      });
    }
  }
  return fileAssets;
}

/**
 * 预置图片
 * @param tag
 * @param context
 * @returns
 */
@Concurrent
export async function presetImages(tag: string, context: Context): Promise<void> {
  Logger.info(tag, `presetImages start`);
  let getFileExt = (fileName: string): string => {
    const ext = fileName.split('.').pop()?.toLowerCase() || '';
    return ext
  }
  let getMediaTypeByFileName = (fileName: string): photoAccessHelper.PhotoType => {
    const ext = fileName.split('.').pop()?.toLowerCase() || '';
    switch (ext) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return photoAccessHelper.PhotoType.IMAGE;
      case 'mp4':
      case 'mov':
        return photoAccessHelper.PhotoType.VIDEO;
      default:
        return photoAccessHelper.PhotoType.IMAGE;
    }
  }
  try {
    const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    const rawFileList = context.resourceManager.getRawFileListSync('presetImages')

    if (rawFileList.length === 0) {
      return;
    }

    for (const fileName of rawFileList) {
      try {
        const rawFileContent = context.resourceManager.getRawFileContentSync('presetImages/' + fileName)
        const mediaType = getMediaTypeByFileName(fileName);
        const options: photoAccessHelper.CreateOptions = {
          title: 'PRESET_' + Date.now(),
          subtype: photoAccessHelper.PhotoSubtype.DEFAULT
        };
        const photoAssetUri = await phAccessHelper.createAsset(mediaType, getFileExt(fileName), options);
        const fd = await fs.open(photoAssetUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        await fs.write(fd.fd, rawFileContent.buffer);
        await fs.close(fd);
        Logger.info(tag, `save ${fileName} to ${photoAssetUri} success`)
      } catch (err) {
        Logger.error(tag, `raw file  ${fileName} save fail ${JSON.stringify(err)}`);
        // 向上抛出异常
        throw new Error(err);
      }
    }
  } catch (err) {
    Logger.error(tag, `get raw file fail ${JSON.stringify(err)}`);
    throw new Error(err)
  }
  Logger.info(tag, `presetImages end`);
}

@Concurrent
export async function deleteDfsPhoto(context: Context, photosUris: string[]) {
  const TAG = 'deleteDfsPhoto';
  try {
    let rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
    for (let i = 0; i < photosUris.length; i++) {
      let predicates = new relationalStore.RdbPredicates(PHOTO_TABLE_NAME);
      predicates.equalTo(URI_PHOTO_KEY, photosUris[i]);
      let result = await rdbStore.delete(predicates);
      if (result >= 0) {
        dfsManager.deleteDfsPhotoFile(photosUris[i], context);
        rdbManager.syncRemoteData();
      }
      Logger.info(TAG, `deleteDfsPhotoData success ${result}`);
    }
  } catch (err) {
    Logger.error(TAG, `deleteDfsPhotoData failed, err = ${JSON.stringify(err)}`);
  }
}
