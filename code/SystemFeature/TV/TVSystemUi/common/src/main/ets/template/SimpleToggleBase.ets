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
 

import Log from '../default/Log'
import StyleConfiguration, { SimpleToggleBaseStyle } from './common/StyleConfiguration'

const TAG = 'SimpleToggleBase'

@Component
export default struct SimpleToggleBase {
  private mToggleId: string
  @Link mIcon: Resource
  @State mIconStr: string = ''
  private mUseIconStr: boolean = false
  private mAutoIconColor: boolean = false
  @Link mChangeSwitch: boolean
  @Link mLabel: Resource
  private mLabelStr: string | Resource
  private mUseLabelStr: boolean = false
  private mIconOnBG: string | Resource
  private mEditMode: boolean = false
  private mDragMode: boolean = false
  private mClickEvent: Function
  private mLongClickEvent: Function
  @State mIconIsHover: boolean = false
  @State mTextIsHover: boolean = false
  @State style: SimpleToggleBaseStyle = StyleConfiguration.getSimpleToggleBaseStyle()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, mToggleId: ${this.mToggleId}, mLabel: ${JSON.stringify(this.mLabel)},` +
      ` mEditMode: ${this.mEditMode} mDragMode: ${this.mDragMode} `)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Column() {
      Stack() {
        Flex()
          .backgroundColor(this.mChangeSwitch
            ? (this.mIconOnBG ? this.mIconOnBG : this.style.iconOnBG) : this.style.iconOffBG)
          .clip(new Circle({
            width: this.mDragMode ? this.style.dragCircleWidth : this.style.circleWidth,
            height: this.mDragMode ? this.style.dragCircleHeight : this.style.circleHeight
          }))
          .width(this.mDragMode ? this.style.dragCircleWidth : this.style.circleWidth)
          .height(this.mDragMode ? this.style.dragCircleHeight : this.style.circleHeight)
        if (!this.mDragMode) {
          Flex()
            .backgroundColor(this.mIconIsHover ? this.style.hoverColor : this.style.transparentColor)
            .clip(new Circle({ width: this.style.circleWidth, height: this.style.circleHeight }))
            .width(this.style.circleWidth)
            .height(this.style.circleHeight)
        }
        Image(this.mUseIconStr ? this.mIconStr : this.mIcon)
          .size({
            width: this.mDragMode ? this.style.dragIconWidth : this.style.iconWidth,
            height: this.mDragMode ? this.style.dragIconHeight : this.style.iconHeight })
          .objectFit(ImageFit.Contain)
          .fillColor(this.mChangeSwitch ? this.style.iconOnColor : this.style.iconOffColor)
          .onHover((isHover) => {
            this.mIconIsHover = isHover;
          })
      }
      .width(this.mDragMode ? this.style.dragCircleWidth : this.style.circleWidth)
      .height(this.mDragMode ? this.style.dragCircleHeight : this.style.circleHeight)
      .onClick(this.onIconItemClick.bind(this))

      if (!this.mDragMode) {
        Stack() {
          Flex()
            .backgroundColor(this.mTextIsHover ? this.style.hoverColor : this.style.transparentColor)
            .clip(new Rect({
              width: this.style.textHoverWidth,
              height: this.style.textHoverHeight
            }).radius(this.style.textHoverRadius))
            .width(this.style.textHoverWidth)
            .height(this.style.textHoverHeight)
          Text(this.mUseLabelStr ? this.mLabelStr : this.mLabel)
            .fontSize(this.style.titleSize)
            .fontColor(this.style.titleColor)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .onHover((isHover) => {
              this.mTextIsHover = isHover;
            })
        }.margin({top: this.style.componentGap})
      }
    }
    .width('100%')
    .height('100%')
  }

  onIconItemClick(event: ClickEvent) {
    if (this.mDragMode) {
      return
    }
    Log.showDebug(TAG, `onIconItemClick`)
    if (this.mClickEvent) {
      this.mClickEvent()
    }
  }

  onIconItemLongPressGesture(event: GestureEvent) {
    if (this.mEditMode || this.mDragMode) {
      return
    }
    Log.showDebug(TAG, `onIconItemLongPressGesture, event: ${JSON.stringify(event)}`)
    if (this.mLongClickEvent) {
      this.mLongClickEvent()
    }
  }
}
