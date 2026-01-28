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
// [Start define_sendable]
// pages/Sendable.ets
'use shared'
@Sendable
export class A {
  public name: string = 'name';
  printName(): string {
    return this.name;
  }
}
// [End define_sendable]

// [Start define_sendableTwo]
// sendable.ets，与Index.ets在同级目录下
@Sendable
export class TestClass {
  public name: string = 'test';
  setName(name: string) {
    this.name = name;
  }
  getName(): string {
    return this.name;
  }
}
// [End define_sendableTwo]

// [Start define_sendableThree]
// sendable.ets
@Sendable
export class SendableItem {
  public name: string = '';
}
// [End define_sendableThree]