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

// [Start task_info_persistence_util]
import { util } from '@kit.ArkTS';
import fileStream from '@ohos.file.fs';

const helper = new util.Base64Helper();

export const filePath = getContext().filesDir;
export const fileName = 'demoFile.txt';
export namespace  DownloadUtil {

  export function uint8ArrayToStr(uint8Array: Uint8Array): string {
    return helper.encodeToStringSync(uint8Array);
  }

  export function strToUint8Array(str: string): Uint8Array {
    return helper.decodeSync(str);
  }

  export function saveDownloadInfo(downloadInfo: string): void {
    if (!fileExists(filePath)) {
      mkDirectorySync(filePath);
    }

    writeToFileSync(filePath, fileName, downloadInfo);
  }

  export function fileExists(filePath: string): boolean {
    try {
      return fileStream.accessSync(filePath);
    } catch (error) {
      return false;
    }
  }

  export function mkDirectorySync(directoryPath: string, recursion?: boolean): void {
    try {
      fileStream.mkdirSync(directoryPath, recursion ?? false);
    } catch (error) {
      console.error(`mk dir error. err message: ${error.message}, err code: ${error.code}`);
    }
  }

  export function writeToFileSync(dir: string, fileName: string, msg: string): void {
    let file = fileStream.openSync(dir + '/' + fileName, fileStream.OpenMode.WRITE_ONLY | fileStream.OpenMode.CREATE);
    fileStream.writeSync(file.fd, msg);
  }

  export function readFileSync(dir: string, fileName: string): string {
    return fileStream.readTextSync(dir + '/' + fileName);
  }

}
// [End task_info_persistence_util]