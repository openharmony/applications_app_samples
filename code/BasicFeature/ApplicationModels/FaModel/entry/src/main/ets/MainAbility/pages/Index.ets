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

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Text($r('app.string.fa_model'))
          .fontSize(24)
      }
      .width('100%')
      .height('8%')
      .justifyContent(FlexAlign.Center)

      Column() {
        this.ButtonS($r('app.string.data_page'), () => {
          router.push({
            url: 'pages/DataPage'
          })
        })
        this.ButtonS($r('app.string.service_page'), () => {
          router.push({
            url: 'pages/ServicePage'
          })
        })
        this.ButtonS($r('app.string.feature_page'), () => {
          router.push({
            url: 'pages/FeaturePage'
          })
        })
        this.ButtonS($r('app.string.data_helper'), () => {
          router.push({
            url: 'pages/DAHelperPage'
          })
        })

        this.ButtonS($r('app.string.app_context'), () => {
          router.push({
            url: 'pages/AppContextPage'
          })
        })

        this.ButtonS($r('app.string.particle_page'), () => {
          router.push({
            url: 'pages/ParticlePage'
          })
        })
      }
      .width('100%')
      .height('92%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  @Builder ButtonS(textStr: Resource, click) {
    Button(textStr)
      .width('60%')
      .margin({ top: 30 })
      .onClick(click)
  }
}

