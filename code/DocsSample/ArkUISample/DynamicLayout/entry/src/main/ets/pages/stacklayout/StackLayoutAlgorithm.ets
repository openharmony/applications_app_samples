/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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

// [Start StackLayoutAlgorithm]
import {
  DynamicLayout, DynamicLayoutAttribute, StackLayoutAlgorithm
} from '@kit.ArkUI';

@Entry
@ComponentV2
struct StackLayoutExample {
  @Local algorithm: StackLayoutAlgorithm = new StackLayoutAlgorithm({
    alignContent: LocalizedAlignment.CENTER
  });

  build() {
    Column() {
      DynamicLayout(this.algorithm) {
        Text('第一层')
          .fontSize(14)
          .width(150)
          .height(150)
          .backgroundColor(0xD2B48C)
          .layoutGravity(LocalizedAlignment.TOP_START)

        Text('第二层')
          .fontSize(14)
          .width(150)
          .height(150)
          .backgroundColor(0xF5DEB3)
          .layoutGravity(LocalizedAlignment.CENTER)

        Text('第三层')
          .fontSize(14)
          .width(100)
          .height(100)
          .backgroundColor(0x8B4513)
      }
      .width(250)
      .height(250)
      .backgroundColor(0xEFEFEF)

      Row({ space: 10 }) {
        Button('顶部居中')
          .fontSize(14)
          .onClick(() => {
            this.algorithm.alignContent = LocalizedAlignment.TOP;
          })
        Button('居中对齐')
          .fontSize(14)
          .onClick(() => {
            this.algorithm.alignContent = LocalizedAlignment.CENTER;
          })
        Button('底部居中')
          .fontSize(14)
          .onClick(() => {
            this.algorithm.alignContent = LocalizedAlignment.BOTTOM;
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
  }
}
// [End StackLayoutAlgorithm]