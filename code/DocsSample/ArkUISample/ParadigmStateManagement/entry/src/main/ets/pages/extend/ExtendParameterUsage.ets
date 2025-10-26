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
export struct LocalExtendParameterUsage {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };

  build() {
    NavDestination() {
      FancyUse()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.extend_parameter_usage'))
  }
}

// [Start Extend_private_property_fancy_two]
// xxx.ets
@Extend(Text)
function fancy(fontSize: number) {
  .fontColor(Color.Red)
  .fontSize(fontSize)
}

@Entry
@Component
struct FancyUse {
  build() {
    Row({ space: 10 }) {
      Text('Fancy')
        .fancy(16)
      Text('Fancy')
        .fancy(24)
    }
  }
}
// [End Extend_private_property_fancy_two]