/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@ohos.base';
import { common } from '@kit.AbilityKit';

async function write(data: string, file: fileIo.File): Promise<void> {
  fileIo.write(file.fd, data).then((writeLen: number) => {
    console.info('write data length is: ' + writeLen);
  }).catch((err: BusinessError) => {
    console.error(`Failed to write data. Code is ${err.code}, message is ${err.message}`);
  })
}

export async function singleIoTest(): Promise<string> {
  let context = getContext() as common.UIAbilityContext;
  let filePath: string = context.filesDir + '/ioTest.txt'; // 应用文件路径
  let file: fileIo.File = await fileIo.open(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  write('Hello World!', file).then(() => {
    console.info('Succeeded in writing data.');
    fileIo.close(file);
  }).catch((err: BusinessError) => {
    console.error(`Failed to write data. Code is ${err.code}, message is ${err.message}`);
    fileIo.close(file);
  })

  let result = await fileIo.access(filePath, fileIo.AccessModeType.EXIST);
  if (!result) {
    return 'SingleIoTest Failed';
  }
  return 'SingleIoTest Succeed';
}