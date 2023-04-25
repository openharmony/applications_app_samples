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
struct AtomicLayoutCapabilityIndex {
  private atomicLayoutCapability: DirectoryItem[] = [
    {
      title: $r('app.string.flex_capability_first'),
      uri: 'pages/atomicLayoutCapability/flexibleCapability/FlexibleCapability1',
      id: 'FlexibleCapability1'
    },
    {
      title: $r('app.string.flex_capability_second'),
      uri: 'pages/atomicLayoutCapability/flexibleCapability/FlexibleCapability2',
      id: 'FlexibleCapability2'
    },
    { title: $r('app.string.scaling_capability'),
      uri: 'pages/atomicLayoutCapability/scaleCapability/ScaleCapability',
      id: 'ScaleCapability'
    },
    {
      title: $r('app.string.hidden_capability'),
      uri: 'pages/atomicLayoutCapability/hiddenCapability/HiddenCapability',
      id: 'HiddenCapability'
    },
    { title: $r('app.string.wrap_capability'),
      uri: 'pages/atomicLayoutCapability/wrapCapability/WrapCapability',
      id: 'WrapCapability'
    },
    {
      title: $r('app.string.equally_capability'),
      uri: 'pages/atomicLayoutCapability/equipartitionCapability/EquipartitionCapability',
      id: 'EquipartitionCapability'
    },
    {
      title: $r('app.string.percentage_capability'),
      uri: 'pages/atomicLayoutCapability/proportionCapability/ProportionCapability',
      id: 'ProportionCapability'
    },
    {
      title: $r('app.string.extension_capability_first'),
      uri: 'pages/atomicLayoutCapability/extensionCapability/ExtensionCapability1',
      id: 'ExtensionCapability1'
    },
    {
      title: $r('app.string.extension_capability_second'),
      uri: 'pages/atomicLayoutCapability/extensionCapability/ExtensionCapability2',
      id: 'ExtensionCapability2'
    }
  ]

  build() {
    Column() {
      DirectoryList({ title: $r('app.string.atomic_capability'), directory: this.atomicLayoutCapability })
    }
  }
}