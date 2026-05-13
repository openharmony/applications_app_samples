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
// [Start startOptions_windowMode]
import { common, Want, AbilityConstant, StartOptions } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[StartAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct StartWithSpecifiedWindowModeAbility {

  build() {
    Row() {
      Column() {
        Button("以分屏模式启动")
          .onClick(() => {
            // context为调用方UIAbility的UIAbilityContext
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;

            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.example.startoptions',
              abilityName: 'StartWithSpecifiedWindowModeAbility',
              parameters: {
                // 自定义信息
                info: '从StartWithSpecifiedWindowModeAbility启动'
              }
            };

            let options: StartOptions = {
              windowMode: AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY // 以分屏模式拉起
            };

            context.startAbility(want, options).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
            });
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End startOptions_windowMode]






