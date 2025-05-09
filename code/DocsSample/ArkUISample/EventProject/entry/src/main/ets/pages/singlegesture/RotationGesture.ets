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

// [Start catch_rotation_gesture_event]
@Entry
@Component
export struct Rotation {
  @State angle: number = 0;
  @State rotateValue: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Text('RotationGesture angle:' + this.angle).fontSize(28)
            // 在组件上绑定旋转布局，可以通过修改旋转角度来实现组件的旋转
            .rotate({ angle: this.angle })
            .gesture(
              RotationGesture()
                .onActionStart((event: GestureEvent|undefined) => {
                  console.info('RotationGesture is onActionStart');
                })
                  // 当旋转手势生效时，通过旋转手势的回调函数获取旋转角度，从而修改组件的旋转角度
                .onActionUpdate((event: GestureEvent|undefined) => {
                  if(event){
                    this.angle = this.rotateValue + event.angle;
                  }
                  console.info('RotationGesture is onActionEnd');
                })
                  // 当旋转结束抬手时，固定组件在旋转结束时的角度
                .onActionEnd(() => {
                  this.rotateValue = this.angle;
                  console.info('RotationGesture is onActionEnd');
                })
                .onActionCancel(() => {
                  console.info('RotationGesture is onActionCancel');
                })
            )
            .height(200)
            .width(300)
            .padding(20)
            .border({ width: 3 })
            .margin(100)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.singlegesture_RotationGesture_title'))
  }
}
// [End catch_rotation_gesture_event]