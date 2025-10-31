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
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Index {
  @State message: string = 'EntryAbility';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.message = 'Welcome';
        })

      Button($r('app.string.singletonAbility')) //app.string.singletonAbility为用户自定义字符串资源
        .margin({top: 8})
        .onClick(() => {
          let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
          // context为调用方UIAbility的UIAbilityContext;
          let want: Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.samples.uiabilitylaunchtype',
            abilityName: 'SingletonAbility',
            moduleName: 'entry', // moduleName非必选
          };
          context.startAbility(want).then(() => {
            hilog.info(DOMAIN_NUMBER, 'Index', 'Succeeded in starting SpecifiedAbility.');
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, 'Index', `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
          })
        })

      Button($r('app.string.multitonAbility')) //app.string.multitonAbility为用户自定义字符串资源
        .margin({top: 8})
        .onClick(() => {
          let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
          // context为调用方UIAbility的UIAbilityContext;
          let want: Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.samples.uiabilitylaunchtype',
            abilityName: 'MultitonAbility',
            moduleName: 'entry', // moduleName非必选
          };
          context.startAbility(want).then(() => {
            hilog.info(DOMAIN_NUMBER, 'Index', 'Succeeded in starting SpecifiedAbility.');
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, 'Index', `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
          })
        })

      Button($r('app.string.specifiedAbility')) //app.string.specifiedAbility为用户自定义字符串资源
        .margin({top: 8})
        .onClick(() => {
          let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
          // context为调用方UIAbility的UIAbilityContext;
          let want: Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.samples.uiabilitylaunchtype',
            abilityName: 'SpecifiedAbility',
            moduleName: 'entry', // moduleName非必选
            parameters: {
              // 自定义信息
              instanceKey: 'instanceKey'
            }
          };
          context.startAbility(want).then(() => {
            hilog.info(DOMAIN_NUMBER, 'Index', 'Succeeded in starting SpecifiedAbility.');
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, 'Index', `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
          })
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}