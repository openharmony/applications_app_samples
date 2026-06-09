/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
struct SubWindow {
  build() {
    Column({ space: 12 }) {
      Text('Shadowed Window')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182431')

      Text('A soft shadow is applied to the window edge.')
        .fontSize(16)
        .fontColor('#5A6677')
    }
    .width('100%')
    .height('100%')
    .padding(32)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFFFF')
  }
}
