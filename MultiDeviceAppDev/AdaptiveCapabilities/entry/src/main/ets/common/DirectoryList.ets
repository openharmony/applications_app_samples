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

import router from '@ohos.router'

type DirectoryItem = {
  title: Resource,
  uri: string
}

@Component
struct DirectoryList {
  private directory: DirectoryItem[]
  private title: Resource

  build() {
    Column() {
      Text(this.title)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .height(100)

      List({ space: 5 }) {
        ForEach(this.directory, (item) => {
          ListItem() {
            Text(item.title)
              .fontSize(20)
              .padding({ left: 20 })
          }
          .backgroundColor('#66CCFF')
          .width('100%')
          .height(80)
          .borderRadius(10)
          .onClick(() => {
            router.push({
              url: item.uri
            })
          })
        })
      }
      .padding({ top: 10, left: 10, right: 10, bottom: 100 })
    }.width('100%').height('100%')
  }
}

export { DirectoryItem, DirectoryList }