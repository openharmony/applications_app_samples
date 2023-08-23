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

import { CommonItemSelect,CommonItemColorSelect } from '../../../../common/AttributeModificationTool';

@Component
export struct textAreaControlPanel {
  @Link placeholderColor: Color;
  @Link textAlign: TextAlign;
  @Link caretColor:Color;
  @Link copyOption: CopyOptions;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.textareaa_textalign_change'),
        selects: [$r('app.string.textarea_textalign_start'),$r('app.string.textarea_textalign_center'),$r('app.string.textarea_textalign_end')],
        callback: (index) => {
          switch (index) {
            case 1:
              this.textAlign = TextAlign.Center;
              break;
            case 2:
              this.textAlign = TextAlign.End;
              break;
            default:
              this.textAlign = TextAlign.Start;
          }
        }, testId:'textarea_select_001'
      })
      CommonItemSelect({
        name: $r('app.string.textarea_copyoptions_change'),
        selects: [$r('app.string.textarea_copyoptions_none'),$r('app.string.textarea_copyoptions_inapp'),$r('app.string.textarea_copyoptions_localdevice')],
        callback: (index) => {
          switch (index) {
            case 1:
              this.copyOption = CopyOptions.InApp;
              break;
            case 2:
              this.copyOption = CopyOptions.LocalDevice;
              break;
            default :
            this.copyOption = CopyOptions.None;
          }
        },testId:'textarea_select_002'
      })
      CommonItemColorSelect({
        name: $r('app.string.textarea_placeholder_change'),
        isItemStyle:true,
        selectColor:$placeholderColor,
        testId:'textarea_color_001'
      })
      CommonItemColorSelect({
        name: $r('app.string.textarea_caretcolor_change'),
        isItemStyle:true,
        selectColor:$caretColor,
        testId:'textarea_color_002'
      })
    }
  }
}
