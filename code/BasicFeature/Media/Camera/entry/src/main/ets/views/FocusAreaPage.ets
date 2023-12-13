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

import cameraDemo from 'libentry.so';
import Logger from '../model/Logger';

const TAG: string = 'FocusAreaPage';

// Focus Area
@Component
export struct FocusAreaPage {
  @Link focusPointBol: boolean;
  @Link focusPointVal: Array<number>;
  // Display where scale, focal length value, and focus box cannot coexist
  @Link exposureBol: boolean;
  // Exposure value
  @Link exposureNum: number;
  @Prop xComponentWidth: number;
  @Prop xComponentHeight: number;
  // Focusing area display box timer
  private areaTimer: number = -1;
  // Sliding Exposure Up and Down
  private panOption: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Up | PanDirection.Down,
    fingers: 1
  });

  build() {
    Row() {
    }
    .width(this.xComponentWidth)
    .height(this.xComponentHeight)
    .opacity(1)
    .id('FocusArea')
    .onTouch((e: TouchEvent) => {
      if (e.type === TouchType.Down) {
        this.focusPointBol = true;
        this.focusPointVal[0] = e.touches[0].screenX;
        this.focusPointVal[1] = e.touches[0].screenY;
        // Focus point
        cameraDemo.isFocusPoint(
          e.touches[0].screenX / this.xComponentWidth,
          e.touches[0].screenY / this.xComponentHeight
        );
        cameraDemo.isMeteringPoint(
          e.touches[0].screenX / this.xComponentWidth,
          e.touches[0].screenY / this.xComponentHeight + 50
        );
      }
      if (e.type === TouchType.Up) {
        if (this.areaTimer) {
          clearTimeout(this.areaTimer);
        }
        this.areaTimer = setTimeout(() => {
          this.focusPointBol = false;
        }, 3500);
      }
    })
    // Trigger this gesture event by dragging vertically with one finger
    .gesture(
      PanGesture(this.panOption)
        .onActionStart(() => {
          Logger.info(TAG, 'PanGesture onActionStart');
          this.exposureBol = false;
        })
        .onActionUpdate((event: GestureEvent) => {
          let offset = -event.offsetY;
          if (offset > 200) {
            this.exposureNum = 4;
          }
          if (offset < -200) {
            this.exposureNum = -4;
          }
          if (offset > -200 && offset < 200) {
            this.exposureNum = Number((offset / 50).toFixed(1));
          }
          // Exposure Compensation -4 +4
          cameraDemo.isExposureBiasRange(this.exposureNum);
          Logger.info(TAG, `PanGesture onActionUpdate offset: ${offset}, exposureNum: ${this.exposureNum}`);
        })
        .onActionEnd(() => {
          this.exposureNum = 0;
          this.exposureBol = true;
          Logger.info(TAG, 'PanGesture onActionEnd end');
        })
    )
  }
}