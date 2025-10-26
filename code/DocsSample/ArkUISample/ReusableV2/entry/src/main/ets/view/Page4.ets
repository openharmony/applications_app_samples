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
import { NormalV2Component } from '../common/NormalV2Component';
@Entry
@ComponentV2
struct Page4 {
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
          NormalV2Component({ condition: this.condition2 })
        }
      }
    }
}
//[End Freezing_during_the_reuse_phase]