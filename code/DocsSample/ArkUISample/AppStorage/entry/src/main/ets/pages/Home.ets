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
  path: string,
  name: string
}

@Entry
@Component
struct Home {
  ary: Ary[] = [
    {
      name: '从UI内部使用AppStorage',
      path: 'pages/PageTwo'
    },
    {
      name: 'AppStorage支持联合类型',
      path: 'pages/PageThree'
    },
    {
      name: 'AppStorage支持Array类型变量',
      path: 'pages/PageOne'
    },
    {
      name: 'AppStorage支持Date类型变量',
      path: 'pages/PageFour'
    },
    {
      name: 'AppStorage支持Map类型变量',
      path: 'pages/PageFive'
    },
    {
      name: 'AppStorage支持Set类型变量',
      path: 'pages/PageSix'
    },
    {
      name: '不建议借助@StorageLink的双向同步机制实现事件通知',
      path: 'pages/ViewData'
    },
    {
      name: '使用emit订阅事件并接收事件回调',
      path: 'pages/PageEight'
    },
    {
      name: '将通知事件简化成三元表达式',
      path: 'pages/Gallery'
    },
    {
      name: '@StorageProp和AppStorage接口配合使用',
      path: 'pages/PageTen'
    },
    {
      name: '多页面共享AppStorage',
      path: 'pages/Index'
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
