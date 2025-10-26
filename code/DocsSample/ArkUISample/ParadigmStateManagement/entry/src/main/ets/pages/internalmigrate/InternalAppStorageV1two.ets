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
// [Start Internal_AppStorage_V1_two]
// EntryAbility1 Index1.ets
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Index1 {
  // 页面级UI状态存储点击text文本的次数
  @StorageLink('count') count: number = 0;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      Text(`EntryAbility1 count: ${this.count}`)
        .fontSize(50)
        .onClick(() => {
          this.count++;
        })
      Button('Jump to EntryAbility').onClick(() => {
        let wantInfo: Want = {
          bundleName: 'com.example.myapplication', // 替换成AppScope/app.json5里的bundleName
          abilityName: 'EntryAbility'
        };
        this.context.startAbility(wantInfo);
      })
    }
  }
}
// [End Internal_AppStorage_V1_two]
@Component
export struct InternalAppStorageV1two {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Trace_customize_V1'))
  }
}