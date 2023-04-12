/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { StorageConst } from '../utils/StorageConst'

export class ParseData {
  parseSizeToString(sizeData: number): string {
    let result = sizeData
    if (sizeData <= StorageConst.MB_MAGNITUDE) {
      result = sizeData / StorageConst.KB_MAGNITUDE
      return `${(result).toFixed(result > 0.1 ? 1 : 0)} ${StorageConst.KB_SYMBOL}`
    } else if (sizeData <= StorageConst.GB_MAGNITUDE) {
      result = sizeData / StorageConst.MB_MAGNITUDE
      return `${(result).toFixed(result > 0.1 ? 1 : 0)} ${StorageConst.MB_SYMBOL}`
    } else {
      result = sizeData / StorageConst.GB_MAGNITUDE
      return `${(result).toFixed(result > 0.1 ? 1 : 0)} ${StorageConst.GB_SYMBOL}`
    }
  }

  parseSize(sizeData: number): number {
    return sizeData / StorageConst.MB_MAGNITUDE
  }

  calculatePercentage(molecule: number, denominator: number): string {
    return `${(molecule / denominator * 100).toFixed(1)}%`
  }
}

export default new ParseData()