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


// [Start express_index_import]
import { common } from '@kit.AbilityKit';
// [End express_index_import]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'ExpressIndex';
const DOMAIN = 0x0000;
// [Start express_index_component]
@Entry
@Component
struct ExpressIndex {
  @State hideAbility: string = 'hideAbility';

  build() {
    Row() {
      Column() {
        Text(this.hideAbility)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let wantParam: Record<string, Object> = {
              'sceneType': 1,
              'expressNo': 'SF123456'
            };
            let abilityStartCallback: common.AbilityStartCallback = {
              onError: (code: number, name: string, message: string) => {
                hilog.error(DOMAIN, TAG, `onError code ${code} name: ${name} message: ${message}`);
              },
              onResult: (result) => {
                hilog.info(DOMAIN, TAG, `onResult result: ${JSON.stringify(result)}`);
              }
            }

            context.startAbilityByType('express', wantParam, abilityStartCallback,
              (err) => {
                if (err) {
                  hilog.error(DOMAIN, TAG, `startAbilityByType fail, err: ${JSON.stringify(err)}`);
                } else {
                  hilog.info(DOMAIN, TAG, `success`);
                }
              });
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End express_index_component]