/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start PageUse_PageTwo]
// PageTransitionTwo.ets

import { UIUtils, AppStorageV2 } from '@kit.ArkUI';
import { Info } from './PageUse';

@Entry
@ComponentV2
struct PageBExample {
  build() {
    Stack() {
      // 此处'app.media.startIcon'仅做示例，请开发者自行替换
      Image($r('app.media.startIcon'))
        .width(150)
        .height(150)
        .sharedTransition('sharedImage', { duration: 800, curve: Curve.Linear, delay: 100 })
        .onClick(() => {
          UIUtils.applySync(() => {
            AppStorageV2.connect(Info, () => new Info())!.name = 'sharedImage'; // 匹配
          });
          this.getUIContext().getRouter().back();
        })
        // [StartExclude PageUse_PageTwo]
        .id('PageTwo')
        // [EndExclude PageUse_PageTwo]
    }
    .width('100%')
    .height('100%')
  }
}
// [End PageUse_PageTwo]