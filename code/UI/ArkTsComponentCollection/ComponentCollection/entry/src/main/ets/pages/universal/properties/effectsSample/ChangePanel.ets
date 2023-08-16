/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { CommonItemSelect } from '../../../../common/AttributeModificationTool'
import { selectBlurStyleColorModeData,  selectBlurStyleAdaptiveColorData, selectShadowTypeData} from '../../UniversialData'
import { getStringArrayData,getStringData } from '../../../../data/ResourceDataHandle'

@Component
export struct BackgroundBlurChangePanel {
  @Link mColorMode: ThemeColorMode
  @Link mAdaptiveColor: AdaptiveColor

  build() {
    Column() {
      CommonItemSelect({
        testId: "test_select1",
        name: $r('app.string.set_background_blur_style_color_mode'),
        selects: getStringArrayData(selectBlurStyleColorModeData),
        callback: (index) => {
          switch (index) {
            case 0:
              this.mColorMode = ThemeColorMode.SYSTEM
              break
            case 1:
              this.mColorMode = ThemeColorMode.LIGHT
              break
            default:
              this.mColorMode = ThemeColorMode.DARK
          }
        }
      })

      CommonItemSelect({
        testId: "test_select2",
        name: $r('app.string.set_background_blur_style_adaptive_color'),
        selects: getStringArrayData(selectBlurStyleAdaptiveColorData),
        callback: (index) => {
          switch (index) {
            case 0:
              this.mAdaptiveColor = AdaptiveColor.DEFAULT
              break
            default:
              this.mAdaptiveColor = AdaptiveColor.AVERAGE
          }
        }
      })
    }
  }
}

@Component
export struct ShadowChangePanel {
  @Link mShadowType: ShadowType

  build() {
    Column() {
      CommonItemSelect({
        testId: "test_select1",
        name: $r('app.string.set_shadow_type'),
        selects: getStringArrayData(selectShadowTypeData),
        callback: (index) => {
          switch (index) {
            case 0:
              this.mShadowType = ShadowType.COLOR
              break
            default:
              this.mShadowType = ShadowType.BLUR
          }
        }
      })
    }
  }
}