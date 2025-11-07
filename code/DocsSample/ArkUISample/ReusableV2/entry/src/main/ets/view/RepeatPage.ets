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
// [Start Use_in_the_'each'_attribute_of_the_Repeat_component_in_non_lazy_loading_scenarios]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@Entry
@ComponentV2
struct RepeatPage {
  @Local condition: boolean = true;
  @Local simpleList: number[] = [];

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.simpleList.push(i)
    }
  }

  build() {
    Column() {
      // $r('app.string.EntryAbility_ChangeCondition')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($r('app.string.EntryAbility_ChangeCondition')).onClick(() => {
        this.condition = !this.condition;
      })
      if (this.condition) {
        // 此处仅做演示使用，让复用池中填充3个组件
        ReusableV2ComponentRepeat({ num: 0 })
        ReusableV2ComponentRepeat({ num: 0 })
        ReusableV2ComponentRepeat({ num: 0 })
      }
      List({ space: 10 }) {
        Repeat(this.simpleList)
          .virtualScroll()
          .each((obj: RepeatItem<number>) => {
            ListItem() {
              Column() {
                ReusableV2ComponentRepeat({ num: obj.item })
              }
            }
          })
      }.height('50%')
      .cachedCount(2)
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2ComponentRepeat {
  @Require @Param num: number;
  aboutToAppear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToAppear');
  }
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToRecycle');
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToReuse');
  }
  build() {
    Column() {
      Text(`${this.num}`).fontSize(50)
    }
  }
}
// [End Use_in_the_'each'_attribute_of_the_Repeat_component_in_non_lazy_loading_scenarios]