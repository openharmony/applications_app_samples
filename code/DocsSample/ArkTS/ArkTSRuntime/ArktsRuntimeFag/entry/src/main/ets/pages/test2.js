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

// [Start testTwo_one]
// test2.js
const typedArr = new Uint16Array([10, 20, 30]);
try {
   const result = Object.entries(typedArr);
   console.info('no error throw');
} catch (e) {
   console.info(e);
}
// 期望输出：no error throw
// 实际输出: RangeError: object entries is not supported IsJSUint8Array or IsJSUint16Array
// [End testTwo_one]