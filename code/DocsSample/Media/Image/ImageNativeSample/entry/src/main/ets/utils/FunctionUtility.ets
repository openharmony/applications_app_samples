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
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';

// 将rawFile中的文件写到沙箱里。
export async function pushSourceToBox(context: common.UIAbilityContext, fileName: string) {
  let value = await context.resourceManager.getRawFileContent(fileName);
  let myBuffer: ArrayBufferLike = value.buffer;
  let filePath = context.filesDir + '/' + fileName;
  let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let writLen = await fs.write(file.fd, myBuffer);
  console.log(`Push ${fileName} to box's writLen is ${writLen}.`);
  fs.closeSync(file);
}

// 获取文件fd。
export function getFileFd(context: Context, fileName: string): number | undefined {
  const filePath: string = context.cacheDir + '/' + fileName;
  const file: fs.File = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  const fd: number = file?.fd;
  return fd;
}
