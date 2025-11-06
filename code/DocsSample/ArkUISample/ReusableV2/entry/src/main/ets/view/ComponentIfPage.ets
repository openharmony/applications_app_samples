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
// [Start Use_in_Repeat_component_If]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@Entry
@ComponentV2
struct ComponentIfPage {
  @Local condition: boolean = true;

  build() {
    Column() {
      // $r('app.string.EntryAbility_RecycleOrReuse')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($r('app.string.EntryAbility_RecycleOrReuse')).onClick(()=>{this.condition=!this.condition;}) // 点击切换回收/复用状态
      if (this.condition) {
        ReusableV2ComponentIf()
      }
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2ComponentIf {
  @Local message: string = 'Hello World';
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToRecycle'); // 回收时被调用
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableV2Component aboutToReuse'); // 复用时被调用
  }
  build() {
    Column() {
      Text(this.message)
    }
  }
}
// [End Use_in_Repeat_component_If]