/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { Units } from '../common/utils/PixelUnitConversion';
import { OperationActionID } from '../model/Operation';

@Component
export struct FileOperationItem {
  @State image: ResourceStr = '';
  @State imageFocus: ResourceStr = '';
  @State text: ResourceStr = '';
  @Prop visible: boolean;
  @Prop focusId: string;
  @State isFocused: boolean = false;
  @Link specialSelectMod: boolean;
  itemClick?: Function;

  build() {
    Column() {
      Image(this.isFocused ? this.imageFocus : this.image)
        .width(Units.px2vp(80))
        .width(Units.px2vp(80))
        .backgroundColor(this.isFocused ? Color.White : $r('app.color.file_list_item_bg'))
        .padding(Units.px2vp(10))
        .borderRadius(Units.px2vp(40))
        .focusable(true)
        .onClick(() => {
          focusControl.requestFocus(this.focusId);
          if (this.itemClick) {
            this.itemClick();
          }
        });
      if (this.focusId === OperationActionID.SelectAll) {
        Text(!this.specialSelectMod ? $r('app.string.operation_type_all_choice') :
          $r('app.string.operation_type_all_choice_cancel'))
          .fontSize(Units.px2fp(24))
          .fontColor($r('app.color.title_bar_hint_text'))
          .margin({ top: Units.px2vp(12) });
      } else {
        Text(this.text)
          .fontSize(Units.px2fp(24))
          .fontColor($r('app.color.title_bar_hint_text'))
          .margin({ top: Units.px2vp(12) });
      }
    }
    .onHover((isHover) => {
      if (isHover) {
        focusControl.requestFocus(this.focusId);
      }
    })
    .onFocus(() => {
      this.isFocused = true;
    })
    .onBlur(() => this.isFocused = false)
    .onTouch((event) => {
      if (event.type === TouchType.Down) {
        focusControl.requestFocus(this.focusId);
      }
    })
    .margin({ left: Units.px2vp(24), right: Units.px2vp(24) })
    .visibility(this.visible ? Visibility.Visible : Visibility.None)
    .focusable(true)
    .id(this.focusId);

  }
}