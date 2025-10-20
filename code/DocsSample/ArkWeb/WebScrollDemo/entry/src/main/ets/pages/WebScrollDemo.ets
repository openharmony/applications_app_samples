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
import router from '@ohos.router';

@Entry
@Component
struct WebScrollDemo {
  // Web组件控制器
  webController: webview.WebviewController = new webview.WebviewController();
  @State currentScrollY: number = 0;
  @State deltaX:number = 0;
  @State deltaY:number = 200;
  @State x:number = 0;
  @State y:number = 400;
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();
          })

        Text('Web滚动控制演示')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })

        Blank()
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 添加滚动位置显示（便于测试用例获取）
      Text(`当前滚动位置: Y: ${this.currentScrollY}`)
        .id('scrollPositionText')  // 添加id便于查找
        .fontSize(14)
        .fontColor('#666')
        .width('90%')
        .textAlign(TextAlign.Center)
        .margin(2)
        .backgroundColor('#F5F5F5')
        .padding(2)

      // ArkTS侧控制按钮
      Text('ArkTS侧控制')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 5 })

      Button('1. scrollTo(0, 0) - 返回顶部')
        .width('90%')
        .height(40)
        .margin(5)
        .onClick(() => {
          // 代码片段1: 调用ArkTS侧接口控制Web页面滚动
          // [Start scrollTo_ArkTS_one]
          this.webController.scrollTo(0, 0);
          // [End scrollTo_ArkTS_one]
        })

      // JavaScript侧控制按钮
      Text('JavaScript侧控制')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 5 })
      // Web组件
      Web({
        src: $rawfile('scroll_demo.html'),
        controller: this.webController
      })
        .onScroll((event) => {
          this.currentScrollY = event.yOffset; // 更新滚动位置
        })
        .backgroundColor(Color.White)
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}