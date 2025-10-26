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

// [Start once_param_modify_init]
@ObservedV2
class Info {
  @Trace name: string;
  constructor(name: string) {
    this.name = name;
  }
}
@ComponentV2
struct Child {
  @Param @Once onceParamNum: number = 0;
  @Param @Once @Require onceParamInfo: Info;

  build() {
    Column() {
      Text(`Child onceParamNum: ${this.onceParamNum}`)
      Text(`Child onceParamInfo: ${this.onceParamInfo.name}`)
      Button('changeOnceParamNum')
        .onClick(() => {
          this.onceParamNum++;
        })
      Button('changeParamInfo')
        .onClick(() => {
          this.onceParamInfo = new Info('Cindy');
        })
    }
  }
}
@Entry
@ComponentV2
struct Index {
  @Local localNum: number = 10;
  @Local localInfo: Info = new Info('Tom');

  build() {
    Column() {
      Text(`Parent localNum: ${this.localNum}`);
      Text(`Parent localInfo: ${this.localInfo.name}`);
      Button('changeLocalNum')
        .onClick(() => {
          this.localNum++;
        });
      Button('changeLocalInfo')
        .onClick(() => {
          this.localInfo = new Info('Cindy');
        });
      Child({
        onceParamNum: this.localNum,
        onceParamInfo: this.localInfo
      });
    }
  }
}
// [End once_param_modify_init]