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

// [Start scope_name]
// test1.ts
function longFuncName() { // longFuncName的函数名为"#*#longFuncName"，其中"longFuncName"是原函数名，不会转换为索引。
  function A() { } // A的函数名"#*@0*#A"，其中"@0"表示在其对应LiteralArray中，索引为0的字符串，此时这个字符串是"longFuncName"。即这个函数原本的名称为"#*longFuncName*#A"。
  function B() { } // B的函数名"#*@0*#B"。
}
// [End scope_name]