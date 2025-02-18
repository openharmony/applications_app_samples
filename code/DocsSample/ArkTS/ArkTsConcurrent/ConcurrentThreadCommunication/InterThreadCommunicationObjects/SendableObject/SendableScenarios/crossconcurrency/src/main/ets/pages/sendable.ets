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

// 定义模拟类Test，模仿开发过程中需传递带方法的class
import { lang, collections } from '@kit.ArkTS'

export type ISendable = lang.ISendable;

@Sendable
export class SendableTestClass {
  public name: string = 'John';
  public age: number = 20;
  public sex: string = 'man';
  public arr: collections.Array<number> = new collections.Array<number>(1, 2, 3);

  constructor() {
  }

  setAge(age: number): void {
    this.age = age;
  }

  printName(): string {
    return this.name;
  }

  printAge(): number {
    return this.age;
  }

  printSex(): string {
    return this.sex;
  }
}