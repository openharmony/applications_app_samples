/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { animate, changeShape } from "libnativerender.so"

@Entry
@Component
struct Index {
  @State xcOpacity: number = 1
  @State xcRotate: number = 0
  @State currentIndex: number = 0
  private intervalID: number = 0

  onPageShow() {
    this.intervalID = setInterval(() => {
      animate();
    }, 40)
  }

  onPageHide() {
    clearInterval(this.intervalID);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Row() {
        Column() {
          Text("XComponent3D")
            .fontSize(30)
            .fontColor(0x182431)
            .fontWeight('bold')
            .textAlign(TextAlign.Start)
        }
        .margin({
          left: '6.7%'
        })
      }
      .width('100%')
      .height('7.2%')

      Flex() {
        this.TabBuilder("DrawCube", 0)
        this.TabBuilder("DrawTransform", 1)
      }
      .width('100%')
      .height('7.2%')

      XComponent({ id: 'xComponentId', type: 'surface', libraryname: 'nativerender' })
        .width("90%")
        .height("100%")
        .borderRadius('24vp')
        .margin({
          top: 4
        })
        .opacity(this.xcOpacity)
        .rotate({ angle: this.xcRotate })
        .backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontWeight(this.currentIndex === targetIndex ? "bold" : "normal")
        .fontSize(16)
        .id(title)
        .fontColor(this.currentIndex === targetIndex ? 0x007DFF : 0x182431)
        .padding({
          left: targetIndex === 0 ? "22.6%" : "2.2%",
          right: targetIndex === 0 ? "2.2%" : "48.2%",
        })
        .opacity(this.currentIndex === targetIndex ? 1 : 0.6)
        .onClick(() => {
          console.log("Button Click")
          this.currentIndex = targetIndex
          changeShape(targetIndex)
        })

      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === targetIndex ? 1 : 0)
        .padding({
          left: targetIndex === 0 ? "28%" : "6%",
          right: targetIndex === 0 ? "7%" : "51%",
        })
        .margin({
          top: 8
        })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      console.log("Button Click")
      this.currentIndex = targetIndex
      changeShape(targetIndex)
    })
  }
}