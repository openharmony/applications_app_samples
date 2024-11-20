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

import { hilog } from '@kit.PerformanceAnalysisKit';

export class Logger {
  static domain: number = 0xFF00;
  static prefix: string = '[Sample_Add_Form]';
  static format: string = '%{public}s, %{public}s';

  static debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  static info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  static warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  static error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }

  static fatal(...args: string[]): void {
    hilog.fatal(this.domain, this.prefix, this.format, args);
  }
}

export default Logger;