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
import { media } from '@kit.MediaKit';
import { fileIo } from '@kit.CoreFileKit';
import fileUtil from './utils/FileUtils';
import { image } from '@kit.ImageKit';
import LogManager from '../common/Log/LogManager';

@Concurrent
export async function loadVideoThumb(context: Context, uri: string, thumbWidth: number,
  thumbHeight: number): Promise<string> {
  const TAG = 'PHOTOM_loadVideoThumb';
  LogManager.hilogIWithTag(TAG, 'loadVideoThumb task start');
  const startTime = Date.now();
  let cacheDir = await fileUtil.getCacheDir(context);
  let imageName = fileUtil.getLocalFilePathByUri(uri);
  let localPath = cacheDir + imageName;
  let thumbExist = await fileUtil.fileExist(localPath);
  LogManager.hilogIWithTag(TAG, `path = ${localPath} exist = ${thumbExist}`);
  if (thumbExist) {
    return localPath;
  }

  let avImageGenerator: media.AVImageGenerator | undefined = undefined;
  let videoFile: fileIo.File | undefined = undefined;
  let thumbnail: PixelMap | undefined = undefined;
  try {
    videoFile = fileIo.openSync(uri);
    avImageGenerator = await media.createAVImageGenerator();
    avImageGenerator.fdSrc = videoFile;
    let timeUs: number = 0;
    let queryOption: media.AVImageQueryOptions = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
    let param: media.PixelMapParams = {
      width: thumbWidth,
      height: thumbHeight,
    };
    thumbnail = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param);
  } catch (err) {
    LogManager.hilogEWithTag(TAG, `createVideoThumbnail is failed, err = ${JSON.stringify(err)}`);
  } finally {
    if (avImageGenerator) {
      avImageGenerator.release();
    }
    if (videoFile) {
      fileIo.closeSync(videoFile);
    }
    if (thumbnail) {
      LogManager.hilogIWithTag(TAG, `do save`);
      await fileUtil.savePixelMap(thumbnail, localPath);
    } else {
      localPath = '';
    }
    LogManager.hilogIWithTag(TAG, 'loadVideoThumb task end =' + (Date.now() - startTime));
  }
  return localPath;
}

@Concurrent
export async function loadImageThumb(context: Context, uri: string, thumbWidth: number,
  thumbHeight: number): Promise<string> {
  const TAG = 'PHOTOM_loadImageThumb';
  LogManager.hilogIWithTag(TAG, 'loadImageThumb task start');
  const startTime = Date.now();
  let cacheDir = await fileUtil.getCacheDir(context);
  let imageName = fileUtil.getLocalFilePathByUri(uri);
  let localPath = cacheDir + imageName;
  let thumbExist = await fileUtil.fileExist(localPath);
  LogManager.hilogIWithTag(TAG, `path = ${localPath} exist = ${thumbExist}`);
  if (thumbExist) {
    return localPath;
  }

  const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
  const imageSource = image.createImageSource(file.fd);
  const options: image.DecodingOptions = {
    editable: true,
    desiredSize: { height: thumbHeight, width: thumbWidth }
  };
  const thumbnail: PixelMap = await imageSource.createPixelMap(options);
  fileIo.closeSync(file);

  if (thumbnail) {
    LogManager.hilogIWithTag(TAG, `do save`);
    await fileUtil.savePixelMap(thumbnail, localPath);
  } else {
    throw new Error(`thumbnail create fail`);
  }
  LogManager.hilogIWithTag(TAG, 'loadImageThumb task end' + (Date.now() - startTime));
  return localPath;
}

