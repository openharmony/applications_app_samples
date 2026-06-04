/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start gesture_intercepting]
@Entry
@Component
struct InterceptGestureCollection {
  @State backgroundColorButton1: string = '#D5D5D5';
  @State backgroundColorButton2: string = '#D5D5D5';
  @State backgroundColorRow: string = '#FFFFFF';
  @State backgroundColorColumn: string = '#FFFFFF';

  build() {
    Column() {
      Column() {
        Row() {
          Button('button1')
            .width('30%')
            .height(40)
            .id('button1')
            .onTouch((e?: TouchEvent) => {
              this.backgroundColorButton1 = '#E5E5E5';
            })
            .backgroundColor(this.backgroundColorButton1)
          Button('button2')
            .width('30%')
            .height(40)
            .id('button2')
            .onTouch((e?: TouchEvent) => {
              this.backgroundColorButton2 = '#E5E5E5';
            })
            .onClick((e?: ClickEvent) => {
              console.info('button2 is clicked')
            })
            .backgroundColor(this.backgroundColorButton2)
        }
        .id('row')
        .justifyContent(FlexAlign.Center)
        .width('90%')
        .height(200)
        .margin(25)
        .onTouch((e?: TouchEvent) => {
          this.backgroundColorRow = '#666666';
        })
        .backgroundColor(this.backgroundColorRow)
      }
      .id('innerColumn')
      .margin(25)
      .padding(20)
      .width('90%')
      .height(250)
      .borderWidth(2)
      // [Start gesture_collection]
      .onGestureCollectIntercept((recognizers: Array<GestureRecognizer>,
        touchRecognizers?: Array<TouchRecognizer> | undefined) => {
        if (!touchRecognizers) {
          return GestureCollectIntervention.CONTINUE;
        }
        // 遍历所有触摸识别器，获取目标组件信息
        for (let i = 0; i < touchRecognizers.length; i++) {
          let touchRecognizer = touchRecognizers[i];
          let targetInfo = touchRecognizer.getEventTargetInfo();
          let uniqueId = targetInfo.getUniqueId();
          // 使用 isHostBelongsTo 判断识别器是否属于 innerColumn 的后代
          if (touchRecognizer.isHostBelongsTo(uniqueId)) {
            console.info('Touch belongs to innerColumn subtree');
          }
          if (targetInfo.getId() == 'button2') {
            // 丢弃低优先级节点的收集，阻止事件透传到 outerColumn
            return GestureCollectIntervention.DISCARD_LOWER;
          }
        }
        return GestureCollectIntervention.CONTINUE;
      })
      // [End gesture_collection]
    }
    .id('outerColumn')
    .padding(15)
    .onTouch((e?: TouchEvent) => {
      this.backgroundColorColumn = '#E5E5E5';
    })
    .backgroundColor(this.backgroundColorColumn)
  }
}
// [End gesture_intercepting]