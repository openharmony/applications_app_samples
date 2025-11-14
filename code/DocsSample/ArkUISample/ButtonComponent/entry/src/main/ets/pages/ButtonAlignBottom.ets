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

import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xF811;
const TAG = '[Sample_Button_Component]';

@Entry
@ComponentV2
struct ButtonAlignBottom {
  build() {
    RelativeContainer() {
      // [Start button_align_bottom]
      // [Start button_touch]
      ArcButton({
        options: new ArcButtonOptions({
          label: 'OK',
          // [StartExclude button_touch]
          position: ArcButtonPosition.BOTTOM_EDGE,
          styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
          // [EndExclude button_touch]
          // [StartExclude button_align_bottom]
          onTouch: (event: TouchEvent) => {
            hilog.info(DOMAIN, TAG, 'ArcButton onTouch');
          }
          // [EndExclude button_align_bottom]
        })

      })
      // [End button_touch]
      // [End button_align_bottom]
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
    }
  }
}