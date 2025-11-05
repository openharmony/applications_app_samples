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

import { router } from '@kit.ArkUI';
interface Ary {
  path:string,
  name:string
}
@Entry
@Component
struct Index {
  ary:Ary[]=[
    {
      name:'PageOne',
      path:'pages/PageOneDoubleSYN'
    },
    {
      name:'PageTwo',
      path:'pages/PageTwoSigleSYN'
    },
    {
      name:'PageThree',
      path:'pages/PageTwoWaySYN'
    },
    {
      name:'PageFour',
      path:'pages/PageFourStateVariableSYN'
    },
    {
      name:'PageFive',
      path:'pages/PageFiveShare'
    },
    {
      name:'PageSix',
      path:'pages/PageSixLocalStorage'
    },
    {
      name:'PageSeven',
      path:'pages/PageSixLocalStorageA'
    },
    {
      name:'PageEight',
      path:'pages/PageSixLocalStorageB'
    },
    {
      name:'PageNine',
      path:'pages/PageMyNavigation'
    },
    {
      name:'PageTen',
      path:'pages/PageLocalStorageLink'
    },
    {
      name:'PageEleven',
      path:'pages/PageFiveShare2'
    },
    {
      name:'PageTwelve',
      path:'pages/LocalSetSample'
    },
    {
      name:'PageThirteen',
      path:'pages/LocalMapSample'
    },
    {
      name:'PageFourteen',
      path:'pages/LocalDateSample'
    },
    {
      name:'PageFifteen',
      path:'pages/ChangeLocalSetSample'
    },

  ]
  build() {
    Scroll() {
      Column({ space: 2 }) {
        ForEach(this.ary,(item:Ary)=>{
          Button(item.name)
            .onClick(() => this.getUIContext().getRouter().pushUrl({ url: item.path }))
        },(item:Ary)=>item.name)
      }
      .width('100%')
    }
  }
}
