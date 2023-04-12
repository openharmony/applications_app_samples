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
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'md'

  @Builder searchBar() {
    Stack({alignContent: Alignment.End}) {
      TextInput({ placeholder: $r('app.string.search') })
        .placeholderColor('#FF000000')
        .placeholderFont({ size: 16, weight: 400 })
        .textAlign(TextAlign.Start)
        .caretColor('#FF000000')
        .width('100%')
        .height(40)
        .fontWeight(400)
        .padding({ top: 9, bottom: 9 })
        .fontSize(16)
        .backgroundColor(Color.White)

      Image($r('app.media.ic_public_search'))
        .width(16)
        .height(16)
        .margin({ right: 20 })
    }.height(56).width('100%')
  }

  @Builder titleBar() {
    Text($r('app.string.tabBar1'))
      .fontSize(24)
      .fontWeight(500)
      .fontColor('#18181A')
      .textAlign(TextAlign.Start)
      .height(56)
      .width('100%')
  }

  build() {
    GridRow() {
      GridCol({ span: { xs: 12, lg: 8 } }) {
        this.titleBar()
      }
      GridCol({ span: { xs: 12, lg: 4 } }) {
        this.searchBar()
      }
    }
    .width('100%')
    .height(this.currentBreakpoint === 'lg' ? 56 : 112)
    .padding({ left: 12, right: 12 })
  }
}