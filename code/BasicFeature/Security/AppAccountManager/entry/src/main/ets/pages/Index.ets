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

import { BundleInfo } from '../common/BundleInfo'
import { NavigationBar } from '../common/NavigationBar'
import { LoginInfo } from '../common/LoginInfo'

@Entry
@Component
struct Index {
  @State isWideLayout: boolean = false
  @StorageLink('selectedBundleName') bundleName: string = 'Music'
  private readonly splitThreshold: number = 840

  build() {
    Column() {
      NavigationBar({ title: $r('app.string.entry_MainAbility'), flag: false })

      if (this.isWideLayout) {
        Row() {
          Column() {
            BundleInfo({
              isWideLayout: false,
              isSidebar: true,
              selectedBundleName: this.bundleName
            })
          }
          .width('32%')
          .height('100%')
          .padding({ left: 12, right: 8, top: 10, bottom: 10 })

          Column() {
            LoginInfo({ bundleName: this.bundleName, isWideLayout: true })
          }
          .width('68%')
          .height('100%')
          .padding({ left: 8, right: 12, top: 10, bottom: 10 })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Column() {
          BundleInfo({ isWideLayout: false, isSidebar: false, selectedBundleName: this.bundleName })
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldArea, newArea) => {
      this.isWideLayout = Number(newArea.width) >= this.splitThreshold
    })
  }
}
