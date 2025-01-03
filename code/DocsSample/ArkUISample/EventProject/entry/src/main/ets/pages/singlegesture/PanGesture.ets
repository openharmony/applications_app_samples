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
export struct Pan {
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State positionX: number = 0;
  @State positionY: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Text('PanGesture Offset:\nX: ' + this.offsetX + '\n' + 'Y: ' + this.offsetY)
            .fontSize(28)
            .height(200)
            .width(300)
            .padding(20)
            .border({ width: 3 })
              // 在组件上绑定布局位置信息
            .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
            .gesture(
              // 绑定拖动手势
              PanGesture()
                .onActionStart((event: GestureEvent|undefined) => {
                  console.info('Pan start');
                })
                  // 当触发拖动手势时，根据回调函数修改组件的布局位置信息
                .onActionUpdate((event: GestureEvent|undefined) => {
                  if(event){
                    this.offsetX = this.positionX + event.offsetX;
                    this.offsetY = this.positionY + event.offsetY;
                  }
                })
                .onActionEnd(() => {
                  this.positionX = this.offsetX;
                  this.positionY = this.offsetY;
                })
            )
        }
        .height(200)
        .width(250)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.singlegesture_PanGesture_title'))
  }
}