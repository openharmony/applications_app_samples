/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

const USE_HILOG = false;
const DOMAIN: number = 0xFF00;

export default class Logger {
  private static domain: number = DOMAIN;
  private static prefix: string = '[Sample_VoiceCallDemo]';
  private static format: string = '%{public}, %{public}';

  static debug(...args: string[]): void {
    if (USE_HILOG) {
      hilog.debug(this.domain, this.prefix, this.format, args);
    } else {
      console.debug(this.prefix, args);
    }
  }

  static error(...args: string[]): void {
    if (USE_HILOG) {
      hilog.error(this.domain, this.prefix, this.format, args);
    } else {
      console.error(this.prefix, args);
    }
  }

  static info(...args: string[]): void {
    if (USE_HILOG) {
      hilog.info(this.domain, this.prefix, this.format, args);
    } else {
      console.info(this.prefix, args);
    }
  }

  static log(...args: string[]): void {
    this.info(...args);
  }
}