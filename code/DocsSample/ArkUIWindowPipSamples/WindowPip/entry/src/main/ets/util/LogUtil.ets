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

import { hilog } from '@kit.PerformanceAnalysisKit';

export class Logger {
  private static LOG_DOMAIN = 0x0000;
  private static LOG_TAG = '[Sample_WindowPip]';

  public static info(format: string, ...para: (string | number | boolean | object)[]): void {
    hilog.info(Logger.LOG_DOMAIN, Logger.LOG_TAG, format, ...para);
  }

  public static debug(format: string, ...para: (string | number | boolean | object)[]): void {
    hilog.debug(Logger.LOG_DOMAIN, Logger.LOG_TAG, format, ...para);
  }

  public static warn(format: string, ...para: (string | number | boolean | object)[]): void {
    hilog.warn(Logger.LOG_DOMAIN, Logger.LOG_TAG, format, ...para);
  }

  public static error(format: string, ...para: (string | number | boolean | object)[]): void {
    hilog.error(Logger.LOG_DOMAIN, Logger.LOG_TAG, format, ...para);
  }
}