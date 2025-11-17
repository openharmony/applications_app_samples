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

import { router, Router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  aboutToAppear() {
    try {
      let router1 = this.getUIContext().getRouter();
      AppStorage.setOrCreate<Router>('router', router1);
    } catch (e) {
      hilog.info(0xF811, 'testTag', '%{public}s', 'e' + e);
    }
  }

  build() {
    Column({ space: 5 }) {
      Row({ space: 5 }) {
        Button('ArkWebPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/ArkWebPage',
            }
            routerInstance.pushUrl(options)
          })
        Button('BuilderProxyNode01')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/BuilderProxyNode01',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('BuilderProxyNode02')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/BuilderProxyNode02',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('EnvironmentCallbackPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/EnvironmentCallbackPage',
            }
            routerInstance.pushUrl(options)
          })
        Button('FrameNode')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/FrameNode',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('InheritFreezeOptionsPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/InheritFreezeOptionsPage',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('inheritFreezeRouterPage1')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/inheritFreezeRouterPage1',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('IsDisposedPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/IsDisposedPage',
            }
            routerInstance.pushUrl(options)
          })
        Button('LocalStoragePage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/LocalStoragePage',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('NavigationPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/NavigationPage',
            }
            routerInstance.pushUrl(options)
          })
        Button('PostTouchEvent')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/PostTouchEvent',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('RenderNode')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/RenderNode',
            }
            routerInstance.pushUrl(options)
          })
        Button('RepeatPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/RepeatPage',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('RepeatTabPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/RepeatTabPage',
            }
            routerInstance.pushUrl(options)
          })
        Button('ReusablePage01')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/ReusablePage01',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('ReusablePage02')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/ReusablePage02',
            }
            routerInstance.pushUrl(options)
          })
        Button('RouterPage1')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/RouterPage1',
            }
            routerInstance.pushUrl(options)
          })
      }

      Row({ space: 5 }) {
        Button('TabContentPage')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/TabContentPage',
            }
            routerInstance.pushUrl(options)
          })
        Button('WrappedBuilder')
          .onClick(() => {
            const routerInstance = AppStorage.get<Router>('router') as Router
            let options: router.RouterOptions = {
              url: 'pages/WrappedBuilder',
            }
            routerInstance.pushUrl(options)
          })
      }
    }
    .width('100%')
    .height('100%')
  }
}