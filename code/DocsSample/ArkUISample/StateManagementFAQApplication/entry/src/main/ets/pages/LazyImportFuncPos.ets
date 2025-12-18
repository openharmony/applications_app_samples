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

// [Start lazy_import_function_positive]
// src/main/ets/pages/LazyImportFuncPos.ets
// 使用lazy import懒加载包含装饰器的文件。
import lazy { innerTest } from './LazyImportObservedPos';

export function testWithObserved(): void {
  innerTest();
  console.info('ImportObserved::testWithObserved call');
}

export function testWithoutObserved(): void {
  console.info('ImportObserved::testWithoutObserved call');
}
// [End lazy_import_function_positive]