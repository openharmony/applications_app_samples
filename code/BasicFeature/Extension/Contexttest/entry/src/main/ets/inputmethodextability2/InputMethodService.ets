/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
import InputMethodExtensionAbility from '@ohos.InputMethodExtensionAbility';
import keyboardController1 from './model/KeyboardController1';
import Want from '@ohos.app.ability.Want';
import { logger } from '../utils/Logger';

export default class InputDemo2Service extends InputMethodExtensionAbility {
  onCreate(want: Want): void {
    keyboardController1.onCreate(this.context); // 初始化窗口并注册对输入法框架的事件监听
    let filesDir = this.context.filesDir;
    let filesDir2 = this.context.getApplicationContext().filesDir;
    let file3 = fs.openSync(filesDir + '/inputtest3.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let file4 = fs.openSync(filesDir2 + '/inputtest4.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

    //预期结果，无法读写
    try {
      fs.openSync(filesDir + '/inputtest1.txt', fs.OpenMode.READ_WRITE);
    } catch (e) {
      logger.error(`input openSync module err: ${JSON.stringify(e)}`);
    }

    //预期结果，无法读写
    try {
      fs.openSync(filesDir2 + '/inputtest2.txt', fs.OpenMode.READ_WRITE);
    } catch (e) {
      logger.error(`input openSync app err: ${JSON.stringify(e)}`);
    }
  }

  onDestroy(): void {
    keyboardController1.onDestroy(); // 销毁窗口并去注册事件监听
  }
}