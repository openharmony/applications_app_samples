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
import hilog from '@ohos.hilog';

const TAG = 'Laval-BetaClub_Default';

const LOG_DOMAIN = 0x0102;

export default class LogManager {
  public static log(tag: string, msg: string) {
    console.log(`${TAG} tag: ${tag} --> ${msg}`);
  }

  public static hilogD(msg: string) {
    if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.DEBUG)) {
      hilog.debug(LOG_DOMAIN, TAG, msg);
    }
  }

  public static hilogI(msg: string) {
    if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.INFO)) {
      hilog.info(LOG_DOMAIN, TAG, msg);
    }
  }

  public static hilogIWithTag(tag: string, msg: string) {
    if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.INFO)) {
      hilog.info(LOG_DOMAIN, TAG, `tag: ${tag} --> ${msg}`);
    }
  }

  public static hilogEWithTag(tag: string, msg: string) {
    if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.ERROR)) {
      hilog.error(LOG_DOMAIN, TAG, `tag: ${tag} --> ${msg}`);
    }
  }
};