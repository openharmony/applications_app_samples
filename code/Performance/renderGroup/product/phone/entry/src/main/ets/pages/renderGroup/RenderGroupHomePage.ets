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

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Row(){
          Image($r("app.media.back"))
            .id('returnBtn')
            .height($r('app.integer.RenderGroup_scene_back_image_size'))
            .width($r('app.integer.RenderGroup_scene_back_image_size'))
            .onClick(() => {
              router.back();
            })

          Text($r('app.string.RenderGroupHomePage_title'))
            .fontSize($r('app.integer.RenderGroupHomePage_title_font'))
            .lineHeight($r('app.integer.RenderGroupHomePage_title_lineHeight'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .width($r('app.string.layout_100_percent'))
            .height($r('app.integer.RenderGroupHomePage_title_height'))
        }
        .height($r('app.integer.RenderGroupHomePage_row_height'))
        .backgroundColor(Color.White)
        }
      .margin({
        left: $r('app.integer.RenderGroup_scene_row_margin_left')
      })

      Button($r('app.string.RenderGroup_profit_scene_button_title'), { type: ButtonType.Normal, stateEffect: true })
        .id('ProfitScenePage')
        .fontSize($r('app.integer.RenderGroup_scene_button_font'))
        .borderRadius($r('app.integer.RenderGroup_scene_button_borderRadius'))
        .backgroundColor($r('app.color.RenderGroup_scene_button_backgroundColor'))
        .width($r('app.integer.RenderGroup_scene_button_width'))
        .height($r('app.integer.RenderGroup_scene_button_height'))
        .margin({
          top: $r('app.integer.RenderGroup_scene_button_margin_top')
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/renderGroup/ProfitScenePage'
          })
        })

      Button($r('app.string.RenderGroup_nonProfit_scene_button_title'), { type: ButtonType.Normal, stateEffect: true })
        .id('NonProfitScenePage')
        .fontSize($r('app.integer.RenderGroup_scene_button_font'))
        .borderRadius($r('app.integer.RenderGroup_scene_button_borderRadius'))
        .backgroundColor($r('app.color.RenderGroup_scene_button_backgroundColor'))
        .width($r('app.integer.RenderGroup_scene_button_width'))
        .height($r('app.integer.RenderGroup_scene_button_height'))
        .margin({
          top: $r('app.integer.RenderGroup_scene_button_margin_top')
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/renderGroup/NonProfitScenePage'
          })
        })
    }
    .height($r('app.integer.RenderGroup_scene_row_height'))
    .width($r('app.string.layout_100_percent'))
  }
}