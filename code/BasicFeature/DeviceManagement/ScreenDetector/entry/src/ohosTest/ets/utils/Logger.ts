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

class Logger {
  private DOMAIN: number;
  private PREFIX: string;
  private FORMAT: string = '%{public}s, %{public}s';

  constructor(prefix: string) {
    this.PREFIX = prefix;
    this.DOMAIN = 0xF811;
  }

  debug(...args: string[]): void {
    hilog.debug(this.DOMAIN, this.PREFIX, this.FORMAT, args);
  }

  info(...args: string[]): void {
    hilog.info(this.DOMAIN, this.PREFIX, this.FORMAT, args);
  }

  warn(...args: string[]): void {
    hilog.warn(this.DOMAIN, this.PREFIX, this.FORMAT, args);
  }

  error(...args: string[]): void {
    hilog.error(this.DOMAIN, this.PREFIX, this.FORMAT, args);
  }
}

export default new Logger('Sample_ComponentCollection');