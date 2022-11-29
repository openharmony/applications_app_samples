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

import prompt from '@ohos.prompt'

export default {
  data: {
    inputTitle: "",
    inputType: 'text',
    passwordIconValue: true,
    inputRegularValue: 'aaa',
    cursorPositionValue: 'asdasd'
  },
  onInit() {
    this.inputTitle = this.$t('strings.input_title')
  },

  setInputType(inputTypeObj) {
    if (inputTypeObj.detail.value) {
      this.inputType = inputTypeObj.detail.value
    }
  },

  setPasswordIconValue(passwordIconValueObj) {
    if (passwordIconValueObj.detail.value) {
      this.passwordIconValue = passwordIconValueObj.detail.value
    }
  },

  changeRegular(regularObj) {
    if (regularObj.value) {
      this.inputRegularValue= regularObj.value
      this.inputRegularValue = regularObj.value.replace(/[^\a-\z\A-\Z]/g, '')
    }
  },

  translateInput(translateObj) {
    prompt.showToast({
      message: 'translate:' + translateObj.value
    })
  },

  shareInput(shareObj) {
    prompt.showToast({
      message: 'share:' + shareObj.value
    })
  },

  searchInput(searchInputObj) {
    prompt.showToast({
      message: 'search' + searchInputObj.value
    })
  }
}
