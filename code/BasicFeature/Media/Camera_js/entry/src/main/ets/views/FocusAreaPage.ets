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

import CameraService from '../model/CameraService';
import Logger from '../model/Logger';

const TAG: string = 'FocusAreaPage';

// 对焦区域
@Component
export struct FocusAreaPage {
  @Link focusPointBol: boolean;
  @Link focusPointVal: Array<number>;
  // 刻度、焦距值 和 对焦框不能共存的显示
  @Link exposureBol: boolean;
  // 曝光值
  @Link exposureNum: number;
  @Prop xComponentWidth: number;
  @Prop xComponentHeight: number;
  // 对焦区域显示框定时器
  private areaTimer: number = -1;
  // 上下滑动曝光
  private panOption: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Up | PanDirection.Down,
    fingers: 1
  });

  build() {
    Row() {}
    .width(this.xComponentWidth)
    .height(this.xComponentHeight)
    .opacity(1)
    .onTouch((e: TouchEvent) => {
      if (e.type === TouchType.Down) {
        this.focusPointBol = true;
        this.focusPointVal[0] = e.touches[0].screenX;
        this.focusPointVal[1] = e.touches[0].screenY;
        // 焦点
        CameraService.isFocusPoint({
          x: e.touches[0].screenX / this.xComponentWidth,
          y: e.touches[0].screenY / this.xComponentHeight
        });
        // 曝光区域
        CameraService.isMeteringPoint({
          x: e.touches[0].screenX / this.xComponentWidth,
          y: e.touches[0].screenY / this.xComponentHeight + 50
        });
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
    .onClick((event: ClickEvent) => {
      AppStorage.setOrCreate<boolean>('flashingBol', true);
      AppStorage.setOrCreate<boolean>('countdownBol', true);
      AppStorage.setOrCreate<boolean>('colorEffectComponentIsShow', true);
      AppStorage.setOrCreate<boolean>('deferredPhotoComponentIsShow', true);
    })
    // 单指竖直方向拖动触发该手势事件
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
        // 曝光补偿 -4 +4
        CameraService.isExposureBiasRange(this.exposureNum);
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
