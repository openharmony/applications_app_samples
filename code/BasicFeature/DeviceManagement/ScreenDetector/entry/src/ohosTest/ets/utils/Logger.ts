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

import hilog from '@ohos.hilog';

const DOMAIN: number = 0xF811;
const PREFIX = '';
const FORMAT = '%{public}s, %{public}s';

class Logger {
  constructor(prefix: string) {

  }

  debug(...args: string[]): void {
    hilog.debug(DOMAIN, PREFIX, FORMAT, args);
  }

  info(...args: string[]): void {
    hilog.info(DOMAIN, PREFIX, FORMAT, args);
  }

  warn(...args: string[]): void {
    hilog.warn(DOMAIN, PREFIX, FORMAT, args);
  }

  error(...args: string[]): void {
    hilog.error(DOMAIN, PREFIX, FORMAT, args);
  }
}

export default new Logger('Sample_ScreenDetector');