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

// [Start router_index]
// Index.ets
import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { DOMAIN, TAG } from '../../common/Common';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State router: string = 'Examples of Router, Navigation, and NavPathStack';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('router to pageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/routerToNavigation/router/PageOne' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                hilog.error(DOMAIN, TAG, 'page ON_SHOWN:' + `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info( DOMAIN, TAG, 'Invoke pushUrl succeeded.');
            })
          })
        // [StartExclude quick_start]
        Text(this.router)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.routerToNavigation_router_text1'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .align(Alignment.Start)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/routerToNavigation/router/Router1' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                hilog.error(DOMAIN, TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN, TAG, 'Invoke pushUrl succeeded.');
            })
          })

        Button($r('app.string.routerToNavigation_router_text2'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .align(Alignment.Start)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/routerToNavigation/router/Router2' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                hilog.error(DOMAIN, TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN, TAG, 'Invoke pushUrl succeeded.');
            })
          })

        Button($r('app.string.routerToNavigation_router_text3'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .align(Alignment.Start)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/routerToNavigation/router/Router3' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                hilog.error(DOMAIN, TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN, TAG, 'Invoke pushUrl succeeded.');
            })
          })

        Button($r('app.string.routerToNavigation_router_text4'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .align(Alignment.Start)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/routerToNavigation/router/Router4' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                hilog.error(DOMAIN, TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN, TAG, 'Invoke pushUrl succeeded.');
            })
          })
        // [EndExclude quick_start]
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End router_index]