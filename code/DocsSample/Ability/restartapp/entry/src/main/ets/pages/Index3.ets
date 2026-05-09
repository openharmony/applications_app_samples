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
// [Start restartapp_withNewWindow]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State message: string = 'restartApp to new page';

  build() {
    RelativeContainer() {
      Button(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(async () => {
          // 指定应用内其他UIAbility，跳转到新窗口
          let want: Want = {
            bundleName: 'com.example.restartapp',
            abilityName: 'SecondAbility'
          };
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          try {
            await context.restartApp(want);
            hilog.info(0x0000, 'testTag', 'restart success');
          } catch (err) {
            hilog.error(0x0000, 'testTag', `restart failed: ${err.code}, ${err.message}`);
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End restartapp_withNewWindow]