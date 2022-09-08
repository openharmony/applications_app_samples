/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { listData } from '../../../model/Data'

@Entry
@Component
export default struct OperationEntries {
  build() {
    Scroll() {
      Row() {
        ForEach(listData, (item) => {
          Column() {
            Image(item.icon)
              .width(48)
              .aspectRatio(1)
            Text(item.name)
              .margin({ top: 8 })
              .fontSize(16)
          }
          .justifyContent(FlexAlign.Center)
          .height(104)
          .padding({ left: 12, right: 12 })
        })
      }
      .constraintSize({ minWidth: '100%' })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
  }
}