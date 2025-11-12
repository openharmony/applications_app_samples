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

import { PromptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
export struct CreateDefaultMenuExample {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // [Start create_default_menu]
        Button('click for Menu')
          .bindMenu([
            {
              value: 'Menu1',
              action: () => {
                hilog.info(0xFF00, 'DialogProject', 'handle Menu1 select');
              }
            }
          ])
          // [End create_default_menu]
          .id('click for Menu')

      }
      .width('100%')
      .height('100%')
    }
    // [StartExclude create_default_menu]
    .title($r('app.string.CreateDefaultMenu_title'))
    // [EndExclude create_default_menu]
  }
}