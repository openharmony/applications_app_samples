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

@Entry
@Component
struct RepeatSample {
  @State isWidescreen: boolean = false
  @State currentBreakpoint: string = 'sm'
  private listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(width>1200)')
  onWidthChange = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.isWidescreen = true
    } else {
      this.isWidescreen = false
    }
  }

  aboutToAppear() {
    this.listener.on('change', this.onWidthChange)
  }

  aboutToDisappear() {
    this.listener.off('change', this.onWidthChange)
  }

  build() {
    Row() {
      Scroll() {
        GridRow() {
          ForEach([0, 1, 2, 3, 4, 5, 6, 7], () => {
            GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
              Column() {
                RepeatItemContent()
              }
              .padding({ left: 10, right: 10 })
            }
          })
        }
        .onBreakpointChange((breakpoint: string) => {
          this.currentBreakpoint = breakpoint
        })
      }
      .height(this.currentBreakpoint === 'sm' ? 320 : '100%')
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: 30, right: 30 })
  }
}

@Component
struct RepeatItemContent {
  build() {
    Flex() {
      Row() {
      }.width(43)
      .height(43)
      .borderRadius(12)
      .backgroundColor('#E4E6E8')

      Column() {
        Row() {
        }
        .height(10)
        .width('80%')
        .backgroundColor('#E4E6E8')

        Row() {
        }
        .height(10)
        .width('50%')
        .backgroundColor('#E4E6E8')
      }
      .flexGrow(1)
      .height('100%')
      .margin({ left: 13 })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .padding({ top: 13, bottom: 13, left: 13, right: 37 })
    .height(70)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 12 })
    .borderRadius(24)
  }
}
