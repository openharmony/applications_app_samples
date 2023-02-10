/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import FormExtension from '@ohos.application.FormExtension'
import formBindingData from '@ohos.application.formBindingData'
import formInfo from '@ohos.application.formInfo'

export default class FormAbility extends FormExtension {
  onCreate(want) {
    // Called to return a FormBindingData object.
    // 创建卡片
    let formData = {}
    return formBindingData.createFormBindingData(formData)
  }

  onCastToNormal(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdate(formId) {
    // Called to notify the form provider to update a specified form.
  }

  onVisibilityChange(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onEvent(formId, message) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY
  }

  onDestroy(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
  }
}