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
    imageXTranslate: 0,
    imageYTranslate: 0,
    containerXTranslate: 0,
    containerYTranslate: 0
  },

  onInit() {
  },

  setImageXTranslateValue(sliderMode) {
    this.imageXTranslate = Math.trunc(sliderMode.value)
  },

  setImageYTranslateValue(sliderMode) {
    this.imageYTranslate = Math.trunc(sliderMode.value)
  },

  setContainerXTranslateValue(sliderMode) {
    this.containerXTranslate = Math.trunc(sliderMode.value)
  },

  setContainerYTranslateValue(sliderMode) {
    this.containerYTranslate = Math.trunc(sliderMode.value)
  }
}
