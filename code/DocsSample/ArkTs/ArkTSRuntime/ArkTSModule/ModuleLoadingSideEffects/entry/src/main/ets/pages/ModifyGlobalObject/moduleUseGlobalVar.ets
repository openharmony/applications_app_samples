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

// [Start export_change_some_global_var]
import { data1 } from './module'; // 此时可能预期全局变量someGlobalVar的值为100

export function useGlobalVar() {
  console.log(data1);
  console.log(globalThis.someGlobalVar); // 此时由于main.ets中加载了sideEffectModule模块，someGlobalVar的值已经被改为200
}
// [End export_change_some_global_var]