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

// [Start ark_napi_delete_property]
import testNapi from 'libentry.so';
import { hilog } from '@kit.PerformanceAnalysisKit';

export function napiDeleteProperty() {
  class Obj {
    first: number = 0;
  }

  let obj: Obj = { first: 1 };
  hilog.info(0x0000, 'testTag', 'Test Node-API napi_delete_property first: %{public}s',
    testNapi.deleteProperty(obj, 'first'));
  //设置新的属性为不可配置
  //这里的Object.defineProperty方法在DevEco Studio 4.1.0.400及其以上版本不支持，需在ts使用
  Object.defineProperty(obj, 'config', {
    configurable: false,
    value: 'value'
  })
  hilog.info(0x0000, 'testTag', 'Test Node-API napi_delete_property config: %{public}s',
    testNapi.deleteProperty(obj, 'config'));
}
// [End ark_napi_delete_property]