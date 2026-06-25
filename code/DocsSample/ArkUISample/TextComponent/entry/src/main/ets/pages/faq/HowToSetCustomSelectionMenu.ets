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

// [Start How_To_Set_Custom_Selection_Menu]
@Entry
@Component
export struct HowToSetCustomSelectionMenuExample {
  @State selectStart: number = 0;
  @State selectEnd: number = 0;

  build() {
    NavDestination() {
      Column() {
        Column() {
          // 请将$r('app.string.Set_Custom_Selection_Menu_Example_String')替换为实际资源文件，在本示例中该资源文件的value值为"TextTextTextText"
          Text($r('app.string.Set_Custom_Selection_Menu_Example_String'))
            .fontSize(14)
            .selection(this.selectStart, this.selectEnd)
            .copyOption(CopyOptions.InApp)
            .bindSelectionMenu(TextSpanType.TEXT, this.CustomMenu, TextResponseType.DEFAULT, {
              onDisappear: () => {
                this.selectStart = -1;
                this.selectEnd = -1;
              },
            })
            .textAlign(TextAlign.Center)
            .borderWidth(1)
            .borderColor(Color.Red)
          Button('Set selection')
            .onClick(() => {
              this.selectStart = 0;
              this.selectEnd = 10;
            })
            .fontSize(14)
            .margin({ top: 20 })
        }
        .width('100%')
        .padding({ top: 300 })
      }
      .height('100%')
    }
  }

  @Builder
  CustomMenu() {
    Column() {
      Menu() {
        // 请将$r('app.string.Menu_Item_String')替换为实际资源文件，在本示例中该资源文件的value值为"Item Content"
        MenuItem({ content: $r('app.string.Menu_Item_String') })
        MenuItem({ content: $r('app.string.Menu_Item_String') })
        MenuItem({ content: $r('app.string.Menu_Item_String') })
      }
      .font({ size: 14 })
      .radius($r('sys.float.ohos_id_corner_radius_card'))
      .clip(true)
      .backgroundColor('#F0F0F0')
    }
  }
}
// [End How_To_Set_Custom_Selection_Menu]
