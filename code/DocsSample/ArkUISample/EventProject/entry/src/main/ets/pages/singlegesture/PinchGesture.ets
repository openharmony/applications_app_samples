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

// [Start catch_pinch_gesture_event]
@Entry
@Component
export struct Pinch {
  @State scaleValue: number = 1;
  @State pinchValue: number = 1;
  @State pinchX: number = 0;
  @State pinchY: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Column() {
            Text('PinchGesture scale:\n' + this.scaleValue)
            Text('PinchGesture center:\n(' + this.pinchX + ',' + this.pinchY + ')')
          }
          .height(200)
          .width(300)
          .border({ width: 3 })
          .margin({ top: 100 })
          // 在组件上绑定缩放比例，可以通过修改缩放比例来实现组件的缩小或者放大
          .scale({ x: this.scaleValue, y: this.scaleValue, z: 1 })
          .gesture(
            // 在组件上绑定三指触发的捏合手势
            PinchGesture({ fingers: 3 })
              .onActionStart((event: GestureEvent | undefined) => {
                console.info('Pinch start');
              })// 当捏合手势触发时，可以通过回调函数获取缩放比例，从而修改组件的缩放比例
              .onActionUpdate((event: GestureEvent | undefined) => {
                if (event) {
                  this.scaleValue = this.pinchValue * event.scale;
                  this.pinchX = event.pinchCenterX;
                  this.pinchY = event.pinchCenterY;
                }
              })
              .onActionEnd(() => {
                this.pinchValue = this.scaleValue;
                console.info('Pinch end');
              })
          )
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.singlegesture_PinchGesture_title'))
  }
}
// [End catch_pinch_gesture_event]