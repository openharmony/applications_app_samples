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
// [Start dynamic_rerendering_with_component_v2_incorrect_usage]
@ObservedV2
class ParamTemp {
  @Trace public count : number = 0;
}

@Builder
function renderNumber(paramNum: number) {
  Text(`paramNum : ${paramNum}`)
    .fontSize(30)
    .fontWeight(FontWeight.Bold)
}

@Entry
@ComponentV2
struct PageBuilderIncorrectUsage {
  @Local classValue: ParamTemp = new ParamTemp();
  // 此处使用简单数据类型不支持刷新UI的能力。
  @Local numValue: number = 0;
  private progressTimer: number = -1;

  aboutToAppear(): void {
    this.progressTimer = setInterval(() => {
      if (this.classValue.count < 100) {
        this.classValue.count += 5;
        this.numValue += 5;
      } else {
        clearInterval(this.progressTimer);
      }
    }, 500);
  }

  build() {
    Column() {
      renderNumber(this.numValue)
    }
    .width('100%')
    .height('100%')
    .padding(50)
  }
}
// [Start dynamic_rerendering_with_component_v2_incorrect_usage]