/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

const DOMAIN: number = 0x001b;
const TAG = 'Launcher_Default';
const SYMBOL = ' --> '
type LogArg = string | number | boolean | object | null | undefined;

export class Log {
  static showInfo(tag: string, format: string, ...args: LogArg[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.INFO)) {
      hilog.info(DOMAIN, TAG, tag + SYMBOL + format, args);
    }
  }

  static showDebug(tag: string, format: string, ...args: LogArg[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.DEBUG)) {
      hilog.debug(DOMAIN, TAG, tag + SYMBOL + format, args);
    }
  }

  static showWarn(tag: string, format: string, ...args: LogArg[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.WARN)) {
      hilog.warn(DOMAIN, TAG, tag + SYMBOL + format, args);
    }
  }

  static showError(tag: string, format: string, ...args: LogArg[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.ERROR)) {
      hilog.error(DOMAIN, TAG, tag + SYMBOL + format, args);
    }
  }

  static showFatal(tag: string, format: string, ...args: LogArg[]) {
    if (Log.isLoggable(tag, hilog.LogLevel.FATAL)) {
      hilog.fatal(DOMAIN, TAG, tag + SYMBOL + format, args);
    }
  }

  private static isLoggable(tag: string, level: hilog.LogLevel): boolean {
    return hilog.isLoggable(DOMAIN, tag, level);
  }
}
