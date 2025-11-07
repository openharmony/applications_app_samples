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
//[Start Freezing_during_the_reuse_phase]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@Entry
@ComponentV2
struct AboutToRecyclePage {
  @Local condition1: boolean = false;
  @Local condition2: boolean = true;
  build() {
      Column(){
        Button('step1. appear')
          .onClick(() => {
            this.condition1 = true;
          })
        Button('step2. recycle')
          .onClick(() => {
            this.condition2 = false;
          })
        Button('step3. reuse')
          .onClick(() => {
            this.condition2 = true;
          })
        Button('step4. disappear')
          .onClick(() => {
            this.condition1 = false;
          })
        if (this.condition1) {
          NormalV2ComponentAboutToRecycle({ condition: this.condition2 })
        }
      }
    }
}
@ComponentV2
struct NormalV2ComponentAboutToRecycle {
  @Require @Param condition: boolean;
  build() {
    if (this.condition) {
      ReusableV2Component()
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2Component {
  aboutToAppear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToAppear called'); // 组件创建时调用
  }
  aboutToDisappear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToDisappear called'); // 组件销毁时调用
  }
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToRecycle called'); // 组件回收时调用
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToReuse called'); // 组件复用时调用
  }
  build() {
    Column() {
      Text('ReusableV2Component')
    }
  }
}
//[End Freezing_during_the_reuse_phase]