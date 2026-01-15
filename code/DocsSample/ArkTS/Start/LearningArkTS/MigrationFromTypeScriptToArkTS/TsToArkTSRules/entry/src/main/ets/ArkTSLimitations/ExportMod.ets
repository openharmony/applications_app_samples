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

export class Mod {}

export class Something {}

// [Start export_classC]
// lib1.ets。
export class C {
  // ...
}
// [End export_classC]

export class Normalize {}

// [Start declare_namespace]
// 声明。
export declare namespace N {
  function foo(x: number): number
}
// [End declare_namespace]

// [Start no_exportAssignOne]
// module1。
export class Point {
  constructor(x: number, y: number) {}
  public static origin = new Point(0, 0)
}
// [End no_exportAssignOne]

// [Start no_globalThisExport]
// file1。
export let abc: number = 100;
// [End no_globalThisExport]

export function foo() {}
