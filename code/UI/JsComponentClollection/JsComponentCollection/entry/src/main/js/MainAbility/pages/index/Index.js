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
    notHaveSecondTitle: 'notHaveSecondTitle',
    haveSecondTitle: 'haveSecondTitle',
    tabIndex: 0,
    tabArr: [],
    iconArr:[
      {
        unselect: 'common/image/ic_unselect_component.png',
        select: 'common/image/ic_select_component.png'
      },
      {
        unselect: 'common/image/ic_unselect_universal.png',
        select: 'common/image/ic_select_universal.png'
      },
      {
        unselect: 'common/image/ic_unselect_animation.png',
        select: 'common/image/ic_select_animation.png'
      },
      {
        unselect: 'common/image/ic_unselect_global.png',
        select: 'common/image/ic_select_global.png'
      }
    ]
  },

  onInit() {
    this.tabArr = this.$t('strings.tab_arr')
  },

  tabsChange(index) {
    this.tabIndex = index.index
  },

  tabBarChange(index) {
    this.tabIndex = index
  },

  getIcon(index) {
    if(index === this.tabIndex) {
      return this.iconArr[index].select
    }
    return this.iconArr[index].unselect
  },

  getFontColor(index) {
    if (index === this.tabIndex) {
      return this.$t('color.index_font_color_selected')
    }
    return this.$t('color.index_font_color_unselected')
  },

  getTabTextOpcity(index) {
    if (index === this.tabIndex) {
      return '1'
    }
    return '0.5'
  }
}



