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

import http from '@ohos.net.http';
import util from '@ohos.util';
import { Logger } from '@ohos/common';
import { HttpCallback } from '../callback/HttpCallback';
import { CommErr } from '../utils/CommErr';

const DEFAULT_TIMEOUT = 10000;

/*
 * http工具类
 * */
export class HttpUtil {
  public static get(url: string, callback: HttpCallback);

  public static get(url: string, callback: HttpCallback, params: object);

  public static get(url: string, callback: HttpCallback, params: object | undefined, header: object);

  public static get(url: string, callback: HttpCallback, params?: object | undefined, header?: object) {
    url = HttpUtil.joinGetUrl(url, params);
    HttpUtil.doRequest('GET', url, callback, null, header);
  }

  public static post(url: string, callback: HttpCallback);

  public static post(url: string, callback: HttpCallback, params: object);

  public static post(url: string, callback: HttpCallback, params: object, header: object);

  public static post(url: string, callback: HttpCallback, params?: object, header?: object) {
    HttpUtil.doRequest('POST', url, callback, params, header);
  }

  private static doRequest(_method: string, url: string, callback: HttpCallback, body?: object | null, header?: object,
    readTimeout?: number, connectTimeout?: number): void {
    let method = http.RequestMethod.GET;
    switch (_method) {
      case 'GET':
        method = http.RequestMethod.GET;
        break;
      case 'POST':
        method = http.RequestMethod.POST;
        break;
      case 'PUT':
        method = http.RequestMethod.PUT;
        break;
      default:
        method = http.RequestMethod.GET;
        break;
    }
    let isNoAt = url.endsWith('.json'); // 访问静态资源文件不带AT
    let options: http.HttpRequestOptions = {
      method: method,
      header: header == null ? HttpUtil.defaultHeader(isNoAt) : header, // 如果header不为空则使用传递进来的header
      extraData: body === null ? undefined : body,
      readTimeout: typeof readTimeout === undefined ? DEFAULT_TIMEOUT : readTimeout,
      connectTimeout: typeof connectTimeout === undefined ? DEFAULT_TIMEOUT : connectTimeout
    };

    let request = http.createHttp();
    Logger.info('HttpUtil url:', url);
    Logger.info('HttpUtil request body:', JSON.stringify(body));
    request.request(url, options, (err, response) => {
      if (err) {
        callback.onFailure(err.code, err, 'fail');
      } else {
        Logger.info('HttpUtil response body:', JSON.stringify(response.result));
        let code = response.responseCode;
        // 新建资源201标识成功
        if (code == 200 || code == 201) {
          callback.onSuccess(code, response.result, 'success');
        } else {
          callback.onFailure(code, response.result, 'fail');
        }
      }
      request.destroy();
    });
  }

  private static joinGetUrl(url: string, params: object | undefined): string {
    if (params == null) {
      return url;
    }
    let keys: string[] = Object.keys(params);
    let data: string = '';
    keys.forEach(key => {
      data += key + '=' + params[key] + '&';
    });
    if (data.endsWith('&')) {
      data = data.substring(0, data.length - 1);
    }
    if (data != '' && !url.endsWith('?')) {
      url += '?';
    }
    url += data;
    return url;
  }

  private static async makeRequest(url: string, options: http.HttpRequestOptions,
    describe: string): Promise<http.HttpResponse> {
    let client: http.HttpRequest = http.createHttp();
    let response: http.HttpResponse | null = null;
    try {
      response = await client.request(url, options);
      return response;
    } catch (err) {
      throw new CommErr(err?.code, err?.message);
    } finally {
      client.destroy();
    }
  }

  private static defaultHeader(isNoAt: boolean): object {
    let header: Record<string, string> = {};
    header = {
      'Content-Type': 'application/json',
      'x-requestId': util.generateRandomUUID(true)
    };
    return header;
  }
}