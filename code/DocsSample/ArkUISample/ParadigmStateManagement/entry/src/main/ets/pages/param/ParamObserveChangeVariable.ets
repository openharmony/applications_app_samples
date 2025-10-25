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

@Component
export struct ParamObserveChangeVariable {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_observe_change_variable'))
  }
}

// [Start Param_Observe_Change_Variable]
@Entry
@ComponentV2
struct Index {
  // 点击的次数
  @Local count: number = 0;
  @Local message: string = 'Hello';
  @Local flag: boolean = false;

  build() {
    Column() {
      Text(`Local ${this.count}`)
      Text(`Local ${this.message}`)
      Text(`Local ${this.flag}`)
      Button('change Local')
        .onClick(() => {
          // 对数据源的更改会同步给子组件
          this.count++;
          this.message += ' World';
          this.flag = !this.flag;
        })
      Child({
        count: this.count,
        message: this.message,
        flag: this.flag
      })
    }
  }
}

@ComponentV2
struct Child {
  @Require @Param count: number;
  @Require @Param message: string;
  @Require @Param flag: boolean;

  build() {
    Column() {
      Text(`Param ${this.count}`)
      Text(`Param ${this.message}`)
      Text(`Param ${this.flag}`)
    }
  }
}
// [End Param_Observe_Change_Variable]