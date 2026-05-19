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

// [Start har1_class_calc]
// HAR1's src/main/ets/utils/Calc.ets
export class ClassHar1 {
  public static isImportedHar2: boolean = false;

  static add(a: number, b: number): number {
    const c = a + b;
    console.info('[DynamicImport] ClassHar1.add(), %d + %d = %d', a, b, c);

    if (!ClassHar1.isImportedHar2) {
      const harName = 'har2';
      import(harName).then((ns: ESObject) => {
        ClassHar1.isImportedHar2 = true;
        console.info('[DynamicImport] har1 -> har2, 1 + 2 = ' + ns.ClassHar2.add(1, 2));
      })
    }

    return c;
  }
}
// [End har1_class_calc]
