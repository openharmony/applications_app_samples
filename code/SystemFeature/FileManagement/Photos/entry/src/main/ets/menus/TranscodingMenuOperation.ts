/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { Log } from '../utils/Log';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { MenuOperationCallback } from './MenuOperationCallback';
import { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG = 'TranscodingMenuOperation';

export class TranscodingMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.warn(TAG, ' menuContext is null, return');
      return;
    }
    let mediaItem = this.menuContext.items[0];
    if (mediaItem == null) {
      Log.warn(TAG, ' mediaItem is null, return');
      return;
    }

    this.confirmCallback = (fileUri: Function, transCodingResult: Function, showProgressNum: Function): Promise<void> =>
      this.confirmCallbackBindImpl(fileUri, transCodingResult, showProgressNum);
    this.cancelCallback = (): void => this.cancelCallbackBindImpl();
    let fileName = '';
    if (mediaItem.title != null) {
      fileName = mediaItem.title;
    } else if (mediaItem.displayName != null) {
      let index = mediaItem.displayName.lastIndexOf('.');
      fileName = mediaItem.displayName.substr(0, index);
    }

    this.menuContext.broadCast.emit(BroadcastConstants.SHOW_TRANS_CODING_DIALOG,
      [fileName, this.confirmCallback, this.cancelCallback]);
  }

  onCompleted(): void {
    Log.info(TAG, ' TransCoding data succeed!');
  }

  onError(): void {
    Log.error(TAG, ' TransCoding data failed!');
  }

  private async confirmCallback(fileUri: Function, transCodingResult: Function, showProgressNum: Function): Promise<void> {
    this.confirmCallbackBindImpl(fileUri, transCodingResult, showProgressNum);
  }

  private async confirmCallbackBindImpl(fileUri: Function, transCodingResult: Function, showProgressNum: Function): Promise<void> {
    let context = getContext(this);
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let mediaItem = this.menuContext.items[0];
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI, mediaItem.uri);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates
    };

    let testHandler: photoAccessHelper.MediaAssetProgressHandler = {
      onProgress: (progress: number) => {
        if (progress > 0) {
          showProgressNum(progress)
        }
        Log.info(TAG, ` Current video conversion progress: ${progress}%`);
      }
    };

    let mediaDataHandler: photoAccessHelper.MediaAssetDataHandler<boolean> = {
      onDataPrepared: (data: boolean) => {
        transCodingResult(data)
        Log.info(TAG, ' transCodingSuccess: ' + data);
      }
    }

    Log.info(TAG, ' requestOptions before');
    try {
      let requestOptions: photoAccessHelper.RequestOptions = {
        deliveryMode: photoAccessHelper.DeliveryMode.HIGH_QUALITY_MODE,
        compatibleMode: photoAccessHelper.CompatibleMode.COMPATIBLE_FORMAT_MODE,
        mediaAssetProgressHandler: testHandler,
      }
      let tempDir = context.getApplicationContext().tempDir;
      let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOptions);
      let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      let uri = tempDir + photoAsset.displayName;
      fileUri(uri)
      Log.info(TAG, ' this.fileUri  ' + fileUri);
      await photoAccessHelper.MediaAssetManager.requestVideoFile(
        context,
        photoAsset,
        requestOptions,
        uri,
        mediaDataHandler
      );
    } catch (err) {
      Log.info(TAG, ' operation '+ err);
    }
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, ' TransCoding cancel');
  }
}
