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

// [Start across_concurrent_instance_transfer_large_data]
// 将数据量较大的数据在Sendable class中组装
@Sendable
export class TestTypeA {
  public name: string = 'A';
  constructor(name: string) {
    this.name = name;
  }
}

@Sendable
export class TestTypeB {
  public name: string = 'B';
  constructor(name: string) {
    this.name = name;
  }
}

@Sendable
export class Test {
  public data1: TestTypeA;
  public data2: TestTypeB;
  constructor(arg1: TestTypeA, arg2: TestTypeB) {
    this.data1 = arg1;
    this.data2 = arg2;
  }
}
// [End across_concurrent_instance_transfer_large_data]