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
// [Start Use_in_ForEach_component]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@Entry
@ComponentV2
struct ComponentForEachPage {
  @Local simpleList: number[] = [0, 1, 2, 3, 4, 5];

  build() {
    Column() {
      ForEach(this.simpleList, (num: number, index) => {
        Row() {
          // $r('app.string.EntryAbility_ClickEdit')需要替换为开发者所需的字符串（图像、数字等）资源文件
          Button($r('app.string.EntryAbility_ClickEdit')).onClick(()=>{this.simpleList[index]++;})
          ReusableV2ComponentForEach({ num: num })
        }
      }) // 每次修改完key发生变化
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2ComponentForEach {
  @Require @Param num: number;
  aboutToAppear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToAppear', this.num); // 创建时触发
  }
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToRecycle', this.num); // 回收时触发
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToReuse', this.num); // 复用时触发
  }
  build() {
    Column() {
      Text(`child: ${this.num}`)
    }
  }
}
// [End Use_in_ForEach_component]