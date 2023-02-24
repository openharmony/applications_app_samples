/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { CommonItemSlider } from '../../../../common/AttributeModificationTool'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'
import Logger from '../../../../util/Logger'

enum AreaSideName {
  NONE,
  CORNER,
  TOP,
  LEFT,
  RIGHT,
  BOTTOM
}

const BALL_SIZE: number = 24
const BALL_DEFAULT_POS_X: number = 48
const BALL_DEFAULT_POS_Y: number = 48
const STEP_DISTANCE: number = 5
const MOVE_INTERVAL: number = 16 // ms

@Entry
@Component
struct AreaChangeEventSample {
  @State ballPositionX: number = BALL_DEFAULT_POS_X
  @State ballPositionY: number = BALL_DEFAULT_POS_Y
  @State areaCurrentWidthPercent: number = 100
  @State areaCurrentHeightPercent: number = 30
  @State areaChangedInfo: string = ''
  private areaRight: number = 0
  private areaBottom: number = 0
  private motionStartingCheckingTimer: number = 0
  private motionTimer: number = 0
  private xDirection: number = 1 // 1 为正方向，-1 为负方向
  private yDirection: number = 1 // 1 为正方向，-1 为负方向

  onPageShow() {
    this.startMotionControlling()
  }

  onPageHide() {
    clearTimeout(this.motionStartingCheckingTimer)
    clearInterval(this.motionTimer)
  }

  startMotionControlling() {
    clearTimeout(this.motionStartingCheckingTimer)
    this.motionStartingCheckingTimer = setTimeout(() => {
      clearInterval(this.motionTimer)
      this.resetBallMotion()
      this.motionTimer = setInterval(() => {
        this.moveBall()
      }, MOVE_INTERVAL)
    }, 500)
  }

  resetBallMotion() {
    this.ballPositionX = BALL_DEFAULT_POS_X
    this.ballPositionY = BALL_DEFAULT_POS_Y
    this.xDirection = 1
    this.yDirection = 1
  }

  isSideReached(): boolean {
    if ((this.ballPositionX > 0) && (this.ballPositionX < this.areaRight - BALL_SIZE)
    && (this.ballPositionY > 0) && (this.ballPositionY < this.areaBottom - BALL_SIZE)) {
      return false
    }
    return true
  }

  calculateReachedSide(): AreaSideName {
    if (!this.isSideReached()) {
      return AreaSideName.NONE
    }
    if (this.ballPositionX <= 0) {
      if (this.ballPositionY <= 0 || this.ballPositionY >= (this.areaBottom - BALL_SIZE)) {
        // reached the corner
        return AreaSideName.CORNER
      }
      return AreaSideName.LEFT
    }
    if (this.ballPositionX >= (this.areaRight - BALL_SIZE)) {
      if (this.ballPositionY <= 0 || this.ballPositionY >= (this.areaBottom - BALL_SIZE)) {
        // reached the corner
        return AreaSideName.CORNER
      }
      return AreaSideName.RIGHT
    }
    if (this.ballPositionY <= 0) {
      if (this.ballPositionX <= 0 || this.ballPositionX >= (this.areaRight - BALL_SIZE)) {
        // reached the corner
        return AreaSideName.CORNER
      }
      return AreaSideName.TOP
    }
    if (this.ballPositionY >= (this.areaBottom - BALL_SIZE)) {
      if (this.ballPositionX <= 0 || this.ballPositionX >= (this.areaRight - BALL_SIZE)) {
        // reached the corner
        return AreaSideName.CORNER
      }
      return AreaSideName.BOTTOM
    }
    return AreaSideName.NONE
  }

  decideMoveDirection() {
    let reachedSide = this.calculateReachedSide()
    if (reachedSide === AreaSideName.NONE) {
      return
    }
    if (reachedSide === AreaSideName.CORNER) {
      this.xDirection = this.xDirection * -1
      this.yDirection = this.yDirection * -1
      return
    }

    // 再以当前运动方向生成新的方向
    if (reachedSide === AreaSideName.LEFT || reachedSide === AreaSideName.RIGHT) {
      this.xDirection = this.xDirection * -1
    } else {
      this.yDirection = this.yDirection * -1
    }
  }

  moveBall() {
    if (this.ballPositionX >= this.areaRight || this.ballPositionY >= this.areaBottom) {
      // reset
      this.resetBallMotion()
      return
    }
    this.decideMoveDirection()
    this.ballPositionX = this.ballPositionX + (STEP_DISTANCE * this.xDirection)
    this.ballPositionY = this.ballPositionY + (STEP_DISTANCE * this.yDirection)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.component_area_change_event') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.component_area_change_action_tips') })
          Column() {
            // slider for controlling the area width
            CommonItemSlider({
              changeValue: $areaCurrentWidthPercent,
              min: 30,
              max: 100,
              name: $r('app.string.size_width')
            })
            // slider for controlling the area height
            CommonItemSlider({
              changeValue: $areaCurrentHeightPercent,
              min: 30,
              max: 100,
              name: $r('app.string.size_height')
            })
          }

          Column() {
            Row() {
              Button({ type: ButtonType.Circle, stateEffect: false })
                .width(BALL_SIZE)
                .height(BALL_SIZE)
                .backgroundColor(0x317aff)
                .position({ x: this.ballPositionX, y: this.ballPositionY })
            }
            .height(`${this.areaCurrentHeightPercent.toString()}%`)
            .width(`${this.areaCurrentWidthPercent.toString()}%`)
            .backgroundColor($r('app.color.background_shallow_grey'))
            .onAreaChange((oldValue: Area, newValue: Area) => {
              this.areaRight = newValue.width as number
              this.areaBottom = newValue.height as number
              Logger.error(`ROW area: ${JSON.stringify(newValue)}`)
              this.areaChangedInfo
              = 'Area Info:\n' + '  globalPos:\n    x: ' + newValue.globalPosition.x + '\n    y: '
              + newValue.globalPosition.y + '\n' + '  width: ' + newValue.width + '\n  height: ' + newValue.height
              this.startMotionControlling()
            })
          }
          .padding(12)
          .borderRadius(24)
          .backgroundColor(Color.White)

          // touch location information
          Text(this.areaChangedInfo)
            .fontSize(18)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 18, top: 30 })
            .margin({ bottom: 70 })
        }
        .padding({ left: 12, right: 12 })
        .constraintSize({ minHeight: '100%' })
      }
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
