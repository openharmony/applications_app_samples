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

import { CommonButton } from '../util/CommonButton';

@Entry
@Component
struct Index {
  @State message: string = 'ModuleLoadingSideEffects';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      CommonButton({ buttonName: 'LazyImport', buttonUrl: 'pages/LazyImportChangeExecutionOrder/moduleUseGlobalVar' });
      CommonButton({ buttonName: 'ModifyGlobalObject', buttonUrl: 'pages/ModifyGlobalObject/main' });
      CommonButton({ buttonName: 'ModifyingGlobalVariables', buttonUrl: 'pages/ModifyingGlobalVariables/main' });
      CommonButton({ buttonName: 'ModifyTheApplicationLevelArkUI', buttonUrl: 'pages/ModifyTheApplicationLevelArkUI/Index' });
      CommonButton({ buttonName: 'TopCodeModification', buttonUrl: 'pages/TopCodeModification/main' });
    }
    .height('100%')
    .width('100%')
  }
}