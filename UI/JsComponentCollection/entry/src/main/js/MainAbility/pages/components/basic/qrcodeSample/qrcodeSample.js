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

export default {
  data: {
    qrcodeTitle: '',
    qrcodeType: 'rect',
    qrcodeColor: 'Black',
    qrcodeColorList: [],
    qrcodeShapeList: [],
    qrcodeValue: '',
    rectText: ''
  },
  onInit() {
    this.qrcodeTitle = this.$t('strings.qrcode_title')
    this.qrcodeColorList = this.$t('strings.qrcode_color_list')
    this.qrcodeShapeList = this.$t('strings.qrcode_shape_list')
  },

  changeQrcodeValue(qrcodeValueObj) {
    if (qrcodeValueObj.value) {
      this.qrcodeValue = qrcodeValueObj.value
    }
  },

  changeQrcodeColor(qrcodeColorObj) {
    if (qrcodeColorObj.newValue) {
      this.qrcodeColor = qrcodeColorObj.newValue
    }
  },

  changeQrcodeShape(qrcodeShapeObj) {
    if (qrcodeShapeObj.newValue) {
      this.qrcodeType = qrcodeShapeObj.newValue
    }
  }
}