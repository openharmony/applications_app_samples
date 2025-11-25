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

// [Start click_event]
@Entry
@Component
export struct OnClickGesture {
  private judgeCount: number = 0;

  increaseJudgeGuard(): void {
    this.judgeCount++;
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Column()
            .width('60%')
            .height('50%')
            .backgroundColor(Color.Grey)
            .onClick(() => { // 1. 子组件上注册了点击事件，正常情况下点击在子组件上时，优先得到响应
              console.info('Clicked on child');
              this.increaseJudgeGuard();
            })
            .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
              // 3. 当数字增长为5的倍数时禁用子组件上的点击手势，这样父组件上的点击可以得到响应
              if (this.judgeCount % 5 == 0 && gestureInfo.type == GestureControl.GestureType.CLICK) {
                return GestureJudgeResult.REJECT;
              } else {
                return GestureJudgeResult.CONTINUE;
              }
            })
        }
        .width('80%')
        .height('80%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Green)
        .gesture(
          TapGesture() // 2. 父组件上注册了点击手势，正常情况下点击在子组件区域时，父组件上的手势优先级低于子组件
            .onAction(() => {
              console.info('Clicked on parent');
              this.increaseJudgeGuard();
            }))
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.singlegesture_Index_Click_title')资源文件中的value值为'点击事件'
    .title($r('app.string.singlegesture_Index_Click_title'))
  }
}
// [End click_event]