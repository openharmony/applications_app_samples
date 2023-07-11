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
  data() {
    return {
      radioTitle: "",
      radioCity: [],
      // 防止沉浸，添加两个变量距离顶层和底层的距离为72
      topRectHeight: TOPRECTHEIGHT,
      bottomRectHeight: BOTTOMRECTHEIGHT
    }
  },
  onInit() {
    this.radioTitle = this.$t('strings.radio_title')
    this.radioCity = this.$t('strings.radio_city')
  },

  ClickRadio(resultStatus) {
    prompt.showToast({
      message: `${resultStatus}`,
      duration: 3000
    })
  }
}
