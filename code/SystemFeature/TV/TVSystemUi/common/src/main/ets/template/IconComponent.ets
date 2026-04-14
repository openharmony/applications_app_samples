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
import StyleConfiguration, { IconComponentStyle } from './common/StyleConfiguration'

const TAG = 'iconComponent'

@Component
export default struct iconComponent {
  @State iconOff: any = ''
  @State iconOn: any = ''
  @Prop iconOffStr: string
  @Prop iconOnStr: string
  private useIconStr = false
  @State mIconIsHover: boolean = false
  @Link changeSwitch: boolean
  @State style: IconComponentStyle = StyleConfiguration.getIconComponentStyle()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, ${this.changeSwitch} ${JSON.stringify(this.iconOff)}` +
      ` ${JSON.stringify(this.iconOn)} , useIconStr: ${this.useIconStr}`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Stack() {
      Flex()
        .backgroundColor(this.changeSwitch ? this.style.iconOnBG : this.style.iconOffBG)
        .clip(new Circle({ width: this.style.circleWidth, height: this.style.circleHeight }))
        .width(this.style.circleWidth)
        .height(this.style.circleHeight)
      Flex()
        .backgroundColor(this.mIconIsHover ? this.style.hoverColor : this.style.transparentColor)
        .clip(new Circle({ width: this.style.circleWidth, height: this.style.circleHeight }))
        .width(this.style.circleWidth)
        .height(this.style.circleHeight)
      Image(this.changeSwitch == false
        ? (this.useIconStr ? this.iconOffStr : this.iconOff)
        : (this.useIconStr ? this.iconOnStr : this.iconOn))
        .size({ width: this.style.iconWidth, height: this.style.iconHeight })
        .objectFit(ImageFit.Contain)
        .fillColor(this.changeSwitch ? this.style.iconOnColor : this.style.iconOffColor)
        .onHover((isHover) => {
          this.mIconIsHover = isHover;
        })
    }
    .width(this.style.circleWidth)
    .height(this.style.circleHeight)
  }
}
