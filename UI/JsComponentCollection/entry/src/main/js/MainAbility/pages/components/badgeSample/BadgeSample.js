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
  data() {
    return {
      numberBadgeConfig: {
        badgeColor: 'red',
        textColor: '#FFFFFF',
        textSize: '16vp',
        badgeSize: '20vp'
      },
      textBadgeConfig: {
        badgeColor: 'red',
        textColor: '#FFFFFF',
        textSize: '16vp',
        badgeSize: '20vp'
      },
      blueBigBadgeConfig: {
        badgeColor: 'blue',
        textColor: '#FFFFFF',
        textSize: '16vp',
        badgeSize: '24vp'
      },
      greenSmallBadgeConfig: {
        badgeColor: 'green',
        textColor: '#FFFFFF',
        textSize: '16vp',
        badgeSize: '14vp'
      },
      badgeTitle: '',
      newLabel: 'New',
    }
  },

  onInit() {
    this.badgeTitle = this.$t('strings.badge_title')
  }
}
