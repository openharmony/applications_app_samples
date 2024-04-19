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

import DateShareHelper from '../feature/DataShareHelper'
import { PublicTitleBar } from './component/PublicTitleBar'

@Entry
@Component
struct DataShareHelperPage {
  build() {
    Column() {
      PublicTitleBar({ textName: $r('app.string.data_share_helper_page') })
      Scroll() {
        Column() {
          Button($r('app.string.denormalize_uri'))
            .fancy(DateShareHelper.denormalizeUri)
          Button($r('app.string.normalize_uri'))
            .fancy(DateShareHelper.normalizeUri)
          Button($r('app.string.notify_change'))
            .fancy(DateShareHelper.notifyChange)
          Button($r('app.string.on'))
            .fancy(DateShareHelper.on)
          Button($r('app.string.off'))
            .fancy(DateShareHelper.off)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })
  }

  async aboutToAppear() {
    let context = getContext(this)
    await DateShareHelper.getDataShareHelper(context)
  }
}

@Extend(Button) function fancy (handleClick: ()=>void) {
  .width('60%')
  .height(40)
  .align(Alignment.Center)
  .margin({ top: 30 })
  .onClick(handleClick)
}