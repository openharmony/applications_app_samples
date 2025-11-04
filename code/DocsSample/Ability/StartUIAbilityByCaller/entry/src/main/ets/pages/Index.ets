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

// [Start startAbilityByCall]
import { common, Want, Caller } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[Page_UIAbilityComponentsInteractive]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_UIAbilityComponentsInteractive {
  caller: Caller | undefined = undefined;

  // 注册caller的release监听
  private regOnRelease(caller: Caller): void {
    hilog.info(DOMAIN_NUMBER, TAG, `caller is ${caller}`);
    try {
      caller.on('release', (msg: string) => {
        hilog.info(DOMAIN_NUMBER, TAG, `caller onRelease is called ${msg}`);
      })
      hilog.info(DOMAIN_NUMBER, TAG, 'succeeded in registering on release.');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to caller register on release. Code is ${code}, message is ${message}`);
    }
  };

  build() {
    Column() {
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude startAbilityByCall]
            Button('startAbilityByCall');
            // [EndExclude startAbilityByCall]
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              bundleName: 'com.samples.uiabilityinteraction',
              abilityName: 'CalleeAbility',
              parameters: {
                // 自定义信息
                info: 'CallSendMsg'
              }
            };
            context.startAbilityByCall(want).then((caller: Caller) => {
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in starting ability.Code is ${caller}`);
              if (caller === undefined) {
                hilog.info(DOMAIN_NUMBER, TAG, 'get caller failed');
                return;
              }
              else {
                hilog.info(DOMAIN_NUMBER, TAG, 'get caller success');
                this.regOnRelease(caller);
                this.getUIContext().getPromptAction().showToast({
                  message: 'CallerSuccess'
                });
                try {
                  caller.release();
                } catch (releaseErr) {
                  let code = (releaseErr as BusinessError).code;
                  let msg = (releaseErr as BusinessError).message;
                  hilog.error(DOMAIN_NUMBER, TAG, `Caller.release catch error, error.code: ${JSON.stringify(code)}, error.message: ${JSON.stringify(msg)}.`);
                }
              }
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
      }
      // [StartExclude startAbilityByCall]
      .alignListItem(ListItemAlign.Center)
      // [EndExclude startAbilityByCall]
    }
    // [StartExclude startAbilityByCall]
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude startAbilityByCall]
  }
}
// [End startAbilityByCall]