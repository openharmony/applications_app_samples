/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import BaseModel from '../model/BaseModel';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0500;
const TAG = '[Settings]';

/**
 *  log package tool class
 */
export class LogUtil extends BaseModel {
  debug(msg: string): void {
    hilog.debug(DOMAIN, TAG, msg);
  }

  log(msg: string): void {
    hilog.info(DOMAIN, TAG, msg);
  }

  info(msg: string): void {
    hilog.info(DOMAIN, TAG, msg);
  }

  warn(msg: string): void {
    hilog.warn(DOMAIN, TAG, msg);
  }

  error(msg: string): void {
    hilog.error(DOMAIN, TAG, msg);
  }
}

let mLogUtil = new LogUtil();
export default mLogUtil as LogUtil;
