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

// 是否使用@ohos.hilog记录日志
const USE_HILOG = false;
const DOMAIN: number = 0xFF00;

export default class Logger {
  private static domain: number = DOMAIN;
  // 日志前缀
  private static prefix: string = '[Sample_VoiceCallDemo]';
  //日志格式，暂时支持两个字符串
  private static format: string = '%{public}, %{public}';

  static debug(...args: string[]): void {
    if (USE_HILOG) {
      hilog.debug(Logger.domain, Logger.prefix, Logger.format, args);
    } else {
      console.debug(Logger.prefix, args);
    }
  }

  static error(...args: string[]): void {
    if (USE_HILOG) {
      hilog.error(Logger.domain, Logger.prefix, Logger.format, args);
    } else {
      console.error(Logger.prefix, args);
    }
  }

  static info(...args: string[]): void {
    if (USE_HILOG) {
      hilog.info(Logger.domain, Logger.prefix, Logger.format, args);
    } else {
      console.info(Logger.prefix, args);
    }
  }

  static log(...args: string[]): void {
    Logger.info(...args);
  }
}