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
struct FlexAlignStart {
  build() {
    Flex({ justifyContent: FlexAlign.Start }) {
      Text('1').width('20%').height(50).backgroundColor('#F5DEB3')
      Text('2').width('20%').height(50).backgroundColor('#D2B48C')
      Text('3').width('20%').height(50).backgroundColor('#F5DEB3')
    }
    .width('90%')
    .padding({ top: 10, bottom: 10 })
    .backgroundColor('#AFEEEE')
  }
}