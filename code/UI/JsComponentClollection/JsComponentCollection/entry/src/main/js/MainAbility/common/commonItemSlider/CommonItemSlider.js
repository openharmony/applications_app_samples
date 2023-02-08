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
  props: {
    leftText: {
      default: ''
    },
    min: {
      default: 1
    },
    max: {
      default: 10
    },
    value: {
      default: 0
    }
  },

  data: {
    sliderLeftText: '',
    sliderMinValue: 1,
    sliderMaxValue: 10,
    sliderValue: 0
  },

  onInit() {
    this.sliderLeftText = this.leftText
    this.sliderMinValue = this.min
    this.sliderMaxValue = this.max
    this.sliderValue = this.value
  },

  setValue(sliderValueData) {
    this.Value = sliderValueData.value
    this.$emit('sliderValue', {
      value: this.Value
    })
  }
}
