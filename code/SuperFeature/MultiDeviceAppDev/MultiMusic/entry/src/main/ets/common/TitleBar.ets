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

@Entry
@Component
export default struct TitleBar {
  @LocalStorageProp("currentBreakpoint") currentBreakpoint: string = 'md';

  @Builder
  TitleIcon(imageSrc: Resource) {
    Column() {
      Image(imageSrc).height(24).width(24)
    }
    .alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(56)
  }

  build() {
    GridRow({ columns: { sm: 8, md: 16, lg: 24 } }) {
      //title
      GridCol({ span: { sm: 7, md: 6, lg: 15 }, order: { sm: 1, md: 1, lg: 1 } }) {
        Text($r("app.string.recommend"))
          .width('100%')
          .lineHeight(33)
          .height(56)
          .fontSize(24)
          .fontWeight(FontWeight.Medium)
      }

      //SearchComponent
      GridCol({ span: { sm: 7, md: 8, lg: 7 }, order: { sm: 3, md: 2, lg: 2 } }) {
        Search({ placeholder: '搜索...' }).height(40).backgroundColor('#fff').enableKeyboardOnFocus(false)
      }.height(56)

      //icon
      GridCol({ span: { sm: 1, md: 1, lg: 1 }, order: { sm: 2, md: 4, lg: 4 } }) {
        this.TitleIcon($r('app.media.ic_more'))
      }

      //icon
      GridCol({ span: { sm: 1, md: 1, lg: 1 }, order: { sm: 4, md: 3, lg: 3 } }) {
        this.TitleIcon($r('app.media.ic_listener'))
      }
    }
  }
}