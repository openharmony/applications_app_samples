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
 

import Log from './Log';
import { fileIo as FileIo } from '@kit.CoreFileKit';

const DFAULT_SIZE = 4096;
const CHAR_CODE_AT_INDEX = 0;
const TAG = 'ReadConfigUtil';

export class ReadConfigUtil {
  readConfigFile(fileName: string): any {
    Log.showDebug(TAG, `readConfigFile fileName:${fileName}`);
    try {
      let stream = FileIo.createStreamSync(fileName, 'r');
      Log.showDebug(TAG, `readConfigFile stream:${JSON.stringify(stream)}`);
      let buf = new ArrayBuffer(DFAULT_SIZE);
      let len = stream.readSync(buf);
      Log.showDebug(TAG, `readConfigFile len:${len}`);
      let arr = new Uint8Array(buf);
      let charAt = ' '.charCodeAt(CHAR_CODE_AT_INDEX);
      for (let i = len;i < DFAULT_SIZE; i++) {
        arr[i] = charAt;
      }
      let content = String.fromCharCode.apply(null, arr);
      stream.closeSync();
      Log.showDebug(TAG, `readConfigFile content:${JSON.stringify(content)}`);
      return JSON.parse(content);
    } catch (error) {
      Log.showError(TAG, `readConfigFile error:${JSON.stringify(error)}`);
    }
  }
}

let readConfigUtil = new ReadConfigUtil();

export default readConfigUtil;
