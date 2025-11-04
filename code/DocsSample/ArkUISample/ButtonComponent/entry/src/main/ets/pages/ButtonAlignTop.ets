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
const TAG = '[Sample_Button_Component]'

@Entry
@ComponentV2
struct ButtonAlignTop {
  build() {
    RelativeContainer() {
      // [Start button_align_top]
      // [Start button_click]
      ArcButton({
        options: new ArcButtonOptions({
          label: 'OK',
          // [StartExclude button_click]
          position: ArcButtonPosition.TOP_EDGE,
          styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
          // [EndExclude button_click]
          // [StartExclude button_align_top]
          onClick: () => {
            hilog.info(DOMAIN, TAG, 'ArcButton onClick');
          },
          // [EndExclude button_align_top]
        })
      })
      // [End button_align_top]
      // [End button_click]
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
    }
  }
}