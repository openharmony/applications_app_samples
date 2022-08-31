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

const TitleColor = {
  NORMAL: '#999',
  SELECTED: '#0A59F7'
}

@Component
export default struct TabBarItem {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'md'
  @Prop currentIndex: number
  private index: number
  private icon: string | Resource
  private iconSelected: string | Resource
  private title: string | Resource

  private getIcon() {
    return this.currentIndex === this.index ? this.iconSelected : this.icon
  }

  private getFontColor() {
    return this.currentIndex === this.index ? TitleColor.SELECTED : TitleColor.NORMAL
  }

  build() {
    if (this.currentBreakpoint === 'md') {
      Row() {
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
      .width(65.45)
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    } else {
      Column() {
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
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }
}