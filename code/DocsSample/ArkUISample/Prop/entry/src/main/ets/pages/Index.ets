/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
      name: 'PageOne',
      path: 'pages/PageOne'
    },
    {
      name: 'PageTwo',
      path: 'pages/PageTwo'
    },
    {
      name: 'PageThree',
      path: 'pages/PageThree'
    },
    {
      name: 'PageFour',
      path: 'pages/PageFour'
    },
    {
      name: 'PageFive',
      path: 'pages/PageFive'
    },
    {
      name: 'PageSix',
      path: 'pages/PageSix'
    },
    {
      name: 'PageSeven',
      path: 'pages/PageSeven'
    },
    {
      name: 'PageEight',
      path: 'pages/PageEight'
    },
    {
      name: 'PageNine',
      path: 'pages/PageNine'
    },
    {
      name: 'PageTen',
      path: 'pages/PageTen'
    },
    {
      name: 'PageEleven',
      path: 'pages/PageEleven'
    },
    {
      name: 'PageTwelve',
      path: 'pages/PageTwelve'
    },
    {
      name: 'PageThirteen',
      path: 'pages/PageThirteen'
    },
    {
      name: 'PageFourteen',
      path: 'pages/PageFourteen'
    },
    {
      name: 'PageFifteen',
      path: 'pages/PageFifteen'
    },
    {
      name: 'PageSixteen',
      path: 'pages/PageSixteen'
    },
    {
      name: 'PageSeventeen',
      path: 'pages/PageSeventeen'
    },
    {
      name: 'PageEighteen',
      path: 'pages/PageEighteen'
    },
    {
      name: 'PageNineteen',
      path: 'pages/PageNineteen'
    },
    {
      name: 'PageTwenty',
      path: 'pages/PageTwenty'
    },
  ]

  build() {
    Scroll() {
      Column({ space: 2 }) {
        ForEach(this.ary, (item: Ary) => {
          Button(item.name)
            .onClick(() => this.getUIContext().getRouter().pushUrl({ url: item.path }))
        }, (item: Ary) => item.name)
      }
      .width('100%')
    }
  }
}
