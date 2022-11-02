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
    sliderTitle: '',
    sliderValue: '60',
    sliderColorValue: '60',
    sliderStatus: 'End',
    sliderStatusValue: '60',
    sliderStepTipValue: '10',
    sliderBlockColor: '',
    sliderSelectedColor: '',
    sliderUnselectedColor: '',
    blockColor: '#FFFFFF',
    sliderColorPlaceholder: 'FFFFFFFF',
    selectedColor: '#FF007DFF',
    sliderSelectedPlaceholder:'FF007DFF',
    unselectColor: '#19000000',
    sliderUnselectedPlaceholder: '19000000'
  },

  onInit() {
    this.sliderTitle = this.$t('strings.slider_title')
    this.sliderBlockColor = this.$t('strings.slider_block_color')
    this.sliderSelectedColor = this.$t('strings.slider_selected_color')
    this.sliderUnselectedColor = this.$t('strings.slider_unselected_color')
  },

  setNormalSliderValue(normalSlider) {
    this.sliderValue = normalSlider.value
  },

  setSliderEventsValue(sliderEvents) {
    switch (sliderEvents.mode) {
      case 'start':
        this.sliderStatus = 'Begin'
        break
      case 'move':
        this.sliderStatus = 'Move'
        break
      case 'end':
        this.sliderStatus = 'End'
        break
      default:
        this.sliderStatus = 'Click'
        break
    }
    prompt.showToast({
      message: `value: ${sliderEvents.value}`,
      duration: 1000
    })
  },

  setSliderColor(sliderColorObj) {
    if (sliderColorObj.detail.value) {
      this.blockColor = sliderColorObj.detail.value
    }
  },

  setSliderSelected(selectedColorObj) {
    if (selectedColorObj.detail.value) {
      this.selectedColor = selectedColorObj.detail.value
    }
  },

  setSliderUnselected(unselectedColorObj) {
    if (unselectedColorObj.detail.value) {
      this.unselectColor = unselectedColorObj.detail.value
    }
  }
}