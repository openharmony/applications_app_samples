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

import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct NestedScroll {
  private scrollerForScroll: Scroller = new Scroller();
  controller: webview.WebviewController = new webview.WebviewController();
  controller2: webview.WebviewController = new webview.WebviewController();
  // NestedScrollMode设置成SELF_ONLY时，Web网页滚动到页面边缘后，不与父组件联动，父组件仍无法滚动。
  @State nestedScrollMode0: NestedScrollMode = NestedScrollMode.SELF_ONLY;
  // NestedScrollMode设置成SELF_FIRST时，Web网页滚动到页面边缘后，父组件继续滚动。
  @State nestedScrollMode1: NestedScrollMode = NestedScrollMode.SELF_FIRST;
  // NestedScrollMode设置为PARENT_FIRST时，父组件先滚动，滚动至边缘后通知Web继续滚动。
  @State nestedScrollMode2: NestedScrollMode = NestedScrollMode.PARENT_FIRST;
  // NestedScrollMode设置为PARALLEL时，父组件与Web同时滚动。
  @State nestedScrollMode3: NestedScrollMode = NestedScrollMode.PARALLEL;
  @State nestedScrollModeF: NestedScrollMode = NestedScrollMode.SELF_FIRST;
  @State nestedScrollModeB: NestedScrollMode = NestedScrollMode.SELF_FIRST;
  // scroll竖向的滚动
  @State scrollDirection: ScrollDirection = ScrollDirection.Vertical;

  build() {
    Flex() {
      Scroll(this.scrollerForScroll) {
        Column({ space: 5 }) {
          Row({}) {
            Text('切换前滚动模式').fontSize(5)
            Button('SELF_ONLY').onClick((event: ClickEvent) => {
              this.nestedScrollModeF = this.nestedScrollMode0
            }).fontSize(5)
            Button('SELF_FIRST').onClick((event: ClickEvent) => {
              this.nestedScrollModeF = this.nestedScrollMode1
            }).fontSize(5)
            Button('PARENT_FIRST').onClick((event: ClickEvent) => {
              this.nestedScrollModeF = this.nestedScrollMode2
            }).fontSize(5)
            Button('PARALLEL').onClick((event: ClickEvent) => {
              this.nestedScrollModeF = this.nestedScrollMode3
            }).fontSize(5)
          }

          Row({}) {
            Text('切换后滚动模式').fontSize(5)
            Button('SELF_ONLY').onClick((event: ClickEvent) => {
              this.nestedScrollModeB = this.nestedScrollMode0
            }).fontSize(5)
            Button('SELF_FIRST').onClick((event: ClickEvent) => {
              this.nestedScrollModeB = this.nestedScrollMode1
            }).fontSize(5)
            Button('PARENT_FIRST').onClick((event: ClickEvent) => {
              this.nestedScrollModeB = this.nestedScrollMode2
            }).fontSize(5)
            Button('PARALLEL').onClick((event: ClickEvent) => {
              this.nestedScrollModeB = this.nestedScrollMode3
            }).fontSize(5)
          }

          Text('当前内嵌前滚动模式 scrollForward ---' + `${this.nestedScrollModeF}`).fontSize(10)
          Text('当前内嵌后滚动模式  scrollBackward ---' + `${this.nestedScrollModeB}`).fontSize(10)

          Text('Scroll Area')
            .width('100%')
            .height('10%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)
          Text('Scroll Area')
            .width('100%')
            .height('10%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)
          Text('Scroll Area')
            .width('100%')
            .height('10%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)

          Web({ src: 'www.example.com', controller: this.controller })
            .nestedScroll({
              scrollForward: this.nestedScrollModeF,
              scrollBackward: this.nestedScrollModeB,
            })
            .height('40%')
            .width('100%')

          Text('Scroll Area')
            .width('100%')
            .height('20%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)

          Text('Scroll Area')
            .width('100%')
            .height('20%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)

          Web({ src: 'www.example.com', controller: this.controller2 })
            .nestedScroll({
              scrollForward: this.nestedScrollModeF,
              scrollBackward: this.nestedScrollModeB,
            })
            .height('40%')
            .width('90%')

          Text('Scroll Area')
            .width('100%')
            .height('20%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)

        }.width('95%').border({ width: 5 })
      }
      .width('100%').height('120%').border({ width: 5 }).scrollable(this.scrollDirection)
    }.width('100%').height('100%').backgroundColor(0xDCDCDC).padding(20)
  }
}
