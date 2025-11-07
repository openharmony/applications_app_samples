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
// [Start ComponentEachPage]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@Entry
@ComponentV2
struct Index {
  @Local simpleList: number[] = [1, 2, 3, 4, 5];
  @Local condition: boolean = true;
  build() {
    Column() {
      Button('Delete/Create Repeat')
        .onClick(() => {
          this.condition = !this.condition;
        })
      Button('Add element')
        .onClick(() => {
          this.simpleList.push(this.simpleList.length + 1);
        })
      Button('Delete element')
        .onClick(() => {
          this.simpleList.pop();
        })
      Button('Change element')
        .onClick(() => {
          this.simpleList[0]++;
        })
      if (this.condition) {
        List({ space: 10 }) {
          Repeat(this.simpleList)
            .each((obj: RepeatItem<number>) => {
              ListItem() {
                Column() {
                  ReusableV2Component({ num: obj.item })
                }
              }
            })
        }
      }
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2Component {
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
      Text(`${this.num}`)
    }
  }
}
// [End ComponentEachPage]
const componentEachPage = Index;
export default componentEachPage;
