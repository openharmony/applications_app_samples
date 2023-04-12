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
import DataAbilityHelper from '../feature/DataAbilityHelper'

@Entry
@Component
export struct DAHelperPage {
  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(32)
          .height(32)
          .margin({ left: 32, right: 32 })
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.data_helper'))
          .fontColor(Color.Black)
          .fontSize(30)
          .fontWeight(500)
          .layoutWeight(1)
      }
      .width('100%')
      .height('8%')

      Scroll() {
        Column() {
          this.ButtonStyle($r('app.string.open_file'), DataAbilityHelper.openFile)
          this.ButtonStyle($r('app.string.on'), DataAbilityHelper.on)
          this.ButtonStyle($r('app.string.off'), DataAbilityHelper.off)
          this.ButtonStyle($r('app.string.get_type'), DataAbilityHelper.getType)
          this.ButtonStyle($r('app.string.get_file_types'), DataAbilityHelper.getFileTypes)
          this.ButtonStyle($r('app.string.normalize_uri'), DataAbilityHelper.normalizeUri)
          this.ButtonStyle($r('app.string.denormalize_uri'), DataAbilityHelper.denormalizeUri)
          this.ButtonStyle($r('app.string.notify_change'), DataAbilityHelper.notifyChange)
          this.ButtonStyle($r('app.string.call'), DataAbilityHelper.call)
          this.ButtonStyle($r('app.string.execute_batch'), DataAbilityHelper.executeBatch)
        }
        .width('100%')
      }
      .width('100%')
      .height('92%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder ButtonStyle(textStr: Resource, click) {
    Button(textStr)
      .width('60%')
      .margin({ top: 30 })
      .onClick(click)
  }
}