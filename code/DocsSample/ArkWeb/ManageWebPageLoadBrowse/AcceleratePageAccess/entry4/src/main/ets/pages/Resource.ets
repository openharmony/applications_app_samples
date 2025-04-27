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

// [Start compile_resource_allocation_information]
import { webview } from '@kit.ArkWeb';
// [StartExclude compile_resource_allocation_information]
function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}
// [EndExclude compile_resource_allocation_information]
export interface ResourceConfig {
  urlList: Array<string>,
  type: webview.OfflineResourceType,
  responseHeaders: Array<Header>,
  localPath: string, // 本地资源存放在rawfile目录下的路径
}

export const resourceConfigs: ResourceConfig[] = [
  {
    localPath: 'example.png',
    urlList: [
      resourceToString($r('app.string.web_path')),
      resourceToString($r('app.string.web_path')) + 'path1/example.png',
      resourceToString($r('app.string.web_path')) + 'path2/example.png',
    ],
    type: webview.OfflineResourceType.IMAGE,
    responseHeaders: [
      { headerKey: 'Cache-Control', headerValue: 'max-age=1000' },
      { headerKey: 'Content-Type', headerValue: 'image/png' },
    ]
  },
  {
    localPath: 'example.js',
    urlList: [ // 仅提供一个url，这个url既作为资源的源，也作为资源的网络请求地址
      resourceToString($r('app.string.web_path_one')),
    ],
    type: webview.OfflineResourceType.CLASSIC_JS,
    responseHeaders: [
    // 以<script crossorigin='anoymous' />方式使用，提供额外的响应头
      { headerKey: 'Cross-Origin', headerValue:'anonymous' }
    ]
  },
];
// [End compile_resource_allocation_information]