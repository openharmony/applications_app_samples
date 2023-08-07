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

import { CommonItemSlider, CommonItemSelect, CommonItemColorSelect } from '../../../../common/AttributeModificationTool'
import { selectData } from '../../ComponentData'
import { getStringArrayData } from '../../../../data/ResourceDataHandle'

@Component
export struct ChangeVerticalAlign {
  @Link imageSpanAlignment: ImageSpanAlignment

  build() {
    Column() {
      CommonItemSelect({
        testId: 'alignment',
	name: $r('app.string.image_span_vertical_align'),
        selects: [$r('app.string.image_span_alignment_baseline'),
        $r('app.string.image_span_alignment_center'),
        $r('app.string.image_span_alignment_top'),
        $r('app.string.image_span_alignment_bottom')],
        callback: (index) => {
          switch (index) {
            case 0:
              this.imageSpanAlignment = ImageSpanAlignment.BASELINE
              break
            case 1:
              this.imageSpanAlignment = ImageSpanAlignment.CENTER
              break
            case 2:
              this.imageSpanAlignment = ImageSpanAlignment.TOP
              break
            default:
              this.imageSpanAlignment = ImageSpanAlignment.BOTTOM
          }
        }
      })
        .margin({ top: 12 })
    }
  }
}
@Component
export struct ChangeObjectFit {
  @Link imageFit : ImageFit

  build() {
    Column() {
      CommonItemSelect({
        testId: 'fit',
	name: $r('app.string.image_span_object_fit'),
        selects: [$r('app.string.image_fit_contain'),
        $r('app.string.image_fit_auto'),
        $r('app.string.image_fit_fill'),
        $r('app.string.image_fit_none'),
        $r('app.string.image_fit_cover')],
        callback: (index) => {
          switch (index) {
            case 0:
              this.imageFit = ImageFit.Contain
              break
            case 1:
              this.imageFit = ImageFit.Auto
              break
            case 2:
              this.imageFit = ImageFit.Fill
              break
            case 3:
              this.imageFit = ImageFit.ScaleDown
              break
            case 4:
              this.imageFit = ImageFit.None
              break
            default:
              this.imageFit = ImageFit.Cover
          }
        }
      })
        .margin({ top: 12 })
    }
  }
}
