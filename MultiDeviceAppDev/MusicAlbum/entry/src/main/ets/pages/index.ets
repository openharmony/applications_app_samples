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
  // 歌单封面margin
  @Provide('margin') listCoverMargin: number = 0
  // 歌单图片高度
  @Provide('height') coverImgHeight: number = 0

  build() {
    Column() {
      // 头部
      PlayListHeader()
      // 歌单
      MusicContent()
        .flexGrow(1)
        .flexShrink(1)
      // 播放器
      MusicBar()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}