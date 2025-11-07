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

@Entry
@Component
struct StackLayoutNozIndex {
  build() {
    //[Start StackLayoutNozIndex_start]
    Stack({ alignContent: Alignment.BottomStart }) {
      Column() {
        //'app.string.stack_num1'资源文件中的value值为'Stack子元素1'
        Text($r('app.string.stack_num1')).textAlign(TextAlign.End).fontSize(20)
      }.width(100).height(100).backgroundColor(0xffd306)

      Column() {
        //'app.string.stack_num2'资源文件中的value值为'Stack子元素2'
        Text($r('app.string.stack_num2')).fontSize(20)
      }.width(150).height(150).backgroundColor(Color.Pink)

      Column() {
        //'app.string.stack_num3'资源文件中的value值为'Stack子元素3'
        Text($r('app.string.stack_num3')).fontSize(20)
      }.width(200).height(200).backgroundColor(Color.Grey)
    }.width(350).height(350).backgroundColor(0xe0e0e0)
    // [End StackLayoutNozIndex_start]
  }
}
