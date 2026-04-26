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
import { initInfo } from './log';

export interface RequestOption extends http.HttpRequestOptions {
  url: string,
}

interface HttpHeader {
  'contentType': string;
}

interface HttpGetOption {
  url: string;
}

interface HttpPostOption {
  url: string;
  data?: Object;
  dataType?: http.HttpDataType;
}

let log = initInfo('http');

export function request(option: RequestOption): Promise<http.HttpResponse> {
  let httpRequest = http.createHttp();


  let url = option.url || '';
  let method = option.method || http.RequestMethod.GET;

  let header: HttpHeader = {
    'contentType': 'application/json'
  };
  let extraData: Object = option.extraData ? (option.extraData as Object) : {};
  let expectDataType = option.expectDataType || http.HttpDataType.OBJECT;

  let usingCache = true;
  let priority = 1;
  let connectTimeout = 5000;
  let usingProtocol = http.HttpProtocol.HTTP1_1;

  return httpRequest.request(url, {
    method,
    header,
    extraData,
    expectDataType,
    usingCache,
    priority,
    connectTimeout,
    usingProtocol
  })
}

export function httpGet(option: HttpGetOption): Promise<http.HttpResponse> {
  let url = option.url;
  let method = http.RequestMethod.GET;
  return request({ url, method });
}

export function httpPost(option: HttpPostOption): Promise<http.HttpResponse> {
  let url = option.url;
  let method = http.RequestMethod.POST
  let extraData: Object = option.data ? option.data : {};
  let expectDataType = option.dataType || http.HttpDataType.OBJECT;
  return request({
    url,
    method,
    extraData,
    expectDataType
  });
}
