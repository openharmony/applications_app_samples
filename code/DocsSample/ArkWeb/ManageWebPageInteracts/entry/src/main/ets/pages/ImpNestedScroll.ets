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

// [Start nested_scrolling]
import { webview } from '@kit.ArkWeb';

@Entry
@ComponentV2
struct NestedScroll {
  private scrollerForScroll: Scroller = new Scroller();
  private listScroller: Scroller = new Scroller();
  controller: webview.WebviewController = new webview.WebviewController();
  @Local arr: Array<number> = [];

  aboutToAppear(): void {
    for (let i = 0; i < 10; i++) {
    this.arr.push(i);
  }
}

build() {
  Scroll(this.scrollerForScroll) {
    Column() {
      Web({ src: $rawfile('scroll.html'), controller: this.controller })
        .nestedScroll({
          scrollUp: NestedScrollMode.PARENT_FIRST,//向上滚动父组件优先
          scrollDown: NestedScrollMode.SELF_FIRST,//向下滚动子组件优先
        }).height('100%')
      Repeat<number>(this.arr)
        .each((item: RepeatItem<number>) => {
          Text('Scroll Area')
            .width('100%')
            .height('40%')
            .backgroundColor(0X330000FF)
            .fontSize(16)
            .textAlign(TextAlign.Center)
        })
    }
  }
}
}
// [End nested_scrolling]