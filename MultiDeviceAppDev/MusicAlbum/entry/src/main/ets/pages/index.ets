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

import PlayListHeader from '../Component/PlayListHeader'
import MusicBar from '../Component/MusicBar'
import MusicContent from '../Component/MusicContent'

@Entry
@Component
struct Index {
  @Provide('font') fontSize: number = 0
  @Provide('breakPoint') currentBreakPoint: string = 'sm'
  @Provide('margin') listCoverMargin: number = 0
  @Provide('height') coverImgHeight: number = 0

  build() {
    Column() {
      PlayListHeader().flexShrink(0)
      MusicContent()
        .flexGrow(1)
        .flexShrink(1)
      MusicBar().flexShrink(0)
    }
    .width('100%')
  }
}