/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

@Entry
@Component
struct scenePage {
  build() {
    Column({ space: 20 }) {
      Button('Model Loading and Display')
        .id('init')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 200, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'scene/init'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              logger.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40);

      Button('Creating and Managing a Camera')
        .id('camera')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'scene/camera'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              logger.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('Creating and Managing Light')
        .id('light')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'scene/light'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              logger.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            logger.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('back')
        .id('back')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .onClick(() => {
          router.back();
        })
        .width('80%')
        .height(40);
    }
    .width('100%');
  }
}