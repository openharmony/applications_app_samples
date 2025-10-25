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
import { MyComponent } from '../common/MyComponent';
import { router } from '@kit.ArkUI';
@Entry
@ComponentV2
struct Index {

  build() {
   Column(){
     MyComponent()
     Button('page1').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page1'})
     })
     Button('page2').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page2'})
     })
     Button('page3').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page3'})
     })
     Button('page4').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page4'})
     })
     Button('page5').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page5'})
     })
     Button('page6').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page6'})
     })
     Button('page7').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page7'})
     })
     Button('page8').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page8'})
     })
     Button('page9').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page9'})
     })
     Button('page10').onClick((event: ClickEvent) => {
       router.pushUrl({url:'View/Page10'})
     })
   }
  }
}