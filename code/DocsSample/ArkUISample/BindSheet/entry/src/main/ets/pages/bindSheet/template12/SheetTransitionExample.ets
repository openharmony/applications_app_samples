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

// [Start SheetTransitionExample]

@Entry
@Component
struct SheetTransitionExample {
  @State isShow: boolean = false;
  @State enableHoverMode: boolean = true;
  @State hoverModeArea: HoverModeAreaType = HoverModeAreaType.TOP_SCREEN;

  @Builder
  myBuilder() {
    Column() {
      Button($r('app.string.bindSheetCmd_label10'))
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.enableHoverMode = !this.enableHoverMode;
        })

      Button($r('app.string.bindSheetCmd_label11'))
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.hoverModeArea = this.hoverModeArea === HoverModeAreaType.TOP_SCREEN ?
            HoverModeAreaType.BOTTOM_SCREEN : HoverModeAreaType.TOP_SCREEN;
        })

      Button('close modal')
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.isShow = false;
        })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      Button($r('app.string.bindSheetCmd_label9'))
        .onClick(() => {
          this.isShow = true;
        })
        .fontSize(20)
        .margin(10)
        .bindSheet($$this.isShow, this.myBuilder(), {
          height: 300,
          backgroundColor: Color.Green,
          preferType: SheetType.CENTER,
          enableHoverMode: this.enableHoverMode,
          hoverModeArea: this.hoverModeArea
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}

// [End SheetTransitionExample]