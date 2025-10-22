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

// [Start Page_EventHub]
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Page_EventHub {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  startAbilityTest(): void {
    let want: Want = {
      // Want参数信息
      // [StartExclude Page_EventHub]
      bundleName: 'com.samples.uiabilityusage',
      abilityName: 'UIAbilityB'
      // [EndExclude Page_EventHub]
    };
    this.context.startAbility(want);
  }

  // 页面展示
  build() {
    // [StartExclude Page_EventHub]
    Column() {
      Text('UIAbilityB')
        .id('HelloWorld')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      Button($r('app.string.Start_UIAbilityB')).onClick((event: ClickEvent) => {
        this.startAbilityTest();
      })
    }
    .justifyContent(FlexAlign.Center)
    // [EndExclude Page_EventHub]
  }
}
// [End Page_EventHub]