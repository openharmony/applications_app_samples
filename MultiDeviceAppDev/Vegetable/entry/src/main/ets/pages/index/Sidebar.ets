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

@Preview
@Component
export struct Sidebar {
  @Prop sidebarCurrBp: string
  @State clickFontColor: ResourceColor = Color.Black

  build() {
    Column() {
      Text('External links')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .fontColor(this.clickFontColor)
        .onClick(() => {
          this.clickFontColor = Color.Red
        })
      Text('Cook vegetables')
        .width('100%')
        .textAlign(TextAlign.Start)
        .decoration({ type: TextDecorationType.Underline })
      Text('Pollution-free vegetables')
        .width('100%')
        .textAlign(TextAlign.Start)
        .decoration({ type: TextDecorationType.Underline })
      Text('Distribution of vegetables')
        .width('100%')
        .textAlign(TextAlign.Start)
        .decoration({ type: TextDecorationType.Underline })
    }.backgroundColor('#4d3b9900').height('100%')
    .justifyContent((this.sidebarCurrBp !== 'lg') ? FlexAlign.Center : FlexAlign.Start)
  }
}