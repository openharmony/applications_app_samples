/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { TOPRECTHEIGHT, BOTTOMRECTHEIGHT } from '../../../../util/AttributeData';

export default {
  data: {
    inputTitle: "",
    inputValue: "",
    inputType: 'text',
    passwordIconValue: true,
    inputRegularValue: 'aaa',
    cursorPositionValue: 'asdasd',
    // 防止沉浸，添加两个变量距离顶层和底层的距离为72
    topRectHeight: TOPRECTHEIGHT,
    bottomRectHeight: BOTTOMRECTHEIGHT
  },
  onInit() {
    this.inputTitle = this.$t('strings.input_title')
  },

  setInputType(inputTypeObj) {
    if (inputTypeObj.detail.value) {
      this.inputValue = "";
      this.inputType = inputTypeObj.detail.value;
    }
  },

  setPasswordIconValue(passwordIconValueObj) {
    if (passwordIconValueObj.detail.value) {
      this.passwordIconValue = passwordIconValueObj.detail.value
    }
  },

  changeRegular(regularObj) {
    if (regularObj.value) {
      this.inputRegularValue = regularObj.value
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
