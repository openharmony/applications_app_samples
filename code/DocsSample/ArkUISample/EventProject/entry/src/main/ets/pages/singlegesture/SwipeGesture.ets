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

@Entry
@Component
export struct Swipe {
  @State rotateAngle: number = 0;
  @State speed: number = 1;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Column() {
            Text('SwipeGesture speed\n' + this.speed)
            Text('SwipeGesture angle\n' + this.rotateAngle)
          }
          .border({ width: 3 })
          .width(300)
          .height(200)
          .margin(100)
          // 在Column组件上绑定旋转，通过滑动手势的滑动速度和角度修改旋转的角度
          .rotate({ angle: this.rotateAngle })
          .gesture(
            // 绑定滑动手势且限制仅在竖直方向滑动时触发
            SwipeGesture({ direction: SwipeDirection.Vertical })
              // 当滑动手势触发时，获取滑动的速度和角度，实现对组件的布局参数的修改
              .onAction((event: GestureEvent|undefined) => {
                if(event){
                  this.speed = event.speed;
                  this.rotateAngle = event.angle;
                }
              })
          )
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.singlegesture_SwipeGesture_title'))
  }
}