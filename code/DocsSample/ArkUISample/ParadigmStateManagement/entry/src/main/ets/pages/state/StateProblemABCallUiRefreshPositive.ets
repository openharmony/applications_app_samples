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

// [Start state_problem_a_b_call_ui_refresh_positive]
class Balloon {
  public volume: number;

  constructor(volume: number) {
    this.volume = volume;
  }

  static increaseVolume(balloon: Balloon) {
    balloon.volume += 2;
  }
}

@Entry
@Component
struct Index {
  @State balloon: Balloon = new Balloon(10);

  reduceVolume(balloon: Balloon) {
    balloon.volume -= 1;
  }

  build() {
    Column({ space: 8 }) {
      Text(`The volume of the balloon is ${this.balloon.volume} cubic centimeters.`)
        .fontSize(30)
      Button(`increaseVolume`)
        .onClick(() => {
          // 通过赋值给临时变量保留Proxy代理
          let balloon1 = this.balloon;
          Balloon.increaseVolume(balloon1);
        })
      Button(`reduceVolume`)
        .onClick(() => {
          // 通过赋值给临时变量保留Proxy代理
          let balloon2 = this.balloon;
          this.reduceVolume(balloon2);
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End state_problem_a_b_call_ui_refresh_positive]

@Component
export struct StateProblemABCallUiRefreshPositive {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_problem_a_b_call_ui_refresh_positive'))
  }
}