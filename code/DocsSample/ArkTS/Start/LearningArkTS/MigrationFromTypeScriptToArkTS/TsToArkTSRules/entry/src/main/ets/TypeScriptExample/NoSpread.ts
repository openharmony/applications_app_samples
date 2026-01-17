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
// [Start no_spreadOne_ts]
function foo(x: number, y: number, z: number) {
  // ...
}

let args: [number, number, number] = [0, 1, 2];
foo(...args);
// [End no_spreadOne_ts]

// [Start no_spreadTwo_ts]
let point2d = { x: 1, y: 2 };
let point3d = { ...point2d, z: 3 };
// [End no_spreadTwo_ts]
