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

import { CitySearch } from 'citysearch';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      /**
       * 功能描述：本示例介绍城市选择场景的使用：通过AlphabetIndexer实现首字母快速定位城市的索引条导航
       * 参数介绍：无
       */
      CitySearch()
    }
    .height('100%')
    .width('100%')
  }
}