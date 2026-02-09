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

// [start Internal_localStorage_multi_instance_1]
// Index.ets
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      Text('使用文件管理器，使用本应用打开多个PDF')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Button('Jump to PDF_A').onClick(() => {
        let wantInfo: Want = {
          bundleName: 'com.samples.paradigmstatemanagement',
          abilityName: 'PdfEntryAbility',
          uri: 'PDF_A',
          parameters: {
            key: 'PDF_A',
            value: 'PDF_A-1111111111',
          }
        };
        this.context.startAbility(wantInfo);
      })
      Button('Jump to PDF_B').onClick(() => {
        let wantInfo: Want = {
          bundleName: 'com.samples.paradigmstatemanagement',
          abilityName: 'PdfEntryAbility',
          uri: 'PDF_B',
          parameters: {
            key: 'PDF_B',
            value: 'PDF_B-22222222222',
          }
        };
        this.context.startAbility(wantInfo);
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End Internal_localStorage_multi_instance_1]

@Component
export struct LocalStorageMultiInstance {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Trace_customize_Param'))
  }
}