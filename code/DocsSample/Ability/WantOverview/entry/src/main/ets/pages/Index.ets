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
// [Start explicit_start]
// [Start implicit_start]
import { common, Want } from '@kit.AbilityKit';
// [StartExclude explicit_start]
// [StartExclude implicit_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@ohos.base';

const TAG: string = 'Index';
const DOMAIN: number = 0xFF00;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Column() {
        Button('explicit')
          .width('50%')
          .height('50vp')
          .margin({ top: '40vp' })
          .id('explicitBtn')
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            // [EndExclude explicit_start]
            let wantInfo: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.wantoverview',
              abilityName: 'ExplicitAbility',
            };
            // [StartExclude explicit_start]
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(wantInfo).then(() => {
              hilog.info(DOMAIN, TAG, 'Succeeded in starting ExplicitAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN, TAG,
                `Failed to start ExplicitAbility. Code is ${err.code}, message is ${err.message}`);
            });
          })

        Button('implicit')
          .width('50%')
          .height('50vp')
          .margin({ top: '40vp' })
          .id('explicitBtn')
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            // [EndExclude implicit_start]
            let wantInfo: Want = {
              // uncomment line below if wish to implicitly query only in the specific bundle.
              // bundleName: 'com.example.myapplication',
              action: 'ohos.want.action.search',
              // entities can be omitted
              entities: [ 'entity.system.browsable' ],
              uri: 'https://www.test.com:8080/query/student',
              type: 'text/plain',
            };
            // [StartExclude implicit_start]
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(wantInfo).then(() => {
              hilog.info(DOMAIN, TAG, 'Succeeded');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN, TAG,
                `Failed. Code is ${err.code}, message is ${err.message}`);
            });
          })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}
// [EndExclude implicit_start]
// [EndExclude explicit_start]
// [End implicit_start]
// [End explicit_start]