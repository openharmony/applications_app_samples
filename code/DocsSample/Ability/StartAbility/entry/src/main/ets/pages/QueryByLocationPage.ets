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
struct QueryByLocationPage {
  @LocalStorageLink('originLocation') originLocation: string = '';
  @LocalStorageLink('destinationLocation') destinationLocation: string = '';
  @LocalStorageLink('departureDate') departureDate: string = '';

  build() {
    Column() {
      Text('Search page by departure')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      Text(`departure location: ${this.originLocation}`)
        .fontSize(18)
        .margin(10)

      Text(`destination: ${this.destinationLocation}`)
        .fontSize(18)
        .margin(10)

      Text(`departure date: ${this.departureDate}`)
        .fontSize(18)
        .margin(10)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}