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

import { router } from '@kit.ArkUI'

interface Ary {
  path: string,
  name: string
}

@Entry
@Component
struct Index {
  ary: Ary[] = [
    {
      name: 'ReusableForCustomComponents',
      path: 'pages/ReusableForCustomComponents'
    },
    {
      name: 'ReusableIncorrectSample',
      path: 'pages/ReusableIncorrectSample'
    },
    {
      name: 'ReusableCorrectSample',
      path: 'pages/ReusableCorrectSample'
    },
    {
      name: 'ComponentContentNotSupportReusable',
      path: 'pages/ComponentContentNotSupportReusable'
    },
    {
      name: 'DynamicLayoutUpdate',
      path: 'pages/DynamicLayoutUpdate'
    },
    {
      name: 'ListScrollingWithLazyForEach',
      path: 'pages/ListScrollingWithLazyForEach'
    },
    {
      name: 'ListScrollingWithIfStatements',
      path: 'pages/ListScrollingWithIfStatements'
    },
    {
      name: 'ListScrollingWithForEach',
      path: 'pages/ListScrollingWithForEach'
    },
    {
      name: 'ReusableForGridUsageScenario',
      path: 'pages/ReusableForGridUsageScenario'
    },
    {
      name: 'ReusableForWaterFlowUsageScenario',
      path: 'pages/ReusableForWaterFlowUsageScenario'
    },
    {
      name: 'ReusableForSwiperUsageScenario',
      path: 'pages/ReusableForSwiperUsageScenario'
    },
    {
      name: 'ReusableForListItemGroupUsageScenario',
      path: 'pages/ReusableForListItemGroupUsageScenario'
    },
    {
      name: 'ReusableForLimitedVariation',
      path: 'pages/ReusableForLimitedVariation'
    },
    {
      name: 'ReusableForComposite',
      path: 'pages/ReusableForComposite'
    },
    {
      name: 'ReusableForReuseId',
      path: 'pages/ReusableForReuseId'
    },
    {
      name: 'ReusableForIncorrectReuseId',
      path: 'pages/ReusableForIncorrectReuseId'
    }
  ];

  build() {
    Scroll() {
      Column({ space: 10 }) {
        ForEach(this.ary, (item: Ary) => {
          Button(item.name)
            .onClick(() => router.pushUrl({ url: item.path }))
        }, (item: Ary) => item.name)
      }
      .width(300)
    }
  }
}
