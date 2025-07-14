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

// [Start ark_napi_has_own_property]
import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

export function napiHasOwnProperty() {
  let myObj = { 'myProperty': 1 };
  let inheritedObj = { 'inheritedProperty': 2 };
  // The Object.setPrototypeOf method is not supported in DevEco Studio 4.1.0.400 and later versions, and must be used in TypeScript (TS).
  Object.setPrototypeOf(myObj, inheritedObj);
  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_own_property my: %{public}s',
    testNapi.napiHasOwnProperty(myObj, 'myProperty'));
  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_own_property inherited: %{public}s',
    testNapi.napiHasOwnProperty(myObj, 'inheritedProperty'));
}
// [End ark_napi_has_own_property]