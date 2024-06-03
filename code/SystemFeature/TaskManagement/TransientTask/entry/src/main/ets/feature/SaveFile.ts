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

import fileio from '@ohos.fileio'
import Logger from '../util/Logger'

const TAG: string = 'SaveFile'
const NAME: string = 'entry-signed-release.hqf'

export default function saveFile(pathDir: string, content: ArrayBuffer): void {
  try {
    let tempPath = pathDir
    let path = `${tempPath.split('entry')[0]}${NAME}`
    Logger.info(TAG, `saveFile , path is ${path}`)
    let fd = fileio.openSync(path, 0o2 | 0o100, 0o666)
    fileio.writeSync(fd, content)
    fileio.closeSync(fd)
  } catch (err) {
    Logger.error(TAG, `saveFile failed, code is ${err.code}, message is ${err.message}`)
  }
}