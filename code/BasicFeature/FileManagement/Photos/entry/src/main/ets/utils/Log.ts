/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import HiLog from '@ohos.hilog';

export class Log {
  private static readonly DOMAIN = 0xF811;
  private static readonly TAG: string = '[Sample_Photos]';
  public static readonly LEVEL_DEBUG = HiLog.LogLevel.DEBUG;
  public static readonly LEVEL_INFO = HiLog.LogLevel.INFO;
  public static readonly LEVEL_WARN = HiLog.LogLevel.WARN;
  public static readonly LEVEL_ERROR = HiLog.LogLevel.ERROR;
  public static readonly LEVEL_FATAL = HiLog.LogLevel.FATAL;
  public static LOG_LEVEL = Log.LEVEL_INFO;

  public static debug(TAG: string, message: string): void {
    if (this.LOG_LEVEL <= this.LEVEL_DEBUG) {
      HiLog.debug(this.DOMAIN, this.TAG, '[' + TAG + ']: ' + message);
    }
  }

  public static info(TAG: string, message: string): void {
    if (this.LOG_LEVEL <= this.LEVEL_INFO) {
      HiLog.info(this.DOMAIN, this.TAG, '[' + TAG + ']: ' + message);
    }
  }

  public static warn(TAG: string, message: string): void {
    if (this.LOG_LEVEL <= this.LEVEL_WARN) {
      HiLog.warn(this.DOMAIN, this.TAG, '[' + TAG + ']: ' + message);
    }
  }

  public static error(TAG: string, message: string): void {
    if (this.LOG_LEVEL <= this.LEVEL_ERROR) {
      HiLog.error(this.DOMAIN, this.TAG, '[' + TAG + ']: ' + message);
    }
  }

  public static fatal(TAG: string, message: string): void {
    if (this.LOG_LEVEL <= this.LEVEL_FATAL) {
      HiLog.info(this.DOMAIN, this.TAG, '[' + TAG + ']: ' + message);
    }
  }
}