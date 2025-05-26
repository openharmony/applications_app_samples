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

export class AppLog {
  constructor(tag: string) {
    this.tagName = tag
  }
  prefix : string = '[Sample_NdkPicture]'
  tagName: string
  log = (msg: string) => {
    console.info(this.prefix + this.tagName + ' ' + msg)
  }
  check_result = (msg: string, res: object | number) => {
    if (typeof res === "object") {
      this.log(msg + `object result success :${res}`)
    } else if (typeof res === "number") {
      if (res == 0) {
        this.log(msg + `: errorcode result succ: ${res}`)
      } else {
        this.log(msg + `: errorcode result failed: ${res}`)
      }
    } else {
      this.log(msg + `unknown result type: ${res}`)
    }
  }
}