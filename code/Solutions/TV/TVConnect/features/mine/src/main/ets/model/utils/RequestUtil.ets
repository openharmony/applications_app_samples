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
import request from '@ohos.request';
import { DownloadCallback } from '../callback/DownloadCallback';
import { BusinessError } from '@ohos.base';
import { Logger } from '@ohos/common';

/*
 * 文件上传下载工具类
 * */
export class RequestUtil {
  public static uploadFile() {
  }

  public static downloadFile(sourceAddr: string, destAddr: string, callback?: DownloadCallback) {
    let downloadTask: request.DownloadTask;
    let progressCallback = (receivedSize: number, totalSize: number) => {
      callback?.onDownLoading(receivedSize, totalSize);
    };
    let completeCallback = () => {
      callback?.onSuccess();
    };
    let failCallback = (err: number) => {
      callback?.onFailure();
      Logger.error(`Failed to request the download. err: ${JSON.stringify(err)}`);
    };
    try {
      request.downloadFile(getContext(), {
        url: sourceAddr,
        filePath: destAddr
      }, (err: BusinessError, data: request.DownloadTask) => {
        if (err) {
          callback?.onFailure();
          Logger.error(`Failed to request the download. Code: ${err.code}, message: ${err.message}`);
          return;
        }
        downloadTask = data;
        downloadTask.on('progress', progressCallback);
        downloadTask.on('complete', completeCallback);
        downloadTask.on('fail', failCallback);
      });
    } catch (err) {
      callback?.onFailure();
      Logger.error(`Failed to request the download. err: ${JSON.stringify(err)}`);
    }
  }
}