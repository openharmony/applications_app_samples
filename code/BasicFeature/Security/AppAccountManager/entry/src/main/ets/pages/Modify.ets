/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import { ModifyInfo } from '../common/ModifyInfo';
import { NavigationBar } from '../common/NavigationBar';
import { BundleInfo } from '../common/BundleInfo';

interface ModifyPageParams {
  username?: string
  signature?: string
  email?: string
  bundleName?: string
}

@Entry
@Component
struct Modify {
  @State username: string = '';
  @StorageLink('selectedBundleName') @Watch('onBundleNameChange') bundleName: string = 'Music';
  @State signature: string = '';
  @State email: string = '';
  @State isWideLayout: boolean = false;
  private readonly splitThreshold: number = 840;

  aboutToAppear() {
    const params: ModifyPageParams = router.getParams() as ModifyPageParams;
    this.username = params.username ?? '';
    this.signature = params.signature ?? '';
    this.email = params.email ?? '';
    let bundleNameFromParam: string = params.bundleName ?? '';
    if (bundleNameFromParam) {
      this.bundleName = bundleNameFromParam;
      AppStorage.SetOrCreate<string>('selectedBundleName', bundleNameFromParam);
    }
  }

  onBundleNameChange() {
    this.username = '';
    this.signature = '';
    this.email = '';
  }

  build() {
    Column() {
      NavigationBar({
        title: $r('app.string.modify'),
        flag: true,
        url: 'pages/Account',
        username: this.username,
        bundleName: this.bundleName,
        signature: this.signature,
        email: this.email
      })

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

          Scroll() {
            Column() {
              ModifyInfo({ bundleName: this.bundleName, username: this.username, isWideLayout: true })
            }
            .width('100%')
          }
          .width('68%')
          .height('100%')
          .padding({ left: 8, right: 12, top: 10, bottom: 10 })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Row() {
          Scroll() {
            Column() {
              ModifyInfo({ bundleName: this.bundleName, username: this.username, isWideLayout: false })
            }
            .width('100%')
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
      this.isWideLayout = Number(newArea.width) >= this.splitThreshold;
    })
  }
}
