/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Log from '../default/Log';
import StyleConfiguration, { IconTitleBaseStyle } from './common/StyleConfiguration'
import iconComponent from './iconComponent'

const TAG = 'iconTitleBase'

@Component
export default struct iconBaseComponent {
  private iconOn: any
  private iconOff: any
  @State iconOffStr: string = ''
  @State iconOnStr: string = ''
  @Link mTitle: Resource
  @State mTitleStr: string = ''
  private useIconStr = false
  private useTitleStr = false
  private mClickEvent: Function
  private mLongClickEvent: Function
  @State mTextIsHover: boolean = false
  @Link changeSwitch: boolean
  @State style: IconTitleBaseStyle = StyleConfiguration.getIconTitleBaseStyle()

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Row() {
      Row() {
        iconComponent({
          useIconStr: this.useIconStr,
          iconOff: this.iconOff,
          iconOn: this.iconOn,
          iconOffStr: this.iconOffStr,
          iconOnStr: this.iconOnStr,
          changeSwitch: $changeSwitch,
        })
      }
      .height('100%')
      .margin({left: this.style.marginLeft, right: this.style.componentGap})
      .onClick(() => {
        Log.showDebug(TAG, `start clickEvent ${this.changeSwitch}`);
        if (this.mClickEvent) {
          this.mClickEvent()
        }
        Log.showDebug(TAG, `end clickEvent ${this.changeSwitch}`);
      })

      Row() {
        Text(this.useTitleStr ? this.mTitleStr : this.mTitle)
          .fontSize(this.style.titleSize)
          .fontColor(this.style.titleColor)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .margin({left: this.style.textMargin, right: this.style.textMargin})
          .onHover((isHover) => {
            this.mTextIsHover = isHover;
          })
      }
      .width(this.style.textHoverWidth)
      .height(this.style.textHoverHeight)
      .margin({right: this.style.marginRight})
      .backgroundColor(this.mTextIsHover ? this.style.hoverColor : this.style.transparentColor)
      .borderRadius(this.style.textHoverRadius)
      .clip(true)
    }
    .borderRadius(this.style.borderRadius)
    .clip(true)
    .backgroundColor(this.style.backgroundColor)
    .height('100%')
    .width('100%')
  }
}