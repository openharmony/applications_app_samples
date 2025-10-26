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

@Component
export struct LocalGlobalFunctionExtension {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };

  build() {
    NavDestination() {
      FancyUse()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.global_function_extension'))
  }
}

// [Start Extend_Global_Function_Extension_one]

// @Extend(Text)可以支持Text的私有属性fontColor
@Extend(Text)
function fancy() {
  .fontColor(Color.Red)
}

// superFancyText可以调用预定义的fancy
@Extend(Text)
function superFancyText(size: number) {
  .fontSize(size)
  .fancy()
}

@Entry
@Component
struct FancyUse {
  build() {
    Column({ space: 10 }) {
      Text('Fancy text color : red')
        .fancy()
      Text('superFancyText size : 24')
        .superFancyText(24)
    }
  }
}
// [End Extend_Global_Function_Extension_one]