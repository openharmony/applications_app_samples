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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

const DOMAIN = 0x0000;

@Component
export struct ResultDisplay {
  @Prop result: string

  build() {
    Column() {
      Text(this.result)
        .fontSize(14)
        .width('100%')
        .wordBreak(WordBreak.NORMAL)
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .padding(12)
    }
    .width('100%')
    .backgroundColor('#F5F5F5')
    .borderRadius(8)
    .margin({ top: 20, bottom: 20 })
    .padding(0)
  }
}

@Entry
@Component
struct Index {
  @State result: string = '';

  @Builder
  ApiMethodItem(title: string, onClick: () => void) {
    Text(title)
      .height('auto')
      .width('100%')
      .fontSize(13)
      .fontWeight(FontWeight.Bold)
      .fontColor('#0A59F7')
      .textAlign(TextAlign.Start)
      .margin({ top: 8, bottom: 8 })
      .lineHeight(20)
      .wordBreak(WordBreak.NORMAL)
      .maxLines(2)
      .backgroundColor('#F7F9FC')
      .borderRadius(4)
      .padding(8)
      .onClick(onClick)
  }

  aboutToAppear(): void {
    if (testNapi) {
      testNapi.onChange((event: testNapi.ValueChangeEvent) => {
        this.result = event.value;
      });
    } else {
      hilog.error(DOMAIN, 'NDKInputEventMonitor', 'testNapi is undefined');
      this.result = 'Native plugin failed to load';
    }
  }

  build() {
    Scroll() {
      Column() {
        ResultDisplay({ result: this.result })

        this.ApiMethodItem(
          "Add key event monitor",
          () => {
            try {
              this.result = testNapi.addKeyEventMonitor()
            } catch (e) {
              this.result = `Add key event monitor, error：${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove key event monitor",
          () => {
            try {
              this.result = testNapi.removeKeyEventMonitor()
            } catch (e) {
              this.result = `Remove key event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Add mouse event monitor",
          () => {
            try {
              this.result = testNapi.addMouseEventMonitor()
            } catch (e) {
              this.result = `Add mouse event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove mouse event monitor",
          () => {
            try {
              this.result = testNapi.removeMouseEventMonitor()
            } catch (e) {
              this.result = `Remove mouse event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Add touch event monitor",
          () => {
            try {
              this.result = testNapi.addTouchEventMonitor()
            } catch (e) {
              this.result = `Add touch event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove touch event monitor",
          () => {
            try {
              this.result = testNapi.removeTouchEventMonitor()
            } catch (e) {
              this.result = `Remove touch event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Add axis event monitor",
          () => {
            try {
              this.result = testNapi.addAxisEventMonitorForAll()
            } catch (e) {
              this.result = `Add axis event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove axis event monitor",
          () => {
            try {
              this.result = testNapi.removeAxisEventMonitorForAll()
            } catch (e) {
              this.result = `Remove axis event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Add pinch axis event monitor",
          () => {
            try {
              this.result = testNapi.addPinchAxisEventMonitor()
            } catch (e) {
              this.result = `Add axis event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove pinch axis event monitor",
          () => {
            try {
              this.result = testNapi.removePinchAxisEventMonitor()
            } catch (e) {
              this.result = `Remove axis event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Add scroll axis event monitor",
          () => {
            try {
              this.result = testNapi.addScrollAxisEventMonitor()
            } catch (e) {
              this.result = `Add scroll axis event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove scroll axis event monitor",
          () => {
            try {
              this.result = testNapi.removeScrollAxisEventMonitor()
            } catch (e) {
              this.result = `Remove scroll axis event monitor, error: ${JSON.stringify(e)}`
            }
          }
        )

      }
      .height('100%')
      .width('80%')
      .alignItems(HorizontalAlign.Center)
      .margin({ left: '10%', right: '10%' })
      .margin({ bottom: 200 })
    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor('#888888')
    .scrollBarWidth(8)
    .edgeEffect(EdgeEffect.Spring)
  }
}
