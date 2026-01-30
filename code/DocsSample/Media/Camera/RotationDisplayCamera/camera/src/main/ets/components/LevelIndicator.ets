/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { curves, display } from '@kit.ArkUI';
import { sensor } from '@kit.SensorServiceKit';

const ANGLE_DIFFERENCE: number = 3;

// [Start LevelIndicator]
@Component
export struct LevelIndicator {
  @Prop acc: sensor.AccelerometerResponse;

  getRotate() {
    const rotation = display.getDefaultDisplaySync().rotation * 90;
    if (rotation === 90 || rotation === 270) {
      return -Math.atan2(-this.acc.y, this.acc.x) * (180 / Math.PI);
    }
    return -Math.atan2(-this.acc.x, this.acc.y) * (180 / Math.PI);
  }

  isAlign() {
    return Math.abs(this.getRotate()) - 0 <= ANGLE_DIFFERENCE ||
      Math.abs(Math.abs(this.getRotate()) - 90) <= ANGLE_DIFFERENCE;
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Line({
        width: 200,
        height: 1
      })
        // [StartExclude LevelIndicator]
        .stroke(Color.White)
        .endPoint([200, 0])
        // [EndExclude LevelIndicator]
        .strokeDashArray([3, this.isAlign() ? 0 : 3])
        .opacity(this.isAlign() ? 1 : 0.5)
        .rotate({ angle: this.getRotate(), centerX: '50%', centerY: '50%' })
        .animation({
          curve: curves.springMotion(0.6, 0.8),
          iterations: 1,
          playMode: PlayMode.Normal
        })
      Circle()
        // [StartExclude LevelIndicator]
        .width(48)
        .height(48)
        .stroke(Color.White)
        .fill(Color.Transparent)
        // [EndExclude LevelIndicator]
        .opacity(this.isAlign() ? 1 : 0.5)
    }
    // [StartExclude LevelIndicator]
    .width('100%')
    .height('100%')
    // [EndExclude LevelIndicator]
    .hitTestBehavior(HitTestMode.Transparent)
  }
}
// [End LevelIndicator]
