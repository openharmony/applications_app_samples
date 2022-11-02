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

import router from '@ohos.router'

export default {
  props: {
    itemType: {
      default: 'notHaveSecondTitle'
    },
    tabIndex: {
      default: '0'
    }
  },

  data() {
    return {
      listCategory: []
    }
  },

  onInit() {
    this.initData()
  },

  initData() {
    switch (Number(this.tabIndex)) {
      case 0:
        this.listCategory = this.$t('strings.component_category')
        break
      case 1:
        this.listCategory = this.$t('strings.universal_category')
        break
      case 2:
        this.listCategory = this.$t('strings.animation_category')
        break
      default:
        this.listCategory = this.$t('strings.global_method_category')
        break
    }
  },

  listCategoryOnClick(listChild) {
    if (listChild.values.length === 0 && listChild.url) {
      router.push({
        url: listChild.url
      })
    } else {
      if (listChild.isUnfold === 'false') {
        listChild.isUnfold = 'true'
        return
      }
      listChild.isUnfold = 'false'
    }
  },

  handlerOnClick(item) {
    router.push({
      url: item.url
    })
  }
}



