/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start gesture_motioncontrol]
@Entry
@Component
struct CustomGestureControlGroup {
  @State offsetY: number = 0
  scroller2: Scroller = new Scroller();
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  private childRecognizer: GestureRecognizer = new GestureRecognizer();
  private currentRecognizer: GestureRecognizer = new GestureRecognizer();
  private lastOffset: number = 0;

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() { // 外部滚动容器
        Column() {
          Text('Scroll Area')
            .width('90%')
            .height(150)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
          Scroll(this.scroller2) { // 内部滚动容器
            Column() {
              Text('Scroll Area2')
                .width('90%')
                .height(150)
                .backgroundColor(0xFFFFFF)
                .borderRadius(15)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .margin({ top: 10 })
              Column() {
                ForEach(this.arr, (item: number) => {
                  Text(item.toString())
                    .width('90%')
                    .height(150)
                    .backgroundColor(0xFFFFFF)
                    .borderRadius(15)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .margin({ top: 10 })
                }, (item: string) => item)
              }.width('100%')
            }
          }
          .id('inner')
          .width('100%')
          .height(800)
        }
        .width('100%')
        .offset({ y: -this.offsetY })
      }
      .id('outer')
      .height(600)
      .clip(true)
      .gesture(
        PanGesture()
          .onActionStart((event: GestureEvent) => {
            this.lastOffset = this.offsetY // 手势开始时，记录当前滚动位置
          })
          .onActionUpdate((event: GestureEvent) => {
            let moveY = event.offsetY; // 手势移动时，计算新位置
            let targetOffset = this.lastOffset - moveY; // 目标位置 = 初始位置 - 移动距离
            this.offsetY = Math.max(0, Math.min(360, targetOffset));
          })
      )
      // [Start gesture_simultaneously]
      .shouldRecognizerParallelWith((current: GestureRecognizer, others: Array<GestureRecognizer>) => {
        for (let i = 0; i < others.length; i++) {
          let target = others[i].getEventTargetInfo();
          if (target) {
            if (target.getId() == 'inner' && others[i].isBuiltIn() &&
              others[i].getType() == GestureControl.GestureType.PAN_GESTURE) { // 找到将要组成并行手势的识别器
              this.currentRecognizer = current; // 保存当前组件的识别器
              this.childRecognizer = others[i]; // 保存将要组成并行手势的识别器
              return others[i]; // 返回将要组成并行手势的识别器
            }
          }
        }
        return undefined;
      })
      // [End gesture_simultaneously]
      // [Start gesture_openingclosing]
      .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
        others: Array<GestureRecognizer>) => { // 在识别器即将要成功时，根据当前组件状态，设置识别器使能状态
        let target = current.getEventTargetInfo();
        if (target && target.getId() == 'outer' &&
          current.getType() == GestureControl.GestureType.PAN_GESTURE) {
          for (let i = 0; i < others.length; i++) {
            let target = others[i].getEventTargetInfo();
            if (target instanceof ScrollableTargetInfo && target.getId() == 'inner') { // 找到响应链上对应并行的识别器
              let panEvent = event as PanGestureEvent;
              if (target.isEnd()) { // 根据当前组件状态以及移动方向动态控制识别器使能状态
                if (panEvent && panEvent.offsetY < 0) {
                  this.childRecognizer.setEnabled(false);
                  this.currentRecognizer.setEnabled(true);
                } else {
                  this.childRecognizer.setEnabled(true);
                  this.currentRecognizer.setEnabled(false);
                }
              } else if (target.isBegin()) {
                if (panEvent.offsetY > 0) {
                  this.childRecognizer.setEnabled(false);
                  this.currentRecognizer.setEnabled(true);
                } else {
                  this.childRecognizer.setEnabled(true);
                  this.currentRecognizer.setEnabled(false);
                }
              } else {
                this.childRecognizer.setEnabled(true);
                this.currentRecognizer.setEnabled(false);
              }
            }
          }
        }
        return GestureJudgeResult.CONTINUE;
      })
      // [End gesture_openingclosing]
    }.width('100%').height('100%').backgroundColor(0xDCDCDC)
  }
}
// [End gesture_motioncontrol]