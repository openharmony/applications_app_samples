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
import { ClipShapeExampleA } from '../Comm/ClipShapeExampleA';
import { ClipShapeExampleB } from '../Comm/ClipShapeExampleB';
import { ClipShapeExampleC } from '../Comm/ClipShapeExampleC';
import { ClipShapeExampleD } from '../Comm/ClipShapeExampleD';
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
        ClipShapeExampleA()
        Text($r('app.string.EntryAbility_title2'))
        ClipShapeExampleB()
        Text($r('app.string.EntryAbility_title3'))
        ClipShapeExampleC()
        Text($r('app.string.EntryAbility_title4'))
        ClipShapeExampleD()
      }

    }.width('100%')
    .scrollBar(BarState.Off)

  }
}
// [End ClipShapeExample_index]