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
struct Index {
  build() {
    Column({ space: 20 }) {
      Button('Building and Managing ArkGraphics 3D Scenes')
        .id('scene')
        .fontWeight(500)
        .margin({ top: 200, left: 6 })
        .width('80%')
        .height(40)
        .onClick((): void => {
          router.pushUrl(
            { url: 'arkgraphic/scene' },
            router.RouterMode.Standard,
            (err) => {
              if (err) {
                logger.error('Invoke replaceUrl failed, code is ' + err.code + ', message is ' + err.message);
                return;
              }
              logger.info('Invoke replaceUrl succeeded.');
            }
          );
        })

      Button('Creating and Using ArkGraphics 3D Resources')
        .id('resource')
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .width('80%')
        .height(40)
        .onClick((): void => {
          router.pushUrl(
            { url: 'arkgraphic/resource' },
            router.RouterMode.Standard,
            (err) => {
              if (err) {
                logger.error('Invoke replaceUrl failed, code is ' + err.code + ', message is ' + err.message);
                return;
              }
              logger.info('Invoke replaceUrl succeeded.');
            }
          );
        })

      Button('Controlling and Managing ArkGraphics 3D Scene Animations')
        .id('animation')
        .fontWeight(500)
        .margin({ top: 20, left: 6 })
        .width('80%')
        .height(40)
        .onClick((): void => {
          router.pushUrl({ url: 'arkgraphic/animation' },
            router.RouterMode.Single,
            (err) => {
              if (err) {
                logger.error('Invoke replaceUrl failed, code is ' + err.code + ', message is ' + err.message);
                return;
              }
              logger.info('Invoke replaceUrl succeeded.');
            }
          );
        })
    }
    .width('100%');
  }
}

