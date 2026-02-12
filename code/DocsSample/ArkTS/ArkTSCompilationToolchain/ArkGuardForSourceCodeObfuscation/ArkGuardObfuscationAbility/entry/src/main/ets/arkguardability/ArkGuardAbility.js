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

// [Start jsOptionExample_keepPropertyName]
// ArkGuardAbility.js
var obj = {x0: '0', x1: '1', x2: '2'};
for (var i = 0; i <= 2; i++) {
    console.info(obj['x' + i]); // x0, x1, x2应该被保留
}

Object.defineProperty(obj, 'y', {}); // y应该被保留
Object.getOwnPropertyDescriptor(obj, 'y'); // y应该被保留
console.info(obj.y);

obj.s1 = 'a';
let key = 's1';
console.info(obj[key]); // key对应的变量值s1应该被保留

obj.t1 = 'b';
console.info(obj['t' + '1']); // t1应该被保留
// [End jsOptionExample_keepPropertyName]

// [Start jsOptionExample_keepFileName]
// ArkGuardAbility.js
const module1 = require('./RequireFile'); // RequireFile 应该被保留
// [End jsOptionExample_keepFileName]