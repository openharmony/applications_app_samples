/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { LivePage } from '@ohos/video-component';
import { logger } from '@ohos/details-page-hsp/src/main/ets/utils/Logger';

@Component
export struct Live {
  @Consume('pageStack') pageStack: NavPathStack;

  build() {
    NavDestination() {
      LivePage();
    }
    .title('LivePage')
    .hideTitleBar(true)
    .onBackPressed(() => {
      this.pageStack.clear();
      logger.info(`SetPage onBackPressed pageStack:${JSON.stringify(this.pageStack)}`);
      return true;
    })
  }
}