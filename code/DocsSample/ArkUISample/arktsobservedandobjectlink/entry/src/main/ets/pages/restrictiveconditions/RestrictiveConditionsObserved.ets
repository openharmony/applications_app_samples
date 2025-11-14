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
// [Start Test_Info_Observed]
@Observed
class Info {
  public count: number;

  constructor(count: number) {
    this.count = count;
  }
}

// [StartExclude Test_Info_Observed]
@Component
struct TestInfo {
  // [EndExclude Test_Info_Observed]
  // 正确写法
  @ObjectLink count: Info;

  // [End Test_Info_Observed]
  build() {

  }
}

// [Start Info_Initialization]
@Observed
class CountInfo {
  public count: number;

  constructor(count: number) {
    this.count = count;
  }
}

// [StartExclude Info_Initialization]
@Component
struct Initialization {
  // [EndExclude Info_Initialization]

  // 正确写法
  @ObjectLink count: CountInfo;

  // [End Info_Initialization]

  build() {

  }
}

@Entry
@Component
struct RestrictiveConditionsObserved {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
    .height('100%')
    .width('100%')
  }
}
export default RestrictiveConditionsObserved;
