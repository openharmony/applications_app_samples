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
    dividerTitle: '',
    customDividerValue: '8',
    minSlider: '1',
    maxSlider: '25',
    dividerColor: '#000000',
    dividerColorOptions: [],
    dividerCapStyleOptions: [],
    dividerCapStyle: 'butt',
    dividerWidthMessage: '',
    dividerColorLeftText: '',
    dividerCapStyleLeftText: ''
  },

  onInit() {
    this.dividerTitle = this.$t('strings.divider_title')
    this.dividerWidthMessage = this.$t('strings.divider_width_message')
    this.dividerColorLeftText = this.$t('strings.divider_color_left_text')
    this.dividerCapStyleLeftText = this.$t('strings.divider_cap_style_left_text')
    this.dividerColorOptions = this.$t('strings.divider_color_options')
    this.dividerCapStyleOptions = this.$t('strings.divider_cap_style_options')
  },

  setDividerWidthValue(dividerWidthObj) {
    if (dividerWidthObj.detail.value) {
      this.customDividerValue = dividerWidthObj.detail.value
    }
  },

  setDividerColorValue(dividerColorObj) {
    if (dividerColorObj.detail.value) {
      this.dividerColor = dividerColorObj.detail.value
    }
  },

  setCapStyleValue(capStyleObj) {
    if (capStyleObj.detail.value) {
      this.dividerCapStyle = capStyleObj.detail.value
    }
  }
}