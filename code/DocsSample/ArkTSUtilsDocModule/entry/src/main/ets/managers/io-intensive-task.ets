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

import { write } from './file-write';
import { BusinessError } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';

@Concurrent
async function concurrentTest(fileList: string[]): Promise<boolean> {
  // 循环写文件操作
  for (let i: number = 0; i < fileList.length; i++) {
    console.info('arkts-utils:: this filepath is:' + fileList[i]);
    write('Hello World!', fileList[i]).then(() => {
      console.info(`arkts-utils:: Succeeded in writing the file. FileList: ${fileList[i]}`);
    }).catch((err: BusinessError) => {
      console.error(`arkts-utils:: Failed to write the file. Code is ${err.code}, message is ${err.message}`);
      return false;
    })
  }
  return true;
}

export async function ioTaskTest(): Promise<string> {
  let context = getContext();
  const filePath1 = context.filesDir + '/111.txt';
  const filePath2 = context.filesDir + '/222.txt';

  // 使用TaskPool执行包含密集I/O的并发函数
  // 数组较大时，I/O密集型任务任务分发也会抢占主线程，需要使用多线程能力
  await taskpool.execute(concurrentTest, [filePath1, filePath2]);
  let result = fileIo.access(filePath1, fileIo.AccessModeType.EXIST);

  if (!result) {
    return 'IoTaskTest Failed';
  }
  return 'IoTaskTest Succeed';
}