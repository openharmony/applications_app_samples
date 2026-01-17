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
// [Start no_implicitReturnTypes_ts]
// 只有在开启noImplicitAny选项时会产生编译时错误。
function f(x: number) {
  if (x <= 0) {
    return x;
  }
  return g(x);
}

// 只有在开启noImplicitAny选项时会产生编译时错误。
function g(x: number) {
  return f(x - 1);
}

function doOperation(x: number, y: number) {
  return x + y;
}

f(10);
doOperation(2, 3);
// [End no_implicitReturnTypes_ts]
