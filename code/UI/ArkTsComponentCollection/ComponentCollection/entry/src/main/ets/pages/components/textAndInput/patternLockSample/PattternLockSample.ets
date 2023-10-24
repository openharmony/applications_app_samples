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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { PatternLockControlPanel } from './ChangePanel'

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .padding(12)
  .borderRadius(16)
  .width('100%')
}

@Entry
@Component
struct PattternLockSample {
  @State passwords: Number[] = []
  @State message: string = 'please input password!'
  @State sideLength: number = 200
  @State circleRadius: number = 9
  @State pathStrokeWidth: number = 18
  @State activeColor: Color = Color.Blue
  @State selectedColor: Color = Color.Blue
  @State pathColor: Color = Color.Blue
  @State regularColor: Color = Color.Blue
  private patternLockController: PatternLockController = new PatternLockController()

  build() {
    Column() {
      TitleBar({ title: $r('app.string.patternlock_title') })
      Column() {
        Text(this.message).textAlign(TextAlign.Center).margin(20).fontSize(20)
        PatternLock(this.patternLockController)
          .sideLength(this.sideLength)
          .circleRadius(this.circleRadius)
          .pathStrokeWidth(this.pathStrokeWidth)
          .activeColor(this.activeColor)
          .selectedColor(this.selectedColor)
          .pathColor(this.pathColor)
          .backgroundColor('#F5F5F5')
          .regularColor(this.regularColor)
          .autoReset(true)
          .onPatternComplete((input: Array<number>) => {
            // 输入的密码长度小于5时，提示重新输入
            if (input === null || input === undefined || input.length < 5) {
              this.message = 'The password length needs to be greater than 5, please enter again.'
              return
            }
            // 判断密码长度是否大于0
            if (this.passwords.length > 0) {
              // 判断两次输入的密码是否相同，相同则提示密码设置成功，否则提示重新输入
              if (this.passwords.toString() === input.toString()) {
                this.passwords = input
                this.message = 'Set password successfully: ' + this.passwords.toString()
              } else {
                this.message = 'Inconsistent passwords, please enter again.'
              }
            } else {
              // 提示第二次输入密码
              this.passwords = input
              this.message = "Please enter again."
            }
          })
        Button('Reset PatternLock').margin(30).onClick(() => {
          // 重置密码锁
          this.patternLockController.reset()
          this.passwords = []
          this.message = 'Please input password'
        })
      }.cardStyle()
      .height('55%')
      IntroductionTitle({ introduction: $r('app.string.patternlock_change') })
      Column() {
        Scroll() {
          Column() {
            PatternLockControlPanel({
              sideLength: $sideLength,
              pathStrokeWidth: $pathStrokeWidth,
              circleRadius: $circleRadius,
              activeColor: $activeColor,
              selectedColor: $selectedColor,
              regularColor: $regularColor,
              pathColor: $pathColor
            })
          }
        }
      }.id('patternLock_scroll_001')
      .cardStyle()
      .layoutWeight(1)
      .margin({bottom:8})
    }.justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
  }
}