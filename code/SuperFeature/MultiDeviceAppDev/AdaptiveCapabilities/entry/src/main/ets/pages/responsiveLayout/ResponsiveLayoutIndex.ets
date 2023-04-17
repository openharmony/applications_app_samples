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

import { DirectoryItem, DirectoryList } from '../../common/DirectoryList'

@Entry
@Component
struct ResponsiveLayoutIndex {
  private responsiveLayout: DirectoryItem[] = [
    { title: $r('app.string.breakpoint'), uri: 'pages/responsiveLayout/breakpoint/BreakpointSample' },
    { title: $r('app.string.media_query'), uri: 'pages/responsiveLayout/mediaQuery/MediaQuerySample' },
    { title: $r('app.string.grid_layout'), uri: 'pages/gridRow/GridRowLayoutIndex' }
  ]

  build() {
    Column() {
      DirectoryList({ title: $r('app.string.responsive_layout'), directory: this.responsiveLayout })
    }
  }
}