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

import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

class Balloon {
  public volume: number;

  constructor(volume: number) {
    this.volume = volume;
  }

  // [Start case_a_b_call_error_increaseVolume]
  static increaseVolume(balloon: Balloon) {
    // 修改属性前，通过canBeObserved来判断入参balloon对象是否可被观察
    hilog.info(0x00, 'test_log', `res: ${JSON.stringify(UIUtils.canBeObserved(balloon))}`);
    balloon.volume += 2;
  }
  // [End case_a_b_call_error_increaseVolume]
}

@Entry
@Component
struct Index {
  @State balloon: Balloon = new Balloon(10);

  // [Start case_a_b_call_error_reduceVolume]
  reduceVolume(balloon: Balloon) {
    // 修改属性前，通过canBeObserved来判断入参balloon对象是否可被观察
    hilog.info(0x00, 'test_log', `res: ${JSON.stringify(UIUtils.canBeObserved(balloon))}`);
    balloon.volume -= 1;
  }
  // [End case_a_b_call_error_reduceVolume]

  build() {
    Column({ space: 8 }) {
      Text(`The volume of the balloon is ${this.balloon.volume} cubic centimeters.`)
        .fontSize(30)
      Button(`increaseVolume`)
        .onClick(() => {
          // 通过静态方法调用，无法触发UI刷新
          Balloon.increaseVolume(this.balloon);
        })
      Button(`reduceVolume`)
        .onClick(() => {
          // 使用this通过自定义组件内部方法调用，无法触发UI刷新
          this.reduceVolume(this.balloon);
        })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
export struct StateProblemABCallUiRefreshOpposite {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.EntryAbility_label'))
  }
}