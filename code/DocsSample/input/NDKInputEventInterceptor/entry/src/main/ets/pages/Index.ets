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
        .wordBreak(WordBreak.BREAK_ALL)
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
      .wordBreak(WordBreak.BREAK_ALL)
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
      hilog.error(DOMAIN, 'NDKInputEventIntercrptor', 'testNapi is undefined');
      this.result = 'Native plugin failed to load';
    }
  }

  build() {
    Scroll() {
      Column() {
        ResultDisplay({ result: this.result })

        Column() {
          TextInput({ placeholder: '输入测试' })
            .type(InputType.Normal)
            .width('80%')
            .height(50)
            .margin(10)
        }

        this.ApiMethodItem(
          "Add key event interceptor",
          () => {
            try {
              this.result = testNapi.addKeyEventInterceptor()
            } catch (e) {
              this.result = `Add key event interceptor, error：${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove key event interceptor",
          () => {
            try {
              this.result = testNapi.removeKeyEventInterceptor()
            } catch (e) {
              this.result = `Remove key event interceptor, error：${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Add input event interceptor. Input event include: mouse event, touch event, and axis event",
          () => {
            try {
              this.result = `${testNapi.addEventInterceptor()}，30秒后自动取消输入事件拦截`
              setTimeout(() => {
                try {
                  this.result = testNapi.removeEventInterceptor()
                } catch (e) {
                  this.result = `自动移除输入事件拦截异常：${JSON.stringify(e)}`;
                }
              }, 30000);
            } catch (e) {
              this.result = `添加输入事件拦截异常：${JSON.stringify(e)}`
            }
          }
        )

        this.ApiMethodItem(
          "Remove input event interceptor. Input event include: mouse event, touch event, and axis event",
          () => {
            try {
              this.result = testNapi.removeEventInterceptor()
            } catch (e) {
              this.result = `移除输入事件拦截异常：${JSON.stringify(e)}`
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
