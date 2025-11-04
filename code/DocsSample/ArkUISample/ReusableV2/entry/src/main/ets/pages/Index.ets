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
//[Start Interface_Description]
import { router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {

  build() {
    Column() {
      Button('page1').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page1'})
      })
      Button('page2').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page2'})
      })
      Button('page3').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page3'})
      })
      Button('page4').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page4'})
      })
      Button('page5').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page5'})
      })
      Button('page6').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page6'})
      })
      Button('page7').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page7'})
      })
      Button('page8').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page8'})
      })
      Button('page9').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page9'})
      })
      Button('page10').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page10'})
      })
      Button('page11').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page11'})
      })
      Button('page12').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page11'})
      })
      Button('page13').onClick((event: ClickEvent) => {
        router.pushUrl({url:'view/Page13'})
      })
    }
  }
}
//[End Interface_Description]