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

import sensor from '@ohos.sensor';
import mediaQuery from '@ohos.mediaquery';
import { SubscribeSensor, UnsubscribeSensor } from 'library';
import Logger from '../moudle/Logger'

const TAG = '[sensor]'

@Entry
@Component
struct Index {
  @State angle: number = 0;
  @State angleTest: string = '0°';
  @State isLand: boolean = false;
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)');
  onLand = (mediaQueryResult) => {
    Logger.info(`${TAG} onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`);
    if (mediaQueryResult.matches) {
      this.isLand = true;
    } else {
      this.isLand = false;
    }
  }

  aboutToAppear() {
    Logger.info(`${TAG} aboutToAppear: enter`);
    this.listener.on('change', this.onLand);
    SubscribeSensor(sensor.SensorType.SENSOR_TYPE_ID_ORIENTATION, 200000000, function(data){
      Logger.info(`${TAG} component: on`);
      Logger.info(`${TAG} Z-coordinate component: ${data.data[0]}`);
      Logger.info(`${TAG} X-coordinate component: ${data.data[1]}`);
      Logger.info(`${TAG} Y-coordinate component: ${data.data[2]}`);
      this.angle = Math.round(data.data[0]);
      if (this.angle == 360) {
        this.angle = 0;
      }
      this.angleTest = this.angle + '°';
    }.bind(this));
  }

  aboutToDisappear() {
    Logger.info(`${TAG} aboutToDisappear: enter`);
    UnsubscribeSensor(sensor.SensorType.SENSOR_TYPE_ID_ORIENTATION);
  }

  build() {
    Column() {
      Column() {
        Text($r("app.string.north"))
          .fontSize(20)
          .margin({ left: '60%' })
          .id('directionMy');

        Image(this.isLand ? $r('app.media.compass') : $r('app.media.compass'))
          .id('compassPointing')
          .objectFit(ImageFit.Auto)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: this.angle
          })
          .size({ width: '40%', height: '70%' });
      }
      .width('100%')
      .margin({ top: '10%' });

      Text(this.angleTest)
        .fontSize(30)
        .id('tiltAngle');
    }
  }
}