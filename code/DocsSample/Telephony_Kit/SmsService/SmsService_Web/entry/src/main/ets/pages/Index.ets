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
// [Start SmsService_Web]
// 示例代码
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Index {

  build() {
    Column() {
      Button('Send Sms')
        .onClick(() => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          let exampleUrl = 'sms:106XXXXXXXXXX?body=%E5%8F%91%E9%80%81%E7%9F%AD%E4%BF%A1%E5%86%85%E5%AE%B9';
        
          let want: Want = {
              bundleName: 'com.ohos.mms',
              action: 'ohos.want.action.viewData',
              uri:exampleUrl,
            }
        
          context.startAbility(want).then((data) => {
              console.info('Success' + JSON.stringify(data));
          }).catch(() => {
              console.error('error');
          });

        })
    }
  }
}
// [End SmsService_Web]