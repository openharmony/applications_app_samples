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

import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import Logger from './Logger';

// Obtain the path of the application file
const uiContext: UIContext | undefined = AppStorage.get('uiContext');
let context: common.UIAbilityContext = uiContext?.getHostContext() as common.UIAbilityContext;
let filesDir: string = context.filesDir;
let fileUrl: string = filesDir + '/abc.png'; // The image's network address suffix needs to be replaced by the real url.

export async function httpRequest() {
  fs.access(fileUrl, fs.AccessModeType.READ).then((res) => { // Check whether files exist
    if (!res) { // If the address does not exist in the sandbox, re-request the network image resource
      http.createHttp()
        // Please fill in a specific network image address here, example: https://raw.gitcode.com/openharmony/applications_app_samples/blobs/59b99cbd79be8c4f540382b3a6161587eecc3cd4/eraser_picture.jpg
        // If you fill in the real address, you need to replace the global fileUrl with the real address suffix.
        .request('https://raw.gitcode.com/openharmony/applications_app_samples/blobs/59b99cbd79be8c4f540382b3a6161587eecc3cd4/eraser_picture.jpg',
          (error: BusinessError, data: http.HttpResponse) => {
            if (error) {
              // If the download fails, no subsequent logic is executed
              return;
            }
            // Processing data returned by network requests
            if (http.ResponseCode.OK === data.responseCode) {
              const imageData: ArrayBuffer = data.result as ArrayBuffer;
              // Save the image to the app sandbox
              readWriteFileWithStream(imageData);
            }
          }
        )
    }
  }).catch((error: BusinessError) => {
    Logger.error(`HttpRequestFunc read permission verification fails. code=${error.code}, message=${error.message}`);
  })
}

// Write to the sandbox
async function readWriteFileWithStream(imageData: ArrayBuffer): Promise<void> {
  try {
    let outputStream: fs.Stream = fs.createStreamSync(fileUrl, 'w+');
    await outputStream.write(imageData);
    outputStream.closeSync();
  } catch (error) {
    Logger.error(`readWriteFileWithStream failed. code=${error.code}, message=${error.message}`);
  }
}
