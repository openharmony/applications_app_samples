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

// [Start quick_start0]
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
// [StartExclude  quick_start0]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER = 0xF811;
const TAG  = '[Sample_UnexpExit]';
// [EndExclude  quick_start0]
@Entry
@Component
struct Index {
  build() {
    Button('start link', { type: ButtonType.Capsule, stateEffect: true })
      .width('87%')
      .height('5%')
      .margin({ bottom: '12vp' })
      .onClick(() => {
        let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
        let link: string = "https://www.example.com/programs?action=showall";
        // 仅以App Linking的方式打开应用
        context.openLink(link, { appLinkingOnly: true })
          .then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, 'openlink success.');
          })
          .catch((error: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG, `openlink failed. error:${JSON.stringify(error)}`);
          });
      })
  }
}
// [End quick_start0]