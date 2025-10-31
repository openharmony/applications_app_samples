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

// [Start mailto_index]
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct MailtoIndex {
  build() {
    Column() {
      Button('feedback')
        .onClick(() => {
          let ctx = this.getUIContext().getHostContext() as common.UIAbilityContext;
          ctx.startAbility({
            action: 'ohos.want.action.sendToData',
            uri: 'mailto:feedback@example.com?subject=App Feedback&body=Please describe your feedback here...'
          }).catch(() => {
            // TODO: Implement error handling.
          })
        })
    }
  }
}
// [End mailto_index]