/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start sliding_gesture]
@Entry
@Component
export struct VolumeControlDemo {
  @State currentVolume: number = 50;
  private readonly MAX_VOLUME: number = 100;
  private readonly MIN_VOLUME: number = 0;

  private handlePanUpdate(event: GestureEvent) {
    const volumeChange = -event.offsetY * 0.1;
    this.handleVolumeChange(volumeChange);
  }

  private handleWheelEvent(event: GestureEvent) {
    const volumeChange = event.offsetY * 0.1;
    this.handleVolumeChange(volumeChange);
  }

  private handleTouchPadScroll(event: GestureEvent) {
    const volumeChange = -event.offsetY * 0.02;
    this.handleVolumeChange(volumeChange);
  }

  private handleVolumeChange(delta: number) {
    this.currentVolume = Math.min(
      this.MAX_VOLUME,
      Math.max(this.MIN_VOLUME, this.currentVolume + delta)
    );
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          // $r('app.string.video')资源文件中的value值为'音量'
          Text($r('app.string.video'))
          Text(`： ${this.currentVolume}`).fontSize(20)
        }.margin(10)
        Column()
          .width('100%')
          .height(250)
          .backgroundColor('#F5F5F5')
          .borderRadius(12)
          .gesture(
            PanGesture()
              .onActionStart(() => {
                console.info('Pan start');
              })
              .onActionUpdate((event: GestureEvent) => {
                if (event.source === SourceType.TouchScreen) {
                  console.info('finger move triggered PanGesture');
                  this.handlePanUpdate(event);
                }
                if (event.source === SourceType.Mouse && event.sourceTool === SourceTool.MOUSE) {
                  if (event.axisHorizontal === 0 && event.axisVertical === 0) {
                    console.info('mouse move with left button pressed triggered PanGesture');
                    this.handlePanUpdate(event);
                  } else { 
                    console.info('mouse wheel triggered PanGesture');
                    this.handleWheelEvent(event);
                  }
                }
                if (event.sourceTool === SourceTool.TOUCHPAD &&
                  (event.axisHorizontal !== 0 || event.axisVertical !== 0)) {
                  console.info('touchpad double finger move triggered PanGesture');
                  this.handleTouchPadScroll(event);
                }
              })
          )
      }
      .width('100%')
      .height('100%')
      .padding(20)
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.singlegesture_Index_Pancom_title')资源文件中的value值为'滑动手势'
    .title($r('app.string.singlegesture_Index_Pancom_title'))
  }
}
// [End sliding_gesture]