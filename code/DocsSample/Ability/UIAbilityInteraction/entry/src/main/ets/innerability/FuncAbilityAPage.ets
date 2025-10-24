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

// [Start FuncAbilityA]
// [Start FuncAbilityB]
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Page_FromStageModel]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_FromStageModel {

  build() {
    Column() {
      // [StartExclude FuncAbilityB]
      Button($r('app.string.Stop_AbilityA'))
        .onClick(() => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
          // context为需要停止的UIAbility实例的AbilityContext
          context.terminateSelf((err) => {
            if (err.code) {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self. Code is ${err.code}, message is ${err.message}`);
              return;
            }
          });
        })
        // [StartExclude FuncAbilityA]
        .margin({bottom: 8})
        .width('60%');
      // [EndExclude FuncAbilityA]
      // [EndExclude FuncAbilityB]

      // [StartExclude FuncAbilityA]
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude FuncAbilityB]
            Button($r('app.string.Stop_AbilityA_Result'))
              .width('60%');
            // [EndExclude FuncAbilityB]
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            const RESULT_CODE: number = 1001;
            let abilityResult: common.AbilityResult = {
              resultCode: RESULT_CODE,
              want: {
                bundleName: 'com.samples.uiabilityinteraction',
                moduleName: 'entry', // moduleName非必选
                abilityName: 'FuncAbilityA',
                parameters: {
                  info: '来自FuncAbility Index页面'
                },
              },
            };
            context.terminateSelfWithResult(abilityResult, (err) => {
              if (err.code) {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self with result. Code is ${err.code}, message is ${err.message}`);
                return;
              }
            });
          })
        }
      }
      // [StartExclude FuncAbilityB]
      .alignListItem(ListItemAlign.Center)
      // [EndExclude FuncAbilityB]
      // [EndExclude FuncAbilityA]
    }
    // [StartExclude FuncAbilityA]
    // [StartExclude FuncAbilityB]
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude FuncAbilityB]
    // [EndExclude FuncAbilityA]
  }
}
// [End FuncAbilityB]
// [End FuncAbilityA]