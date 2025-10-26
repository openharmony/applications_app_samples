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

// [Start Index]
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Scroll() {
      Column() {
        Text(this.message)
          .id('HelloWorld')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.message = 'Welcome';
          })

        Button('terminateSelf').onClick(() => {
          this.context.terminateSelf();
        })
          .width('60%')
          .margin({top: 8})

        Button($r('app.string.Start_UIAbilityB')).onClick((event: ClickEvent) => {
          let want: Want = {
            bundleName: this.context.abilityInfo.bundleName,
            abilityName: 'UIAbilityB',
          };
          this.context.startAbility(want, (err: BusinessError) => {
            if (err.code) {
              hilog.error(DOMAIN, 'Index', `Failed to startAbility. Code: ${err.code}, message: ${err.message}.`);
            }
          });
        })
          .width('60%')
          .margin({top: 8})
      }
      // [StartExclude Index]
      .width('100%')
      .justifyContent(FlexAlign.Center)
      // [EndExclude Index]
    }
  }
}
// [End Index]