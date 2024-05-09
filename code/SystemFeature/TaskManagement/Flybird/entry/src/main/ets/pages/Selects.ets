/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import Logger from '../model/Logger';

const TAG = "SelectsPage"

async function routePage(uri_string, idNum) {
  let options = {
    url: uri_string,
    params: {
      'id': idNum
    }
  }
  try {
    await router.push(options)
  } catch (err) {
    Logger.error(TAG,' fail callback,code: ${err.code},msg: ${err,msg}')
  }
}

@Entry
@Component
struct Selects {
  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text($r('app.string.select_level'))
          .fontSize(60)
        Button() {
          Text($r('app.string.level_one'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor($r('app.color.btn_background'))
        .onClick(() => {
          routePage('pages/Game', 1)
        })

        Button() {
          Text($r('app.string.level_two'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor($r('app.color.btn_background'))
        .onClick(() => {
          routePage('pages/Game', 2)
        })

        Button() {
          Text($r('app.string.level_three'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor($r('app.color.btn_background'))
        .onClick(() => {
          routePage('pages/Game', 3)
        })

        Button() {
          Text($r('app.string.level_four'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor($r('app.color.btn_background'))
        .onClick(() => {
          routePage('pages/Game', 4)
        })

        Button() {
          Text($r('app.string.level_five'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor($r('app.color.btn_background'))
        .onClick(() => {
          routePage('pages/Game', 5)
        })

        Button() {
          Text($r('app.string.back'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor($r('app.color.btn_background'))
        .onClick(() => {
          router.back()
        })
      }
    }.width('100%')
    .height('100%')
  }
}