/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';

@Entry
@Component
struct BindSheetSafeArea {
  @State isShow: boolean = true;

  @Builder myBuilder() {
    Column() {
      TextInput({ placeholder: 'Hint' })
        .position({ x: 0, y: 200 })
        .type(InputType.Password)
        .height(40)
    }
    .width('87%')
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_bindsheet_title') })
      Button("show bindSheet")
        .onClick(() => {
          this.isShow = true;
        })
        .fontSize(20)
        .margin(10)
        .visibility(Visibility.Hidden)
        .bindSheet($$this.isShow, this.myBuilder(), {
          detents: [SheetSize.MEDIUM],
          backgroundColor: Color.White,
          blurStyle: BlurStyle.Thick,
          showClose: true,
          title: { title: 'Title' },
          preferType: SheetType.CENTER,
          shouldDismiss: ((sheetDismiss: SheetDismiss) => {
            sheetDismiss.dismiss();
          })
        })
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
  }
}
