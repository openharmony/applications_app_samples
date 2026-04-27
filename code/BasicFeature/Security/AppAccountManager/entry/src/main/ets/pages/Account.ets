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
import { AccountInfo } from '../common/AccountInfo'
import { NavigationBar } from '../common/NavigationBar'
import { BundleInfo } from '../common/BundleInfo'

interface AccountPageParams {
  email?: string
  username?: string
  signature?: string
  bundleName?: string
}

@Entry
@Component
struct Account {
  @State email: string = ''
  @State username: string = ''
  @State signature: string = ''
  @StorageLink('selectedBundleName') @Watch('onBundleNameChange') bundleName: string = 'Music'
  @State isWideLayout: boolean = false
  private readonly splitThreshold: number = 840

  aboutToAppear() {
    const params: AccountPageParams = router.getParams() as AccountPageParams
    this.email = params.email ?? ''
    this.username = params.username ?? ''
    this.signature = params.signature ?? ''
    let bundleNameFromParam: string = params.bundleName ?? ''
    if (bundleNameFromParam) {
      this.bundleName = bundleNameFromParam
      AppStorage.SetOrCreate<string>('selectedBundleName', bundleNameFromParam)
    }
  }

  onBundleNameChange() {
    this.email = ''
    this.username = ''
    this.signature = ''
  }

  build() {
    Column() {
      NavigationBar({ title: $r('app.string.account'), flag: false })

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
            AccountInfo({
              email: this.email,
              username: this.username,
              signature: this.signature,
              bundleName: this.bundleName,
              isWideLayout: true
            })
          }
          .width('68%')
          .height('100%')
          .padding({ left: 8, right: 12, top: 10, bottom: 10 })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Row() {
          Column() {
            AccountInfo({
              email: this.email,
              username: this.username,
              signature: this.signature,
              bundleName: this.bundleName,
              isWideLayout: false
            })
          }
          .width('100%')
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
