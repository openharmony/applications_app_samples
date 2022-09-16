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

@Entry
@Component
export default struct Header {
  @State needWrap: boolean = true

  build() {
    GridRow() {
      GridCol({ span: { sm: 12, md: 6, lg: 7 } }) {
        Row() {
          Text($r('app.string.recommended')).fontSize(24)
          Blank()
          Image($r('app.media.ic_public_more'))
            .width(32)
            .height(32)
            .objectFit(ImageFit.Contain)
            .visibility(this.needWrap ? Visibility.Visible : Visibility.None)
        }
        .width('100%')
        .height(40)
        .alignItems(VerticalAlign.Center)
      }

      GridCol({ span: { sm: 12, md: 6, lg: 5 } }) {
        Flex({ alignItems: ItemAlign.Center }) {
          Search({ placeholder: '猜您喜欢: 万水千山' })
            .placeholderFont({ size: 16 })
            .margin({ top: 4, bottom: 4 })
            .flexGrow(1)
            .flexShrink(1)
          Image($r('app.media.audio_fm'))
            .width(32)
            .height(32)
            .objectFit(ImageFit.Contain)
            .flexShrink(0)
            .margin({ left: 12 })
          Image($r('app.media.ic_public_more'))
            .width(32)
            .height(32)
            .objectFit(ImageFit.Contain)
            .flexShrink(0)
            .margin({ left: 12 })
            .visibility(this.needWrap ? Visibility.None : Visibility.Visible)
        }
      }
    }.onBreakpointChange((breakpoint: string) => {
      if (breakpoint === 'sm') {
        this.needWrap = true
      } else {
        this.needWrap = false
      }
    })
    .padding({ left: 12, right: 12 })
  }
}