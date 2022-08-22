/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import mediaquery from '@ohos.mediaquery'

const TitleColor = {
  NORMAL: "#999",
  SELECTED: "#0A59F7"
}

@Component
export default struct TabBarItem {
  @Prop currentBreakpoint: string
  @Prop isSelected: boolean
  private icon: string | Resource
  private iconSelected: string | Resource
  private title: string | Resource

  private getIcon() {
    return this.isSelected ? this.iconSelected : this.icon
  }

  private getFontColor() {
    return this.isSelected ? TitleColor.SELECTED : TitleColor.NORMAL
  }

  build() {
    Flex({ direction: this.currentBreakpoint === 'md' ? FlexDirection.Row : FlexDirection.Column,
      justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image(this.getIcon())
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
      Row() {
        Text(this.title)
          .fontColor(this.getFontColor())
          .height(14)
          .fontSize(10)
          .textAlign(TextAlign.Center)
          .fontWeight(500)
      }
      .width(65.45)
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
  }
}