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

import { collections } from '@kit.ArkTS';

@Sendable
export class Calculator {
  public history?: collections.Array<collections.Array<string>>;
  public totalCount: number = 0;

  static init(): Calculator {
    let calc = new Calculator();
    calc.totalCount = 0;
    calc.history = collections.Array.create(calc.totalCount, collections.Array.create(2, ''));
    return calc;
  }

  add(a: number, b: number) {
    let result = a + b;
    this.newCalc(`${a} + ${b}`, `${result}`);
    return result;
  }

  sub(a: number, b: number) {
    let result = a - b;
    this.newCalc(`${a} - ${b}`, `${result}`);
    return result;
  }

  mul(a: number, b: number) {
    let result = a * b;
    this.newCalc(`${a} * ${b}`, `${result}`);
    return result;
  }

  div(a: number, b: number) {
    let result = a / b;
    this.newCalc(`${a} / ${b}`, `${result}`);
    return result;
  }

  getHistory(): collections.Array<collections.Array<string>> {
    return this.history!;
  }

  showHistory() {
    for (let i = 0; i < this.totalCount; i++) {
      console.info(`${i}: ${this.history![i][0]} = ${this.history![i][1]}`);
    }
  }

  private newCalc(opt: string, ret: string) {
    let newRecord = new collections.Array<string>(opt, ret);
    this.totalCount = this.history!.unshift(newRecord);
  }
}