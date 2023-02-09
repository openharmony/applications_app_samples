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
    selectImage: '',
    selectRestore: '',
    selectGesture: '',
    beiJing: '',
    shangHai: '',
    shenZhen: '',
    selectResources: [],
    currentResource: '',
    choiceFontStyle: '',
    unchoiceFontStyle: '',
    thirtyVp: '',
    twentyFiveVp: '',
    selectElements: '',
    selectCities: '',
    unSelectCities: ''
  },

  onInit() {
    this.selectImage = this.$t('strings.select_image')
    this.selectRestore = this.$t('strings.select_restore')
    this.selectGesture = this.$t('strings.select_gesture')
    this.beiJing = this.$t('strings.select_beijing')
    this.shangHai = this.$t('strings.select_shanghai')
    this.shenZhen = this.$t('strings.select_shenzhen')
    this.selectResources = this.$t('strings.select_resources')
    this.choiceFontStyle = this.$t('strings.select_choice_font_style')
    this.unchoiceFontStyle = this.$t('strings.select_unchoice_font_style')
    this.currentResource = this.selectResources[1]
    this.thirtyVp = this.$t('strings.select_thirty_vp')
    this.twentyFiveVp = this.$t('strings.select_twenty_five_vp')
    this.selectElements = this.$t('strings.select_elements')
    this.selectCities = this.$t('strings.select_cities')
    this.unSelectCities = this.$t('strings.unselect_cities')
  },

  changeCity(selectValue) {
    prompt.showToast({
      message: selectValue.newValue
    })
    if (selectValue.newValue === this.selectImage) {
      this.currentResource = this.selectResources[0]
    } else if (selectValue.newValue === this.selectRestore) {
      this.currentResource = this.selectResources[1]
    } else if (selectValue.newValue === this.selectGesture) {
      this.currentResource = this.selectResources[2]
    }
  },

  changeChoiceFont(selectValue) {
    prompt.showToast({
      message: selectValue.newValue
    })
    if (selectValue.newValue === this.beiJing) {
      this.selectCities[0]['fontSize'] = this.thirtyVp
      this.selectCities[1]['fontSize'] = this.twentyFiveVp
      this.selectCities[2]['fontSize'] = this.twentyFiveVp
    } else if (selectValue.newValue === this.shangHai) {
      this.selectCities[0]['fontSize'] = this.twentyFiveVp
      this.selectCities[1]['fontSize'] = this.thirtyVp
      this.selectCities[2]['fontSize'] = this.twentyFiveVp
    } else if (selectValue.newValue === this.shenZhen) {
      this.selectCities[0]['fontSize'] = this.twentyFiveVp
      this.selectCities[1]['fontSize'] = this.twentyFiveVp
      this.selectCities[2]['fontSize'] = this.thirtyVp
    }
  },

  changeUnchoiceFont(selectValue) {
    if (selectValue.newValue === this.beiJing) {
      this.unSelectCities[0]['fontSize'] = this.twentyFiveVp
      this.unSelectCities[1]['fontSize'] = this.thirtyVp
      this.unSelectCities[2]['fontSize'] = this.thirtyVp
    } else if (selectValue.newValue === this.shangHai) {
      this.unSelectCities[0]['fontSize'] = this.thirtyVp
      this.unSelectCities[1]['fontSize'] = this.twentyFiveVp
      this.unSelectCities[2]['fontSize'] = this.thirtyVp
    } else if (selectValue.newValue === this.shenZhen) {
      this.unSelectCities[0]['fontSize'] = this.thirtyVp
      this.unSelectCities[1]['fontSize'] = this.thirtyVp
      this.unSelectCities[2]['fontSize'] = this.twentyFiveVp
    }
  }
}
