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
import prompt from '@ohos.promptAction'
import FeatureAbilityHelper from '../feature/FeatureAbilityHelper'

@Entry
@Component
struct FeaturePage {
  @State @Watch('resultChange') result: string = ''

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
        Text($r('app.string.feature_page'))
          .fontColor(Color.Black)
          .fontSize(30)
          .fontWeight(500)
          .layoutWeight(1)
      }
      .width('100%')
      .height('8%')

      Column() {
        this.ButtonStyle($r('app.string.get_want'), FeatureAbilityHelper.getWant)
        this.ButtonStyle($r('app.string.start_ability'), FeatureAbilityHelper.startAbilityForResult)
        this.ButtonStyle($r('app.string.acquire_data_ability_helper'), FeatureAbilityHelper.acquireDataAbilityHelper)
        this.ButtonStyle($r('app.string.terminate_self_with_result'), FeatureAbilityHelper.terminateSelfWithResult)
        this.ButtonStyle($r('app.string.has_window_focus'), FeatureAbilityHelper.hasWindowFocus)
        this.ButtonStyle($r('app.string.terminate_self'), FeatureAbilityHelper.terminateSelf)
        this.ButtonStyle($r('app.string.get_window'), FeatureAbilityHelper.getWindow)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
  }

  @Builder ButtonStyle(textStr: Resource, click) {
    Button(textStr)
      .width('60%')
      .margin({ top: 30 })
      .onClick(click)
  }

  resultChange() {
    prompt.showToast({
      message: this.result,
      duration: 2000,
    })
  }
}