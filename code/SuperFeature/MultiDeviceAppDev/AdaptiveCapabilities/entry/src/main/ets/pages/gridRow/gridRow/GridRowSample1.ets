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
@Preview
@Component
struct GridRowSample1 {
  @State currentBreakpoint: string = 'md'

  build() {
    GridRow({ breakpoints: { value: ['600vp', '700vp', '800vp', '900vp', '1000vp'] } }) {
      GridCol({
        span: {
          xs: 12,
          sm: 12,
          md: 12,
          lg: 12,
          xl: 12,
          xxl: 12
        }
      }) {
        Row() {
          Text(this.currentBreakpoint)
            .fontSize(100)
            .fontWeight(FontWeight.Bolder)
        }
        .width('100%')
        .height('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
    .onBreakpointChange((breakPoint: string) => {
      this.currentBreakpoint = breakPoint
    })
  }
}