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
// [Start ClipShapeExample_index]
@Entry
@Component
struct Index {
  @State selectIndex: number = 0;
  @Builder tabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.selectIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
  }

  build() {
    Scroll() {
      Column(){
        // $r('app.string.EntryAbility_title1')需要替换为开发者所需的字符串（图像、数字等）资源文件
        Text($r('app.string.EntryAbility_title1'))
          .id('text1_title1')
          .onClick(()=>{
            this.getUIContext().getRouter().pushUrl({url:'View/ClipShapeExample1'})
          })

        Text($r('app.string.EntryAbility_title2'))
          .id('text1_title2')
          .onClick(()=>{
            this.getUIContext().getRouter().pushUrl({url:'View/ClipShapeExample2'})
          })
        Text($r('app.string.EntryAbility_title3'))
          .id('text1_title3')
          .onClick(()=>{
            this.getUIContext().getRouter().pushUrl({url:'View/ClipShapeExample3'})
          })
        Text($r('app.string.EntryAbility_title4'))
          .id('text1_title4')
          .onClick(()=>{
            this.getUIContext().getRouter().pushUrl({url:'View/ClipShapeExample4'})
          })
      }

    }.width('100%')
    .scrollBar(BarState.Off)

  }
}
// [End ClipShapeExample_index]