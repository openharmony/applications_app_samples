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

import BundleController from '../feature/BundleController'
import { PublicTitleBar } from './component/PublicTitleBar'

@Entry
@Component
struct BundlePage {
  private bundles: BundleController = new BundleController()

  build() {
    Column() {
      PublicTitleBar({ textName: $r('app.string.bundle_page') })
      Scroll() {
        Column() {
          Button($r('app.string.get_application_info'))
            .fancy(() => {
              this.bundles.getApplicationInfo()
            })

          Button($r('app.string.entity_type'))
            .fancy(() => {
              this.bundles.entityType()
            })

          Button($r('app.string.process'))
            .fancy(() => {
              this.bundles.process()
            })

          Button($r('app.string.entry_dir'))
            .fancy(() => {
              this.bundles.entryDir()
            })

          Button($r('app.string.get_dispatcher_version'))
            .fancy(() => {
              this.bundles.getDispatcherVersion()
            })

          // 获取当前ability的ohos.bundle.ElementName对象,对应FA的getElementName()
          Button($r('app.string.get_ability_info'))
            .fancy(() => {
              this.bundles.getAbilityInfo()
            })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
    }
  }
}

@Extend(Button) function fancy (click) {
  .width('60%')
  .height(40)
  .align(Alignment.Center)
  .margin({ top: 30 })
  .onClick(click)
}