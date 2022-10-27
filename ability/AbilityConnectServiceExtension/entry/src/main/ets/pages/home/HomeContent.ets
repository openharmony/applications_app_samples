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

import HoursWeather from './HoursWeather'
import IndexHeader from './IndexHeader'
import MultiDayWeather from './MultiDayWeather'
import Style from '../../util/Style'

@Component
export default struct HomeContent {
  private scroller: Scroller = new Scroller()
  @Prop currentWeather: number

  build() {
    Scroll(this.scroller) {
      GridRow({
        columns: { xs: 4, sm: 4, md: 8, lg: 8 },
        gutter: { x: Style.GRID_GUTTER, y: Style.GRID_GUTTER },
        breakpoints: { reference: BreakpointsReference.WindowSize } }) {
        GridCol({ span: { xs: 4, sm: 4, md: 8, lg: 8 }, order: 0 }) {
          IndexHeader({ currentWeather: this.currentWeather })
        }
        GridCol({ span: { xs: 4, sm: 4, md: 8, lg: 8 }, order: 1 }) {
          HoursWeather()
        }
        GridCol({ span: 4, order: { xs: 2, sm: 2, md: 2, lg: 2 } },) {
          MultiDayWeather()
        }
      }
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: Style.NORMAL_PADDING, right: Style.NORMAL_PADDING })
  }
}