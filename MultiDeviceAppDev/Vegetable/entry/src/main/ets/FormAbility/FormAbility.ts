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
import formProvider from '@ohos.application.formProvider'
import data_preferences from '@ohos.data.preferences'
import { cardsMockData } from '../mock/Data'

function getCardTitleByIndex(index: number): string {
  if (index >= cardsMockData.length) {
    return cardsMockData[0].title
  }
  return cardsMockData[index].title
}

function getCardStarsByIndex(index: number): string {
  if (index >= cardsMockData.length) {
    return cardsMockData[0].stars
  }
  return cardsMockData[index].stars
}

async function storeCardIndex(context, index: number) {
  try {
    const preferences = await data_preferences.getPreferences(context, 'card')
    await preferences.put('index', (index % cardsMockData.length))
    await preferences.flush()
    console.log("[Sample_Vegetable] store success.")
  } catch (error) {
    console.error("[Sample_Vegetable] storeCardIndex msg:" + error)
  }
}

async function updateForm(context, formId: string) {
  try {
    const preferences = await data_preferences.getPreferences(context, 'card')
    const index = await preferences.get('index', 1) as number
    console.log("[Sample_Vegetable] index:" + index.toString())
    storeCardIndex(context, (index + 1))
    let formData = {
      "title": getCardTitleByIndex(index),
      "stars": getCardStarsByIndex(index)
    }
    formProvider.updateForm(formId, formBindingData.createFormBindingData(formData))
    console.log("[Sample_Vegetable] update success.")
  } catch (error) {
    console.error("[Sample_Vegetable] updateForm msg:" + error)
  }
}

async function deletePreferences(context) {
  try {
    await data_preferences.deletePreferences(context, 'card')
  } catch (error) {
    console.error("[Sample_Vegetable] delete msg:" + error)
  }
}

export default class FormAbility extends FormExtension {
  onCreate(want) {
    // Called to return a FormBindingData object.
    let formData = {
      "title": getCardTitleByIndex(0),
      "stars": getCardStarsByIndex(0)
    }
    return formBindingData.createFormBindingData(formData)
  }

  onCastToNormal(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdate(formId) {
    // Called to notify the form provider to update a specified form.
    updateForm(this.context, formId)
  }

  onVisibilityChange(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onEvent(formId, message) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onDestroy(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
    deletePreferences(this.context)
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY
  }
}