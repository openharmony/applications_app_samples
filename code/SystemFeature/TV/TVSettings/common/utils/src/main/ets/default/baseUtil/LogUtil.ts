/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import BaseModel from '../model/BaseModel';
import HiLog from "@ohos.hilog"

const DOMAIN = 0x0500;
const TAG = "[Settings]"

/**
 *  log package tool class
 */
export class LogUtil extends BaseModel {
  debug(msg): void {
    HiLog.debug(DOMAIN, TAG, msg);
  }

  log(msg): void {
    HiLog.info(DOMAIN, TAG, msg);
  }

  info(msg): void {
    HiLog.info(DOMAIN, TAG, msg);
  }

  warn(msg): void {
    HiLog.warn(DOMAIN, TAG, msg);
  }

  error(msg): void {
    HiLog.error(DOMAIN, TAG, msg);
  }
}

let mLogUtil = new LogUtil();
export default mLogUtil as LogUtil
;
