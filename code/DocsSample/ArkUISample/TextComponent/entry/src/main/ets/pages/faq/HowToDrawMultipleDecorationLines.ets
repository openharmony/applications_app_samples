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

// [Start Draw_Multiple_Decoration_Lines]
@Entry
@Component
export struct HowToDrawMultipleDecorationLinesExample {
  controller: TextController = new TextController()
  mutableStyledString2: MutableStyledString = new MutableStyledString('hello world', [
    {
      start: 0,
      length: 5,
      styledKey: StyledStringKey.DECORATION,
      styledValue: new DecorationStyle({ type: TextDecorationType.LineThrough, color: Color.Red }, {
        enableMultiType: true
      })
    },
    {
      start: 0,
      length: 5,
      styledKey: StyledStringKey.DECORATION,
      styledValue: new DecorationStyle({ type: TextDecorationType.Underline, color: Color.Blue }, {
        enableMultiType: true
      })
    }
  ]);

  aboutToAppear(): void {
    this.controller.setStyledString(this.mutableStyledString2)
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(undefined, { controller: this.controller })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.How_To_Draw_Multiple_Decoration_Lines'))
  }
}

// [End Draw_Multiple_Decoration_Lines]