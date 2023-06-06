/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import cryptoFramework from "@ohos.security.cryptoFramework"
import promptAction from '@ohos.promptAction';
import Logger from '../util/Logger';

// 当前版本读取uri后，无法直接read、write文件内容，需要sleep几十ms，这里sleep100毫秒
function sleep(time){
  return new Promise((resolve) => setTimeout(resolve, time));
}

class TextFileManager {
  public static readString: string = '';
  public static readResult: number = 0;
  public static writeResult: number = 0;

  async readTextFile(textFileUri: string) {
    await sleep(100);
    let file = fs.openSync(textFileUri, fs.OpenMode.READ_ONLY);
    // 写入
    console.info("success, read only file " + file.fd);
    // 从文件读取一段内容
    let buf = new ArrayBuffer(8192);
    let readLen = fs.readSync(file.fd, buf, { offset: 0 });
    // console.info("success, the content of key file: " + String.fromCharCode.apply(null, new Uint8Array(buf.slice(0, readLen))));
    TextFileManager.readString = String.fromCharCode.apply(null, new Uint8Array(buf.slice(0, readLen)));
    TextFileManager.readResult = readLen;
  }

  async writeTextFile(textFileUri: string, textString: string) {
    await sleep(100);
    let file = fs.openSync(textFileUri, fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
    fs.closeSync(file);
    file = fs.openSync(textFileUri, fs.OpenMode.READ_WRITE);
    // 写入
    console.info("success,read write file " + file.fd);
    let writeLen = fs.writeSync(file.fd, textString);
    console.info("success, The length of str is: " + writeLen);
    // 从文件读内容
    // let buf = new ArrayBuffer(4096);
    // let readLen = fs.readSync(file.fd, buf, { offset: 0 });
    // console.info("success, the content of text file: " + String.fromCharCode.apply(null, new Uint8Array(buf.slice(0, readLen))));
    fs.closeSync(file);
    TextFileManager.writeResult = writeLen;
  }

  getString() {
    return TextFileManager.readString;
  }

}

export default new TextFileManager()