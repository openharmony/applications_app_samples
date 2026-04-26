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

const DOMAIN: number = 0x001A;
const TAG = 'SystemUI_Default';
const SYMBOL = ' --> ';
const FILTER_KEYS = [
  new RegExp('hide', 'gi')
];

type LogArg = string | number | boolean;

export function filterKey(
  target: Object,
  propKey: string,
  descriptor: TypedPropertyDescriptor<(...args: string[]) => void>
): void {
  const original = descriptor.value;
  if (!original) {
    return;
  }
  descriptor.value = (...args: string[]): void => {
    const filterResult: string[] = args.map((str: string) => {
      let tempStr: string = str;
      FILTER_KEYS.forEach((filterKey: RegExp) => {
        tempStr = tempStr.replace(filterKey, '**');
      });
      return tempStr;
    });
    original(...filterResult);
  };
}

/**
 * Basic log class
 */
export default class Log {
    /**
     * Outputs debug-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static showDebug(tag: string, format: string, ...args: LogArg[]): void {
        if (Log.isLoggable(hilog.LogLevel.DEBUG)) {
            hilog.debug(DOMAIN, TAG, tag + SYMBOL + format, ...args);
        }
    }

    /**
     * Outputs info-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static showInfo(tag: string, format: string, ...args: LogArg[]): void {
        if (Log.isLoggable(hilog.LogLevel.INFO)) {
            hilog.info(DOMAIN, TAG, tag + SYMBOL + format, ...args);
        }
    }

    /**
     * Outputs warning-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static showWarn(tag: string, format: string, ...args: LogArg[]): void {
        if (Log.isLoggable(hilog.LogLevel.WARN)) {
            hilog.warn(DOMAIN, TAG, tag + SYMBOL + format, ...args);
        }
    }

    /**
     * Outputs error-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static showError(tag: string, format: string, ...args: LogArg[]): void {
        if (Log.isLoggable(hilog.LogLevel.ERROR)) {
            hilog.error(DOMAIN, TAG, tag + SYMBOL + format, ...args);
        }
    }

    /**
     * Outputs fatal-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static showFatal(tag: string, format: string, ...args: LogArg[]): void {
        if (Log.isLoggable(hilog.LogLevel.FATAL)) {
            hilog.fatal(DOMAIN, TAG, tag + SYMBOL + format, ...args);
        }
    }

    /**
     * Checks whether logs of the specified tag, and level can be printed.
     *
     * @param tag Identifies the log tag.
     * @param level log level
     * @since 7
     */
    private static isLoggable(level: hilog.LogLevel): boolean {
        return hilog.isLoggable(DOMAIN, TAG, level);
    }
}
