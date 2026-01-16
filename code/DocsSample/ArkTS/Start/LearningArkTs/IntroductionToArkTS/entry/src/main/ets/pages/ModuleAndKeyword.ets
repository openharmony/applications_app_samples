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

// [Start module_import_all]
import * as module from '@kit.AbilityKit';
// [End module_import_all]
// [Start module_import_as]
import * as Utils from './utils';
// [StartExclude module_import_as]
// [Start module_import_ident]
import { X, Y } from './utils';
// [StartExclude module_import_ident]
export {};
// [Start module_dynamic_import_ets]
// Index.ets
import('./Calc').then((obj: ESObject) => {
  console.info(obj.add(3, 5));
}).catch((err: Error) => {
  console.error('Module dynamic import error: ', err);
});
// [End module_dynamic_import_ets]
// [EndExclude module_import_as]
Utils.X // 表示来自Utils的X
Utils.Y // 表示来自Utils的Y
// [End module_import_as]
// [EndExclude module_import_ident]
X // 表示来自utils的X
Y // 表示来自utils的Y
// [End module_import_ident]
// [Start module_export]
export class Point {
  public x: number = 0;
  public y: number = 0;
  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}
export let origin = new Point(0, 0);
export function Distance(p1: Point, p2: Point): number {
  return Math.sqrt((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y));
}
// [End module_export]
// [Start module_default_export]
class Demo{
  constructor(){
  }
}
export default new Demo();
// [End module_default_export]
// [Start module_default_import_async]
async function test() {
  let ns = await import('./say');
  let hi = ns.hi;
  let bye = ns.bye;
  hi();
  bye();
}
// [End module_default_import_async]
// [Start this_example]
class A {
  private count: string = 'a';
  m(i: string): void {
    this.count = i;
  }
}
// [End this_example]