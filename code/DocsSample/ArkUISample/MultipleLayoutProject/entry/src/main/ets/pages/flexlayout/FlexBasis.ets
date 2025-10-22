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
struct FlexBasis {
  build() {
    Flex() {
      Text('flexBasis("auto")')
        .flexBasis('auto')
        .height(100)
        .backgroundColor('#F5DEB3')
      Text('flexBasis("auto")'+' width("40%")')
        .width('40%')
        .flexBasis('auto')
        .height(100)
        .backgroundColor('#D2B48C')

      Text('flexBasis(100)')
        .flexBasis(100)
        .height(100)
        .backgroundColor('#F5DEB3')

      Text('flexBasis(100)')
        .flexBasis(100)
        .width(200)
        .height(100)
        .backgroundColor('#D2B48C')
    }.width('90%').height(120).padding(10).backgroundColor('#AFEEEE')
  }
}