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

@Component
export default struct IndexHeader {
  @Prop currentBreakpoint: string
  controller: SearchController = new SearchController()

  @Builder searchBar() {
    Stack() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        TextArea({ placeholder: $r('app.string.search') })
          .placeholderColor("#FF000000")
          .placeholderFont({ size: 16, weight: 400 })
          .textAlign(TextAlign.Start)
          .caretColor("#FF000000")
          .width('100%')
          .height(40)
          .fontWeight(400)
          .padding({ top: 9, bottom: 9 })
          .fontSize(16)
          .backgroundColor(Color.White)
      }.width('100%').height('100%')

      Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_public_search'))
          .width(16)
          .height(16)
          .margin({ right: 20 })
      }.width('100%').height('100%')
    }.height(56).width('100%')
  }

  @Builder titleBar() {
    Row() {
      Text($r('app.string.tabBar1'))
        .width(48)
        .height(32)
        .fontSize(24)
        .fontWeight(500)
        .fontColor('#18181A')
        .textAlign(TextAlign.Start)
    }
    .height(56).width('100%')
  }

  build() {
    GridRow() {
      GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 8 } }) {
        this.titleBar()
      }

      GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 4 } }) {
        this.searchBar()
      }
    }
    .width('100%')
    .height(this.currentBreakpoint === "lg" ? 56 : 112)
    .padding({ left: $r('app.float.app_safe_margin'), right: $r('app.float.app_safe_margin') })
  }
}