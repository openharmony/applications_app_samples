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
 
import { BuilderData } from './DynamicComponent';
import { Config, configs } from './PrecompileConfig';

@Builder
function webBuilder(data: BuilderData) {
  Web({ src: data.url, controller: data.controller })
    .onControllerAttached(() => {
      precompile(data.controller, configs);
    })
    .fileAccess(true)
}

export const precompileWebview = wrapBuilder<BuilderData[]>(webBuilder);

export const precompile = async (controller: WebviewController, configs: Array<Config>) => {
  for (const config of configs) {
    let content = await readRawFile(config.localPath);

    try {
      controller.precompileJavaScript(config.url, content, config.options)
        .then(errCode => {
          console.error('precompile successfully! ' + errCode);
        }).catch((errCode: number) => {
        console.error('precompile failed. ' + errCode);
      });
    } catch (err) {
      console.error('precompile failed. ' + err.code + ' ' + err.message);
    }
  }
}

async function readRawFile(path: string) {
  try {
    return await getContext().resourceManager.getRawFileContent(path);;
  } catch (err) {
    return new Uint8Array(0);
  }
}
