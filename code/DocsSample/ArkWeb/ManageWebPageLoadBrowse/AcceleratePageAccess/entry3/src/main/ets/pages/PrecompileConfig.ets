/*
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
 
import { webview } from '@kit.ArkWeb'

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

export interface Config {
  url:  string,
  localPath: string, // 本地资源路径
  options: webview.CacheOptions
}

export let configs: Config[] = [
  {
    url: resourceToString($r('app.string.web_path')),
    localPath: 'example.js',
    options: {
      responseHeaders: [
        { headerKey: 'E-Tag', headerValue: 'aWO42N9P9dG/5xqYQCxsx+vDOoU='},
        { headerKey: 'Last-Modified', headerValue: 'Wed, 21 Mar 2025 10:38:41 GMT'}
      ]
    }
  }
]
