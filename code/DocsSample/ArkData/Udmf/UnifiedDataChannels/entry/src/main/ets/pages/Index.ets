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

import { insertUnifiedData, updateUnifiedData, deleteUnifiedData, queryUnifiedData } from './UdmfInterface';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button('insertData')
        .width('40%')
        .height('5%')
        .margin({ bottom: 20 }) // 底部间距
        .onClick(() => {
          insertUnifiedData();
        })

      Button('updateData')
        .width('40%')
        .height('5%')
        .margin({ bottom: 20 })
        .onClick(() => {
          updateUnifiedData();
        })

      Button('deleteData')
        .width('40%')
        .height('5%')
        .margin({ bottom: 20 })
        .onClick(() => { /* 删除逻辑 */
        })
        .onClick(() => {
          deleteUnifiedData();
        })

      Button('queryData')
        .width('40%')
        .height('5%')
        .onClick(() => {
          queryUnifiedData();
        })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }
}