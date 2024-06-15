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

class InputUtil {
  isEmpty(str?: string): boolean {
    return str == 'undefined' || !str || !new RegExp("[^\\s]").test(str)
  }

  checkNeedNumberSpace(numText: string) {
    let isSpace: RegExp = new RegExp('[\\+;,#\\*]', 'g')
    let isRule: RegExp = new RegExp('^\\+.*')
    if (isSpace.test(numText)) {
      return isRule.test(numText)
    }
    return true
  }

  removeSpace(str: string): string {
    if (this.isEmpty(str)) {
      return ''
    }
    return str.replace(new RegExp("[\\s]", "g"), '')
  }
}

export default new InputUtil()