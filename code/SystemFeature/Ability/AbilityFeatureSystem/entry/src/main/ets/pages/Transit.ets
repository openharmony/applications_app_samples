/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { logger } from '../util/Logger';

@Entry
@Component
struct Transit {
  build() {
    Column() {
      UIExtensionComponent({
        bundleName: 'com.samples.abilityFeatureSystem',
        abilityName: 'UIExtAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
        }
      }).size({ width: '100%', height: '100%' })
        .onReceive((data) => {
          logger.info(`onReceive data:${JSON.stringify(data)}`);
          if (data.back) {
            router.back({
              url: 'pages/Index'
            });
          }
        })
    }.width('100%')
    .height('100%')
  }
}