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
  private domain: number;
  private prefix: string;
  private format: string = '%{public}s, %{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
  }

  debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
    return;
  }

  info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
    return;
  }

  warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
    return;
  }

  error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
    return;
  }

  fatal(...args: string[]): void {
    hilog.fatal(this.domain, this.prefix, this.format, args);
    return;
  }

  isLoggable(level: number): void {
    hilog.isLoggable(this.domain, this.prefix, level);
    return;
  }
}

export default new Logger('[Sample_CertFramework]');