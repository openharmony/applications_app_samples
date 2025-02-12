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
export struct Sequence {
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State count: number = 0;
  @State positionX: number = 0;
  @State positionY: number = 0;
  @State borderStyles: BorderStyle = BorderStyle.Solid;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Text($r('app.string.groupgesture_Sequence_text'))
          .fontSize(14)
          .fontColor('#666')
        Column() {
          Text('sequence gesture\n' + 'LongPress onAction:' + this.count + '\nPanGesture offset:\nX: ' + this.offsetX + '\n' + 'Y: ' + this.offsetY)
            .fontSize(28)
        }.margin(10)
        .borderWidth(1)
        // 绑定translate属性可以实现组件的位置移动
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .height(250)
        .width(300)
        // 以下组合手势为顺序识别，当长按手势事件未正常触发时不会触发拖动手势事件
        .gesture(
          // 声明该组合手势的类型为Sequence类型
          GestureGroup(GestureMode.Sequence,
            // 该组合手势第一个触发的手势为长按手势，且长按手势可多次响应
            LongPressGesture({ repeat: true })
              // 当长按手势识别成功，增加Text组件上显示的count次数
              .onAction((event: GestureEvent|undefined) => {
                if(event){
                  if (event.repeat) {
                    this.count++;
                  }
                }
                console.info('LongPress onAction');
              })
              .onActionEnd(() => {
                console.info('LongPress end');
              }),
            // 当长按之后进行拖动，PanGesture手势被触发
            PanGesture()
              .onActionStart(() => {
                this.borderStyles = BorderStyle.Dashed;
                console.info('pan start');
              })
                // 当该手势被触发时，根据回调获得拖动的距离，修改该组件的位移距离从而实现组件的移动
              .onActionUpdate((event: GestureEvent|undefined) => {
                if(event){
                  this.offsetX = (this.positionX + event.offsetX);
                  this.offsetY = this.positionY + event.offsetY;
                }
                console.info('pan update');
              })
              .onActionEnd(() => {
                this.positionX = this.offsetX;
                this.positionY = this.offsetY;
                this.borderStyles = BorderStyle.Solid;
              })
          )
            .onCancel(() => {
              console.log('sequence gesture canceled');
            })
        )
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.groupgesture_Sequence_title'))
  }
}