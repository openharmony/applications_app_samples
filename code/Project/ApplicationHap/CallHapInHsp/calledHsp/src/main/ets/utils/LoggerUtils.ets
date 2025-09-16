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

import { Ilogger } from 'inhar';

export class LoggerUtils {
  private static logger: Ilogger;
  private static loggerUitl: LoggerUtils;

  private LoggerUtils() {
  }

  public static getLoggerUtils(): LoggerUtils {
    if (LoggerUtils.loggerUitl == null || LoggerUtils.loggerUitl == undefined) {
      LoggerUtils.loggerUitl = new LoggerUtils();
    }
    return LoggerUtils.loggerUitl;
  }

  public static registerLogger(loggerParam: Ilogger): void {
    if (loggerParam == null || loggerParam == undefined) {
      return;
    }
    LoggerUtils.logger = loggerParam;
  }

  public static debug(message: string): void {
    LoggerUtils.logger.debug(message);
  }

  public static error(message: string): void {
    LoggerUtils.logger.error(message);
  }

  public static info(message: string): void {
    LoggerUtils.logger.info(message);
  }
}