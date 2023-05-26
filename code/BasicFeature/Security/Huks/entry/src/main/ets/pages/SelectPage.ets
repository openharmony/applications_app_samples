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

import router from '@ohos.router'
import { NewKey } from '../common/NewKey'
import { OldKey } from '../common/OldKey'

@Entry
@Component
struct SelectPage {
  private flag: boolean = router.getParams()['flag']

  @Builder NavigationTitle() {
    Column() {
      Text($r('app.string.back'))
        .fontColor('#182431')
        .fontSize(20)
        .lineHeight(25)
        .fontWeight(700)
    }
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      Navigation() {
        if (this.flag) {
          NewKey()
        } else {
          OldKey()
        }
      }
      .title({ builder: this.NavigationTitle, height: 56 })
      .titleMode(NavigationTitleMode.Mini)
      .hideTitleBar(false)
      .hideToolBar(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F1F1')
  }
}