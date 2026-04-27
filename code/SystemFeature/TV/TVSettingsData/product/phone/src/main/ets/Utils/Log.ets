/**
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

const DOMAIN: number = 0x0500;
const TAG = 'SettingsData';

/**
 * Basic log class
 */
export class Log {
    /**
     * Outputs info-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static I(format: string, ...args: any[]) {
        if (Log.isLoggable(hilog.LogLevel.INFO)) {
            hilog.info(DOMAIN, TAG, format, ...args);
        }
    }

    /**
    * Outputs debug-level logs.
    *
    * @param tag Identifies the log tag.
    * @param format Indicates the log format string.
    * @param args Indicates the log parameters.
    * @since 7
    */
    static D(format: string, ...args: any[]) {
        if (Log.isLoggable(hilog.LogLevel.DEBUG)) {
            hilog.debug(DOMAIN, TAG, format, ...args);
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
    static W(format: string, ...args: any[]) {
        if (Log.isLoggable(hilog.LogLevel.WARN)) {
            hilog.warn(DOMAIN, TAG, format, ...args);
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
    static E(format: string, ...args: any[]) {
        if (Log.isLoggable(hilog.LogLevel.ERROR)) {
            hilog.error(DOMAIN, TAG, format, ...args);
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
    static F(format: string, ...args: any[]) {
        if (Log.isLoggable(hilog.LogLevel.FATAL)) {
            hilog.fatal(DOMAIN, TAG, format, ...args);
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
