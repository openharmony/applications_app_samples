/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog'

export class Logger {
  static PREFIX: string = '[Sample_Settings]'
  static DOMAIN: number = 0xFF00
  static FORMAT: string = '%{public}s, %{public}s'

  static debug(...args: any[]) {
    hilog.debug(Logger.DOMAIN, Logger.PREFIX, Logger.FORMAT, args)
  }

  static info(...args: any[]) {
    hilog.info(Logger.DOMAIN, Logger.PREFIX, Logger.FORMAT, args)
  }

  static warn(...args: any[]) {
    hilog.warn(Logger.DOMAIN, Logger.PREFIX, Logger.FORMAT, args)
  }

  static error(...args: any[]) {
    hilog.error(Logger.DOMAIN, Logger.PREFIX, Logger.FORMAT, args)
  }
}