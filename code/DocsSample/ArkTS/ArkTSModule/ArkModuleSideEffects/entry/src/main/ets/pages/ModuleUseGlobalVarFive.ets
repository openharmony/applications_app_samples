/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start export_moduleUseGlobalVarFive]
// ModuleUseGlobalVarFive.ets
import { data1, changeGlobalVar } from './ModulePartFive';
export function useGlobalVar() {
  console.info('data1 is ', data1);
  changeGlobalVar(); // 在需要的时候执行代码，而不是模块加载时执行。
  console.info('globalThis.someGlobalVar is ', globalThis.someGlobalVar);
}
// [End export_moduleUseGlobalVarFive]