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

@Entry
@Component
struct Index {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    List({ space: 4 }) {
      ListItem() {
        Button('terminateSelf').onClick(() => {
          this.context.terminateSelf()
        })
          .width('100%')

      }

      ListItem() {
        // app.string.Start_UIAbilityB资源文件中的value值为'拉起UIAbilityB'
        Button($r('app.string.Start_UIAbilityB'))
          .onClick((event: ClickEvent) => {
            let want: Want = {
              bundleName: this.context.abilityInfo.bundleName,
              abilityName: 'UIAbilityB',
            };

            this.context.startAbility(want, (err: BusinessError) => {
              if (err.code) {
                console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}.`);
              }
            });
        })
          .width('100%')
      }
    }
    .listDirection(Axis.Vertical)
    .backgroundColor(0xDCDCDC).padding(20)
    .margin({top:250})
  }
}
// [End Index]