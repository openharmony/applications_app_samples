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

// [Start ChangeAlgorithmProperties]
import {
  DynamicLayout, DynamicLayoutAttribute, RowLayoutAlgorithm, LengthMetrics
} from '@kit.ArkUI';

@Entry
@ComponentV2
struct PropertyChangeExample {
  @Local algorithm: RowLayoutAlgorithm = new RowLayoutAlgorithm({
    space: LengthMetrics.vp(10),
    justifyContent: FlexAlign.Start
  });

  build() {
    Column() {
      DynamicLayout(this.algorithm) {
        Text('Item 1')
          .width(60)
          .height(40)
          .fontSize(14)
          .backgroundColor(0xF5DEB3)
        Text('Item 2')
          .width(60)
          .height(40)
          .fontSize(14)
          .backgroundColor(0xD2B48C)
        Text('Item 3')
          .width(60)
          .height(40)
          .fontSize(14)
          .backgroundColor(0xF5DEB3)
      }
      .width('100%')
      .height(80)
      .backgroundColor(0xEFEFEF)

      Row({ space: 10 }) {
        Button('增加间距')
          .fontSize(14)
          .onClick(() => {
            // 修改space属性触发重新布局
            const currentSpace = this.algorithm.space?.value;
            this.algorithm.space = LengthMetrics.vp(currentSpace as number + 5);
          })
        Button('居中对齐')
          .fontSize(14)
          .onClick(() => {
            // 修改justifyContent属性触发重新布局
            this.algorithm.justifyContent = FlexAlign.Center;
          })
        Button('两端对齐')
          .fontSize(14)
          .onClick(() => {
            this.algorithm.justifyContent = FlexAlign.SpaceBetween;
          })
      }
      .margin({ top: 20 })
    }
    .padding(20)
  }
}
// [End ChangeAlgorithmProperties]