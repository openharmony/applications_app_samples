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

import CalendarPickerDialogPageTest from './CalendarPickerDialogPage.test';
import ContextPageTest from './ContextPage.test';
import LocalStoragePageTest from './LocalStoragePage.test';
import NewGlobalTest from './NewGlobal.test';
import VpPageTest from './VpPage.test';
import WindowTestPageTest from './WindowTestPage.test';

export default function testsuite() {
  ContextPageTest();
  LocalStoragePageTest();
  CalendarPickerDialogPageTest();
  NewGlobalTest();
  VpPageTest();
  WindowTestPageTest()
}