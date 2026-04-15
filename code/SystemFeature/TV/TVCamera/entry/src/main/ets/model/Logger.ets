/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
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
  private format: string = '%{public}s, %{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
  }

  debug(tag: string, ...args: (string | number | boolean | object)[]) {
    const message = args.map(arg => JSON.stringify(arg)).join(', ');
    hilog.debug(this.domain, tag, '%{public}s', message);
  }

  info(tag: string, ...args: (string | number | boolean | object)[]) {
    const message = args.map(arg => JSON.stringify(arg)).join(', ');
    hilog.info(this.domain, tag, '%{public}s', message);
  }

  warn(tag: string, ...args: (string | number | boolean | object)[]) {
    const message = args.map(arg => JSON.stringify(arg)).join(', ');
    hilog.warn(this.domain, tag, '%{public}s', message);
  }

  error(tag: string, ...args: (string | number | boolean | object)[]) {
    const message = args.map(arg => JSON.stringify(arg)).join(', ');
    hilog.error(this.domain, tag, '%{public}s', message);
  }
}

export default new Logger('[Sample_Camera]');
