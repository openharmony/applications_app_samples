/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import Logger from '../utils/Logger';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 20 }) {
      Button('CustomDraw')
        .id('CustomDraw')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 200, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'pages/CustomDrawDisplaySync' // 目标url
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              Logger.error(`Invoke replaceUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            Logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('50%')
        .height(40)
        .shadow(ShadowStyle.OUTER_DEFAULT_LG)

      Button('PropertyAnimation')
        .id('PropertyAnimation')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'pages/PropertyAnimationDisplaySync' // 目标url
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              Logger.error(`Invoke replaceUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            Logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('50%')
        .height(40)
        .shadow(ShadowStyle.OUTER_DEFAULT_LG)

      Button('XComponent')
        .id('XComponent')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'pages/XComponentDisplaySync' // 目标url
          }, router.RouterMode.Single, (err) => {
            if (err) {
              Logger.error(`Invoke replaceUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            Logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('50%')
        .height(40)
        .shadow(ShadowStyle.OUTER_DEFAULT_LG)

      Button('Animator')
        .id('Animator')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'pages/AnimatorDisplaySync' // 目标url
          }, router.RouterMode.Single, (err) => {
            if (err) {
              Logger.error(`Invoke replaceUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            Logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('50%')
        .height(40)
        .shadow(ShadowStyle.OUTER_DEFAULT_LG)
    }
    .width('100%')
  }
}