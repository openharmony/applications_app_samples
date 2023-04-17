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

import sensor from '@ohos.sensor'
import mediaQuery from '@ohos.mediaquery'
import Logger from '../util/Logger'

const TAG = 'Index'

@Entry
@Component
struct Index {
  @State angle: number = 0
  @State angleTest: string = '0°'
  @State isLand: boolean = false
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  onLand = (mediaQueryResult) => {
    Logger.info(` onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  aboutToAppear() {
    this.listener.on('change', this.onLand)
    try {
      sensor.on(sensor.SensorType.SENSOR_TYPE_ID_ORIENTATION, function(data){
        Logger.info(TAG, ` component: on`)
        Logger.info(TAG, ` X-coordinate component: ${data.beta}`)
        Logger.info(TAG, ` Y-coordinate component: ${data.gamma}`)
        Logger.info(TAG, ` Z-coordinate component: ${data.alpha}`)
        this.angle = Math.round(data.alpha)
        this.angleTest = this.angle + '°'
      }.bind(this), { interval: 10000000 })
    } catch (err) {
      Logger.error(TAG, `Failed to load sensor :  ${JSON.stringify(err)}`)
    }
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.north'))
          .fontSize(20)
          .margin({ left: '60%' })
          .zIndex(2)

        Image(this.isLand ? $r('app.media.compass') : $r('app.media.compass_'))
          .objectFit(ImageFit.Auto)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: this.angle
          })
          .size({ width: '40%', height: '70%' })
      }
      .width('100%')
      .margin({ top: '10%' })

      Text(this.angleTest)
        .fontSize(30)
    }
  }
}