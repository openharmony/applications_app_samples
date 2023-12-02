/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import fs from '@ohos.file.fs';
import Log from './Log';

export default class AudioFrameworkTest {
  public constructor() {
    Log.info('start audio framework test init');
    let context = getContext(this);
    let path = context.filesDir;
    // 使用沙箱路径获取文件，实际路径为/data/app/el2/100/base/com.samples.videoplayer/haps/entry/files/sample_3s.wav
    const filePath = path + '/sample_3s.wav';
    Log.info('file path: ' + filePath);
    fs.stat(filePath, (err, state) => {
      Log.info('get file state succeed: size = ' + state?.size + ', err = ' + err);
    })
    Log.info('try open file: ' + filePath);
    let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    Log.info('try open file succeed: ' + file.fd);
    fs.close(file);
  }
}