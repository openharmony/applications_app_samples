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

import HomeContent from './home/HomeContent'
import Logger from '../util/Logger'
import HomeFeature from '../feature/HomeFeature'

const SUCCESS_CODE = 0 // 成功
const TAG: string = 'Index'

@Entry
@Component
struct Home {
  @State currentWeather: number = 36
  private context: any = getContext(this)
  private homeFeature = new HomeFeature(this.context)

  updateWeatherTask() {
    Logger.info(TAG, `updateWeatherTask`)
    let that = this
    this.homeFeature.connectServiceExtAbility(function (code, data) {
      if (code === SUCCESS_CODE) {
        that.currentWeather = data
        Logger.info(TAG, `updateWeatherTask, that.currentWeather = ${that.currentWeather}`)
      } else {
        Logger.info(TAG, `updateWeatherTask, connectServiceExtAbility fail`)
      }
    })
    setTimeout(() => {
      this.updateWeatherTask()
    }, 5000)
  }

  aboutToAppear() {
    this.updateWeatherTask()
  }

  build() {
    Column() {
      Swiper() {
        HomeContent({ currentWeather: this.currentWeather })
      }
      .indicatorStyle({ selectedColor: Color.White })
      .loop(false)
      .width('100%')
      .layoutWeight(1)
    }
    .height('100%')
    .backgroundImage($r('app.media.sunny_bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}