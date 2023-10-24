/**
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

@CustomDialog
export struct SelectDialog {
  private menus: Array<string> = [];
  private doOperation: (index: number) => void = () => {
  };
  controller?: CustomDialogController;

  build() {
    Column() {
      ForEach(this.menus, (item: string, index: number) => {
        Row() {
          Button() {
            Text(item)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r("app.color.list_content"))
          }
          .width('100%')
          .height(48)
          .type(ButtonType.Normal)
          .backgroundColor($r("app.color.white"))
          .onClick(() => {
            this.controller?.close();
            this.doOperation(index);
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }, (index: string) => index)
    }
    .borderRadius(20)
    .width('100%')
  }
}