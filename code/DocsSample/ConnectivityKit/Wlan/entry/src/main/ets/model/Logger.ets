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

import { hilog } from '@kit.PerformanceAnalysisKit';

class Logger {
  private domain: number;
  private prefix: string;
  private format: string = '%{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0x0001; // 设置域名
  }

  debug(...args: string[]) {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: string[]) {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: string[]) {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: string[]) {
    hilog.error(this.domain, this.prefix, this.format, args);
  }

  fatal(...args: string[]) {
    hilog.fatal(this.domain, this.prefix, this.format, args);
  }

  isLoggable(level: number) {
    hilog.isLoggable(this.domain, this.prefix, level);
  }
}

export default new Logger('[Sample_NetConnection_Exploitation]');