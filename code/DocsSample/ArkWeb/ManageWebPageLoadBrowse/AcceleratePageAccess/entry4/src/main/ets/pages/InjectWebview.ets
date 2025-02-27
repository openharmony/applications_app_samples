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
 
import { webview } from '@kit.ArkWeb';
import { resourceConfigs } from './Resource';
import { BuilderData } from './DynamicComponent';

@Builder
function webBuilder(data: BuilderData) {
  Web({ src: data.url, controller: data.controller })
    .onControllerAttached(async () => {
      try {
        data.controller.injectOfflineResources(await getData ());
      } catch (err) {
        console.error('error: ' + err.code + ' ' + err.message);
      }
    })
    .fileAccess(true)
}

export const injectWebview = wrapBuilder<BuilderData[]>(webBuilder);

export async function getData() {
  const resourceMapArr: webview.OfflineResourceMap[] = [];

  // 读取配置，从rawfile目录中读取文件内容
  for (let config of resourceConfigs) {
    let buf: Uint8Array = new Uint8Array(0);
    if (config.localPath) {
      buf = await readRawFile(config.localPath);
    }

    resourceMapArr.push({
      urlList: config.urlList,
      resource: buf,
      responseHeaders: config.responseHeaders,
      type: config.type,
    })
  }

  return resourceMapArr;
}

export async function readRawFile(url: string) {
  try {
    return await getContext().resourceManager.getRawFileContent(url);
  } catch (err) {
    return new Uint8Array(0);
  }
}
