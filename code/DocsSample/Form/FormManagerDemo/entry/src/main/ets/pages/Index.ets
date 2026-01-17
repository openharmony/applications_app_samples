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
// [Start FormManagerDemo]
// entry/src/main/ets/pages/Index.ets
import { formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        // 添加拉起卡片管理页面按钮
        Button($r('app.string.open_form_manager_button'))
          .onClick(() => {
            const want: Want = {
              bundleName: "com.samples.formmanagerdemo",
              abilityName: 'EntryFormAbility',
              parameters: {
                'ohos.extra.param.key.form_dimension': 2,
                'ohos.extra.param.key.form_name': 'widget',
                'ohos.extra.param.key.module_name': 'entry'
              },
            };
            try {
              // 点击按钮后调用openFormManager方法，拉起卡片管理页面
              formProvider.openFormManager(want);
            } catch (error) {
              promptAction.openToast({ message: (error as BusinessError).message });
              hilog.info(DOMAIN, 'testTag', 'catch error ', 'code:', (error as BusinessError).code, 'message:',
                (error as BusinessError).message);
            }
          })
          .margin({ top: 10, bottom: 10 })
      }
      .width('100%')
    }
    .height('100%')
  }
}

// [End FormManagerDemo]