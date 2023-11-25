/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { performanceTypeArray } from '../model/MockData';
import { PerformanceMsg } from '../model/DataType';

@Entry
@Component
struct Index {
  @State performanceTypeArray: Array<PerformanceMsg> = performanceTypeArray;

  build() {
    Column() {
      ForEach(this.performanceTypeArray, (item: PerformanceMsg, index: number) => {
        Button() {
          Text(item.name)
            .id('RenderGroup')
            .fontSize($r('app.integer.performance_message_font'))
            .fontColor(Color.White)
        }
        .width($r('app.string.layout_80_percent'))
        .margin($r('app.integer.performance_message_margin'))

        .padding($r('app.integer.performance_message_padding'))
        .backgroundColor($r('app.color.performance_message_item_backgroundColor'))
        .onClick(() => {
          router.pushUrl({ url: item.uri });
        })
      }, (item: PerformanceMsg) => JSON.stringify(item))
    }.width($r('app.string.layout_100_percent'))
    .height($r('app.string.layout_100_percent'))
    .justifyContent(FlexAlign.Center)
  }
}