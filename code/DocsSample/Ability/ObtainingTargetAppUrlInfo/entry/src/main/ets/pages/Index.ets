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
// [Start Deep Linking]
import { common } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct SpecifiedPage {

  build() {
    Row() {
      Column() {
        Button("拉起目标应用")
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let link: string = 'appurl://www.example.com/path1';

            context.openLink(link, { appLinkingOnly: false })
              .then(() => {
                hilog.info(0x0000, 'testTag', `Succeeded in opening link.`);
              })
              .catch((error: BusinessError) => {
                hilog.error(0x0000, 'testTag', `Failed to open link, code: ${error.code}, message: ${error.message}`);
              });
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Deep Linking]