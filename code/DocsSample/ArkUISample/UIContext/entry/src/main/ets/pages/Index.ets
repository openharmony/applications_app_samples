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

const DOMAIN = 0xF811;

@Entry
@Component
struct Index {
  aboutToAppear() {
    try {
      let router1 = this.getUIContext().getRouter();
      AppStorage.setOrCreate<Router>('router', router1);
    } catch (e) {
      hilog.info(DOMAIN, 'e', e);
    }
  }

  build() {
    Column({ space: 10 }) {
      Button('ContextPage').onClick(() => {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let options: router.RouterOptions = {
          url: 'pages/ContextPage',
        }
        routerInstance.pushUrl(options);
      })
      Button('CalendarPickerDialogPage').onClick(() => {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let options: router.RouterOptions = {
          url: 'pages/CalendarPickerDialogPage',
        }
        routerInstance.pushUrl(options);
      })
      Button('LocalStoragePage').onClick(() => {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let options: router.RouterOptions = {
          url: 'pages/LocalStoragePage',
        }
        routerInstance.pushUrl(options);
      })
      Button('NewGlobal').onClick(() => {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let options: router.RouterOptions = {
          url: 'pages/NewGlobal',
        }
        routerInstance.pushUrl(options);
      })
      Button('VpPage').onClick(() => {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let options: router.RouterOptions = {
          url: 'pages/VpPage',
        }
        routerInstance.pushUrl(options);
      })
      Button('WindowTestPage').onClick(() => {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let options: router.RouterOptions = {
          url: 'pages/WindowTestPage',
        }
        routerInstance.pushUrl(options);
      })
    }
    .height('100%')
    .width('100%')
  }
}