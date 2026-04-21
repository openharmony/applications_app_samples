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

@Component
export struct CustomButton {
  buttonName: Resource | string = '';
  buttonOnClick: (event?: ClickEvent) => void = (): void => {
  };

  build() {
    Row() {
      Button(this.buttonName)
        .type(ButtonType.ROUNDED_RECTANGLE)
        .controlSize(ControlSize.NORMAL)
        .fontColor($r('sys.color.font_emphasize'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .fontWeight(FontWeight.Medium)
        .align(Alignment.Center)
        .width(328)
        .height(40)
        .onClick(this.buttonOnClick)
    }
  }
}