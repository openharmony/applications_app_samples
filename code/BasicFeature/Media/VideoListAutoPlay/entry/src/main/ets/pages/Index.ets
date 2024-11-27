/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { VideoListAutoplayComponent } from 'videolistautoplay';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      /**
       * 功能描述：利用onScrollIndex获取List显示区域内中间子组件索引值的能力来判断播放，利用懒加载场景会预加载List显示区域外cachedCount的内容的能力来实现视频连续播放的功能。
       * 参数介绍：无
       */
      VideoListAutoplayComponent()

    }
    .height('100%')
    .width('100%')
  }
}