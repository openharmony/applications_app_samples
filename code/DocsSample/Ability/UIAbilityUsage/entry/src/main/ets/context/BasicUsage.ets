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

// [Start basicUsage]
// [Start terminateSelf]
import { common, Want } from '@kit.AbilityKit';
// [StartExclude basicUsage]
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [EndExclude basicUsage]

const DOMAIN = 0x0000;

@Entry
@Component
struct Page_UIAbilityComponentsBasicUsage {
  // [StartExclude terminateSelf]
  startAbilityTest(): void {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let want: Want = {
      // Want参数信息
      // [StartExclude basicUsage]
      bundleName: 'com.samples.uiabilityusage',
      abilityName: 'UIAbilityB'
      // [EndExclude basicUsage]
    };
    context.startAbility(want);
  }
  // [EndExclude terminateSelf]

  // 页面展示
  build() {
    // [StartExclude basicUsage]
    // [StartExclude terminateSelf]
    Column() {
      Text('UIAbilityB')
        .id('HelloWorld')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({bottom: 8})

      Button($r('app.string.Start_UIAbilityB')).onClick((event: ClickEvent) => {
        this.startAbilityTest();
      })
      // [EndExclude terminateSelf]

      Button('FuncAbilityB')
        .onClick(() => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          try {
            context.terminateSelf((err: BusinessError) => {
              if (err.code) {
                // 处理业务逻辑错误
                hilog.error(DOMAIN, 'terminateSelf', `terminateSelf failed, code is ${err.code}, message is ${err.message}.`);
                return;
              }
              // 执行正常业务
              hilog.info(DOMAIN, 'terminateSelf', `terminateSelf succeed.`);
            });
          } catch (err) {
            // 捕获同步的参数错误
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            hilog.error(DOMAIN, 'terminateSelf', `terminateSelf failed, code is ${code}, message is ${message}.`);
          }
        })
        .width('60%')
        .margin({top: 8})
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude basicUsage]
  }
}
// [End terminateSelf]
// [End basicUsage]