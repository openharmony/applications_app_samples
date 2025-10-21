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

@Entry
@Component
struct LayoutWeightExample {
  build() {
    Column() {
      Text('1:2:3').width('100%')
      Row() {
        Column() {
          Text('layoutWeight(1)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(1).backgroundColor(0xF5DEB3).height('100%')

        Column() {
          Text('layoutWeight(2)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(2).backgroundColor(0xD2B48C).height('100%')

        Column() {
          Text('layoutWeight(3)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(3).backgroundColor(0xF5DEB3).height('100%')

      }.backgroundColor(0xffd306).height('30%')

      Text('2:5:3').width('100%')
      Row() {
        Column() {
          Text('layoutWeight(2)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(2).backgroundColor(0xF5DEB3).height('100%')

        Column() {
          Text('layoutWeight(5)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(5).backgroundColor(0xD2B48C).height('100%')

        Column() {
          Text('layoutWeight(3)')
            .textAlign(TextAlign.Center)
        }.layoutWeight(3).backgroundColor(0xF5DEB3).height('100%')
      }.backgroundColor(0xffd306).height('30%')
    }
  }
}