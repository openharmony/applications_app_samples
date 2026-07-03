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
import { HttpCallback } from '../callback/HttpCallback';
import { BaseCallback } from '../callback/BaseCallback';
import { DownloadCallback } from '../callback/DownloadCallback';
import { UpgradeDeviceLibraryRequest, UpgradeSceneLibraryRequest } from './Request';
import { CommonResponse, } from './Response';
import { HttpUtil } from '../utils/HttpUtil';
import { RequestUtil } from '../utils/RequestUtil';
import { JsonUtil } from '../utils/JsonUtil';

/*
 * 云api
 * */
export class SyncCloudApi {
  private static readonly CLOUD_URL = 'http://110.41.7.101:6777';
  private static readonly URL_UPGRADE_DEVICE_LIBRARY =
    SyncCloudApi.CLOUD_URL + '/api/v1/business/deviceslibrary-manager';
  private static readonly URL_UPGRADE_SCENE_LIBRARY = SyncCloudApi.CLOUD_URL + '/api/v1/business/sceneslibrary-manager';

  /*
   * 获取设备库版本信息
   * */
  public static checkDeviceLibraryVersionInfo(request: UpgradeDeviceLibraryRequest, callback: BaseCallback) {
    let httpCallback: HttpCallback = {
      onSuccess: (code: number, data: Object, msg: string) => {
        let response: CommonResponse = JsonUtil.parseToClass(String(data), {
          createClassTarget: () => {
            return new CommonResponse;
          }
        }) as CommonResponse;
        callback.onResult(StatusCode.SUCCESS, response, msg);
      },
      onFailure: (code: number, data: Object, msg: string) => {
        let response: CommonResponse = JsonUtil.parseToClass(String(data), {
          createClassTarget: () => {
            return new CommonResponse;
          }
        }) as CommonResponse;
        callback.onResult(StatusCode.FAIL, response, msg);
      }
    };
    HttpUtil.post(SyncCloudApi.URL_UPGRADE_DEVICE_LIBRARY, httpCallback, request);
  }

  /*
   * 获取场景库版本信息
   * */
  public static checkSceneLibraryVersionInfo(request: UpgradeSceneLibraryRequest, callback: BaseCallback) {
    let httpCallback: HttpCallback = {
      onSuccess: (code: number, data: Object, msg: string) => {
        let response: CommonResponse = JsonUtil.parseToClass(String(data), {
          createClassTarget: () => {
            return new CommonResponse;
          }
        }) as CommonResponse;
        callback.onResult(StatusCode.SUCCESS, response, msg);
      },
      onFailure: (code: number, data: Object, msg: string) => {
        let response: CommonResponse = JsonUtil.parseToClass(String(data), {
          createClassTarget: () => {
            return new CommonResponse;
          }
        }) as CommonResponse;
        callback.onResult(StatusCode.FAIL, response, msg);
      }
    };
    HttpUtil.post(SyncCloudApi.URL_UPGRADE_SCENE_LIBRARY, httpCallback, request);
  }

  /*
   * 下载文件
   * */
  public static downloadFile(url: string, destPath: string, calback?: DownloadCallback) {
    RequestUtil.downloadFile(url, destPath, calback);
  }
}

export enum StatusCode {
  SUCCESS = 0, FAIL
}