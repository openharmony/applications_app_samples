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
// [Start RepeatPage]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;

@Entry
@ComponentV2
struct Index {
  @Local condition: boolean = true;
  @Local simpleList: number[] = [];
  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.simpleList.push(i)
    }
  }
  build() {
    Column() {
      Button('Change condition')
        .onClick(() => {
          this.condition = !this.condition;
        })
      if (this.condition) {
        // 此处仅做演示使用，让复用池中填充3个组件
        ReusableV2Component({ num: 0 })
        ReusableV2Component({ num: 0 })
        ReusableV2Component({ num: 0 })
      }
      List({ space: 10 }) {
        Repeat(this.simpleList)
          .virtualScroll()
          .each((obj: RepeatItem<number>) => {
            ListItem() {
              Column() {
                ReusableV2Component({ num: obj.item })
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
struct ReusableV2Component {
  @Require @Param num: number;
  aboutToAppear() {
    hilog.info(DOMAIN, TAG, 'ReusableV2Component aboutToAppear');
  }
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, 'ReusableV2Component aboutToRecycle');
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, 'ReusableV2Component aboutToReuse');
  }
  build() {
    Column() {
      Text(`${this.num}`).fontSize(50)
    }
  }
}
// [End RepeatPage]
const repeatPage = Index;
export default repeatPage;