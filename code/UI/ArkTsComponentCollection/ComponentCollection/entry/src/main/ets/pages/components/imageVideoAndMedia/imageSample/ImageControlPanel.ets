/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CommonItemTwoRowSlider, CommonItemSelect, CommonItemColorSelect } from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { OBJECT_FIT_SELECT, RENDER_MODE_SELECT, REPEAT_SELECT } from '../../../components/ComponentData';

@Component
export struct SourceSizeControlPanel {
  @Link sizeHeight: number;
  @Link sizeWidth: number;
  @Link ObjectFit: ImageFit;
  @Link RenderMode: ImageRenderMode;
  @Link ObjectRepeat: ImageRepeat;
  @Link fillColor: Color;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.object_fit_change'),
        selects: getStringArrayData(OBJECT_FIT_SELECT),
        callback: (index) => {
          switch (index) {
            case 1:
              this.ObjectFit = ImageFit.None;
              break;
            case 2:
              this.ObjectFit = ImageFit.Cover;
              break;
            case 3:
              this.ObjectFit = ImageFit.Contain;
              break;
            case 4:
              this.ObjectFit = ImageFit.Fill;
              break;
            case 5:
              this.ObjectFit = ImageFit.ScaleDown;
              break;
            default:
              this.ObjectFit = ImageFit.Auto;
          }
        },testId:'image_001'
      })
      CommonItemTwoRowSlider(
        {
          changeValue: $sizeHeight,
          min: 0,
          max: 110,
          name: $r('app.string.image_sourcesize_height'),
          testId:'image_slider_001'
        }
      )
      CommonItemTwoRowSlider(
        {
          changeValue: $sizeWidth,
          min: 0,
          max: 110,
          name: $r('app.string.image_sourcesize_width'),
          testId:'image_slider_002'
        }
      )
      CommonItemSelect({
        name: $r('app.string.image_renderMode_change'),
        selects: getStringArrayData(RENDER_MODE_SELECT),
        callback: (index) => {
          switch (index) {
            case 1:
              this.RenderMode = ImageRenderMode.Template;
              break;
            default:
              this.RenderMode = ImageRenderMode.Original;
          }
        },testId:'image_select_002'
      })
      CommonItemSelect({
        name: $r('app.string.image_repeat_change'),
        selects: getStringArrayData(REPEAT_SELECT),
        callback: (index) => {
          switch (index) {
            case 1:
              this.ObjectRepeat = ImageRepeat.X;
              break;
            case 2:
              this.ObjectRepeat = ImageRepeat.Y;
              break;
            case 3:
              this.ObjectRepeat = ImageRepeat.XY;
              break;
            default:
              this.ObjectRepeat = ImageRepeat.NoRepeat;
          }
        },testId:'image_select_003'
      })
      CommonItemColorSelect({
        name: $r('app.string.qrcode_color'),
        isItemStyle: true,
        selectColor: $fillColor,
        testId:'image_color_001'
      })
    }
  }
}