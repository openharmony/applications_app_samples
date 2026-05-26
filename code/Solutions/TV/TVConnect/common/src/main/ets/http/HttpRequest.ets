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
import { http } from '@kit.NetworkKit';
import BaseEntry from './BaseEntry';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../utils/Logger';
import { UserLibraryDao } from '../database/dao/UserLibraryDao';

type ExtraDataType = string | Object | ArrayBuffer;

function configUrl(res: Resource) {
  let context = getContext();
  return context.resourceManager.getStringSync(res.id);
}

const BASE_URL = configUrl($r('app.string.API_BASE_URL'));
const TAG = 'HttpRequest';

export class HttpRequest {
  private static async createRequest<T>(url: string, method: http.RequestMethod,
    extraData?: ExtraDataType): Promise<T> {
    let headerRecord: Record<string, string> = {};
    let client: http.HttpRequest = http.createHttp();
    let options: http.HttpRequestOptions = {
      method: method,
    };
    if (extraData != undefined) {
      options.extraData = extraData;
    }
    if (method == http.RequestMethod.POST) {
      headerRecord['Content-Type'] = 'application/json';
    }
    let token = UserLibraryDao.getToken();
    if (token != undefined && token.length > 0) {
      headerRecord['token'] = 'Bearer ' + token;
    }
    options.header = headerRecord;
    try {
      console.log('createRequest begin');
      let urls = `${BASE_URL}${url}`;
      console.log('createRequest begin urls==' + JSON.stringify(urls) + '==options==' + JSON.stringify(options));
      let response = await client.request(urls, options);
      console.log('createRequest response' + JSON.stringify(response));
      if (typeof response.result === 'string') {
        console.log('createRequest response response.result');
        let base = JSON.parse(response.result) as BaseEntry<T>;
        console.log('createRequest response base' + JSON.stringify(base));
        if (base.code == 200) {
          return base.data;
        }
        let error: BusinessError = {
          name: 'HttpRequest',
          code: base.code,
          message: base.msg,
        };
        return Promise.reject(error);
      }
      Logger.error(TAG, 'http response analysis failed');
      return Promise.reject('http response analysis failed');
    } catch (err) {
      console.log('createRequest err' + JSON.stringify(err));
      Logger.error(TAG, `http request error code=${err?.code} message=${err?.message}`);
      return Promise.reject(err);
    } finally {
      client.destroy();
    }
  }

  /**
   * get 请求
   * get 请求的表单参数，拼接在url 中。
   * @param url
   * @returns
   */
  public static get<T>(url: string): Promise<T> {
    return HttpRequest.createRequest(url, http.RequestMethod.GET);
  }

  /**
   * post 请求
   * @param url
   * @param extraData
   * @returns
   */
  public static post<T>(url: string, extraData: Object): Promise<T> {
    return HttpRequest.createRequest(url, http.RequestMethod.POST, extraData);
  }
}