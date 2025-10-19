/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

// [Start liveform_LiveFormExtensionAbility]
// entry/src/main/ets/myliveformextensionability/MyLiveFormExtensionAbility.ets
import { formInfo, LiveFormInfo, LiveFormExtensionAbility } from '@kit.FormKit';
import { UIExtensionContentSession } from '@kit.AbilityKit';

export default class MyLiveFormExtensionAbility extends LiveFormExtensionAbility {
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession) {
    let storage: LocalStorage = new LocalStorage();
    storage.setOrCreate('context', this.context);
    storage.setOrCreate('session', session);
    let formId: string = liveFormInfo.formId;
    storage.setOrCreate('formId', formId);

    // 获取卡片圆角信息
    let borderRadius: number = liveFormInfo.borderRadius;
    storage.setOrCreate('borderRadius', borderRadius);

    // liveFormInfo.rect字段表示非激活态卡片组件相对激活态UI的位置和尺寸信息
    let formRect: formInfo.Rect = liveFormInfo.rect;
    storage.setOrCreate('formRect', formRect);
    console.log(`startAbilityByLiveForm onSessionCreate formId: ${formId}` +
      `, borderRadius: ${borderRadius}, formRectInfo: ${JSON.stringify(formRect)}`);

    // 加载互动页面
    session.loadContent('myliveformextensionability/pages/MyLiveFormPage', storage);
  }

  onLiveFormDestroy(liveFormInfo: LiveFormInfo) {
    console.log(`startAbilityByLiveForm onDestroy`);
  }
};
// [End liveform_LiveFormExtensionAbility]