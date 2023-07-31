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
import { selectImageSizeData,selectImageAlignmentData } from '../../UniversialData'
import { getStringArrayData,getStringData } from '../../../../data/ResourceDataHandle'

@Component
export struct ChangePanel {
  @Link imageSize: ImageSize
  @Link alignment: Alignment

  build() {
    Column() {
      CommonItemSelect({
        testId: "test_select1",
        name: $r('app.string.set_background_image_size'),
        selects: getStringArrayData(selectImageSizeData),
        callback: (index) => {
          switch (index) {
            case 0:
              this.imageSize = ImageSize.Cover
              break
            default:
              this.imageSize = ImageSize.Contain
          }
        }
      })

      CommonItemSelect({
        testId: "test_select2",
        name: $r('app.string.set_background_image_position'),
        selects: getStringArrayData(selectImageAlignmentData),
        callback: (index) => {
          switch (index) {
            case 0:
              this.alignment = Alignment.TopStart
              break
            case 1:
              this.alignment = Alignment.Top
              break
            case 2:
              this.alignment = Alignment.TopEnd
              break
            case 3:
              this.alignment = Alignment.Start
              break
            case 4:
              this.alignment = Alignment.Center
              break
            case 5:
              this.alignment = Alignment.End
              break
            case 6:
              this.alignment = Alignment.BottomStart
              break
            case 7:
              this.alignment = Alignment.Bottom
              break
            default:
              this.alignment = Alignment.BottomEnd
          }
        }
      })
    }
  }
}