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

// [Start ReserveChildState]
import {
  DynamicLayout, DynamicLayoutAttribute, ColumnLayoutAlgorithm, LayoutAlgorithm, curves, LengthMetrics,
  GridLayoutAlgorithm
} from '@kit.ArkUI';

@Entry
@ComponentV2
struct StatePreservationExample {
  @Local algorithm: LayoutAlgorithm = new ColumnLayoutAlgorithm({
    space: LengthMetrics.vp(12)
  });

  build() {
    Column() {
      Text('布局切换状态保持示例')
        .fontSize(18)
        .margin({ bottom: 20 })

      // 使用animateTo为布局切换添加动画效果
      DynamicLayout(this.algorithm) {
        // 子组件1：带输入框的卡片
        Column() {
          Text('输入框')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(0x333333)
            .margin({ bottom: 8 })
          TextInput({ placeholder: '请输入' })
            .width('100%')
            .height(36)
            .fontSize(12)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(0x80F0F0F0)
        .borderRadius(8)

        // 子组件2：带开关的卡片
        Column() {
          Text('开关')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(0x333333)
            .margin({ bottom: 8 })
          Toggle({ type: ToggleType.Switch, isOn: true })
            .selectedColor(0xD4D4D4)
            .height(26)
            .width(52)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(0x80F0F0F0)
        .borderRadius(8)

        // 子组件3：带进度条的卡片
        Column() {
          Text('进度条')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(0x333333)
            .margin({ bottom: 8 })
          Slider({ value: 60, min: 0, max: 100 })
            .width('100%')
            .trackColor(0xD4D4D4)
            .selectedColor(0xD4D4D4)
            .height(36)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(0x80F0F0F0)
        .borderRadius(8)

        // 子组件4：带复选框的卡片
        Column() {
          Text('复选框')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(0x333333)
            .margin({ bottom: 8 })
          Row() {
            Checkbox({ name: 'check1' })
              .select(false)
              .selectedColor(0xD4D4D4)
            Text('记住密码')
              .fontSize(12)
              .fontColor(0x333333)
              .margin({ left: 8 })
          }
          .height(36)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(0x80F0F0F0)
        .borderRadius(8)
      }
      .width('100%')
      .borderRadius(12)
      .padding(12)

      Row({ space: 10 }) {
        Button('列表布局')
          .onClick(() => {
            this.getUIContext()?.animateTo({ duration: 300, curve: curves.springMotion() }, () => {
              this.algorithm = new ColumnLayoutAlgorithm({
                space: LengthMetrics.vp(12)
              });
            });
          })
        Button('网格布局')
          .onClick(() => {
            this.getUIContext()?.animateTo({ duration: 300, curve: curves.springMotion() }, () => {
              this.algorithm = new GridLayoutAlgorithm({
                columnsTemplate: '1fr 1fr',
                columnsGap: LengthMetrics.vp(10),
                rowsGap: LengthMetrics.vp(10)
              });
            });
          })
      }
      .margin({ top: 20 })

      Text('切换布局后，子组件状态保持不变')
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 12 })
    }
    .padding(20)
    .width('100%')
  }
}
// [End ReserveChildState]