/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
struct FlexShrink {
  build() {
    //[Start FlexShrink_start]
    Flex({ direction: FlexDirection.Row }) {
      Text('flexShrink(3)')
        .flexShrink(3)
        .width(200)
        .height(100)
        .backgroundColor('#F5DEB3')

      Text('no flexShrink')
        .width(200)
        .height(100)
        .backgroundColor('#D2B48C')

      Text('flexShrink(2)')
        .flexShrink(2)
        .width(200)
        .height(100)
        .backgroundColor('#F5DEB3')
    }.width(400).height(120).padding(10).backgroundColor('#AFEEEE')
    // [End FlexShrink_start]
  }
}