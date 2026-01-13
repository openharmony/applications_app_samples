/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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
  private static readonly DOMAIN: number = 0xFF00;
  private static readonly TAG: string = 'com.example.customcamera';
  private static readonly PREFIX: string = '[camera-log]';

  public static debug(logTag: string, messageFormat: string, ...args: Object[]): void {
    hilog.debug(Logger.DOMAIN, Logger.TAG, `${Logger.PREFIX} ${logTag}: ${messageFormat}`, args);
  }

  public static info(logTag: string, messageFormat: string, ...args: Object[]): void {
    hilog.info(Logger.DOMAIN, Logger.TAG, `${Logger.PREFIX} ${logTag}: ${messageFormat}`, args);
  }

  public static warn(logTag: string, messageFormat: string, ...args: Object[]): void {
    hilog.warn(Logger.DOMAIN, Logger.TAG, `${Logger.PREFIX} ${logTag}: ${messageFormat}`, args);
  }

  public static error(logTag: string, messageFormat: string, ...args: Object[]): void {
    hilog.error(Logger.DOMAIN, Logger.TAG, `${Logger.PREFIX} ${logTag}: ${messageFormat}`, args);
  }

  public static fatal(logTag: string, messageFormat: string, ...args: Object[]): void {
    hilog.fatal(Logger.DOMAIN, Logger.TAG, `${Logger.PREFIX} ${logTag}: ${messageFormat}`, args);
  }

  private constructor() {
  }
}
