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
// [Start applink_ability]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { url } from '@kit.ArkTS';

export default class AppLinkEntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 从want中获取传入的链接信息。
    // 如传入的url为：https://www.example.com/programs?action=showall
    let uri = want?.uri;
    if (uri) {
      // 从链接中解析query参数，拿到参数后，开发者可根据自己的业务需求进行后续的处理。
      let urlObject = url.URL.parseURL(want?.uri);
      let action = urlObject.params.get('action');
      // 例如，当action为showall时，展示所有的节目。
      if (action === 'showall') {
        // ...
      }
    }
  }
}
// [End applink_ability]