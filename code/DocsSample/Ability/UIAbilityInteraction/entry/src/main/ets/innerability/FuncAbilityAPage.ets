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

// [Start FuncAbilityAPage]
// [Start FuncAbilityB]
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[FuncAbilityAPage]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct FuncAbilityAPage {

  build() {
    Column() {
      // [StartExclude FuncAbilityB]
      Button($r('app.string.Stop_AbilityA')) //'app.string.Stop_AbilityA'的值为StopFuncAbilityA
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
        // [StartExclude FuncAbilityAPage]
        .margin({bottom: 8})
        .width('60%');
      // [EndExclude FuncAbilityB]

      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude FuncAbilityB]
            Button($r('app.string.Stop_AbilityA_Result')) //'app.string.Stop_AbilityA_Result'的值为StopFuncAbilityAWithResult
              .width('60%');
            // [EndExclude FuncAbilityB]
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            const RESULT_CODE: number = 1001; //FuncAbilityA返回的结果
            let abilityResult: common.AbilityResult = {
              resultCode: RESULT_CODE,
              want: {
                bundleName: 'com.samples.uiabilityinteraction',
                moduleName: 'entry', // moduleName非必选
                abilityName: 'FuncAbilityA',
                parameters: {
                  info: $r('app.string.ability_return_info') //'app.string.ability_return_info'的值为来自FuncAbility Index页面
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
      // [EndExclude FuncAbilityAPage]
    }
    // [StartExclude FuncAbilityAPage]
    // [StartExclude FuncAbilityB]
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude FuncAbilityB]
    // [EndExclude FuncAbilityAPage]
  }
}
// [End FuncAbilityB]
// [End FuncAbilityAPage]