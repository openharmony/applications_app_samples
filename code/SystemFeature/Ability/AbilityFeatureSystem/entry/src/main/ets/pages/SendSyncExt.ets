/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import prompt from '@ohos.promptAction';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';

const TAG: string = 'UIExtensionAbility';
let storage: LocalStorage = LocalStorage.getShared();

@Entry(storage)
@Component
struct SendSyncExt {
  private session: (UIExtensionContentSession | undefined) = storage.get<UIExtensionContentSession>('session');
  private want: (Want | undefined) = storage.get<Want>('want');

  onPageShow() {
    if (this.session != undefined) {
      this.session.setReceiveDataForResultCallback((data: Record<string, object>) => {
        prompt.showToast({ message: `${TAG} onReceive ${data['key']}`, duration: 3000, bottom: 20 });
        let a: Record<string, string> = { 'key': `data from ${TAG}` };
        return a;
      })
    }
  }

  build() {
    Column() {

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
  }
}