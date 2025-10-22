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
struct FlexAlignSelf {
  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) { // 容器组件设置子元素居中
      Text('alignSelf Start').width('25%').height(80)
        .alignSelf(ItemAlign.Start)
        .backgroundColor('#F5DEB3')
      Text('alignSelf Baseline')
        .alignSelf(ItemAlign.Baseline)
        .width('25%')
        .height(80)
        .backgroundColor('#D2B48C')
      Text('alignSelf Baseline').width('25%').height(100)
        .backgroundColor('#F5DEB3')
        .alignSelf(ItemAlign.Baseline)
      Text('no alignSelf').width('25%').height(100)
        .backgroundColor('#D2B48C')
      Text('no alignSelf').width('25%').height(100)
        .backgroundColor('#F5DEB3')

    }.width('90%').height(220).backgroundColor('#AFEEEE')
  }
}