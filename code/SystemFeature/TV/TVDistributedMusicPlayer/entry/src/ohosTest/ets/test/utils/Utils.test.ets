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

import log_concurrency_test from './Log.concurrency.test';
import log_detail_test from './Log.detail.test';
import log_test from './Log.test';
import logger_concurrency_test from './Logger.concurrency.test';
import logger_detail_test from './Logger.detail.test';
import logger_test from './Logger.test';
import preferences_concurrency_test from './Preferences.concurrency.test';
import preferences_detail_test from './Preferences.detail.test';
import preferences_test from './Preferences.test';
import utils_concurrency_test from './Utils.concurrency.test';
import utils_detail_test from './Utils.detail.test';

export default function utilstestTest(): void {
  log_concurrency_test();
  log_detail_test();
  log_test();
  logger_concurrency_test();
  logger_detail_test();
  logger_test();
  preferences_concurrency_test();
  preferences_detail_test();
  preferences_test();
  utils_concurrency_test();
  utils_detail_test();
}
