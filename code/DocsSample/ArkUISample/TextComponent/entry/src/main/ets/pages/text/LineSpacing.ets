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
// xxx.ets
// [Start Line_Spacing]
import { LengthMetrics } from '@kit.ArkUI';

@Extend(Text)
function style() {
  .width(250)
  .height(100)
  .maxFontSize(30)
  .minFontSize(15)
  .border({ width: 1 })
}

@Entry
@Component
export struct LineSpacing {
  build() {
    NavDestination() {
      Column() {
        Text('The line spacing of this context is set to 20_px, and the spacing is effective only between the lines.')
          .lineSpacing(LengthMetrics.px(20), { onlyBetweenLines: true })
          .style()
      }
    }
    // [StartExclude Line_Spacing]
    .backgroundColor('#f1f 2f3')
    .title($r('app.string.Set_text_line_spacing'))
    // [EndExclude Line_Spacing]
  }
}

// [End Line_Spacing]