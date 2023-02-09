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

import {
  TabTitleModel,
  SearchTextModel,
  NavigationDataModel,
  SwiperModel,
  TitleBarModel,
  ProductDataModel,
  GoodResponse
} from '../models/HomeModel'
import { getTheme } from '../utils/ThemeGet'

// 底部标签栏
export const getTabTitleData = (theme: number) => {
  let data: Array<TabTitleModel> = [
    {
      id: 0,
      uri: getTheme(theme).NAV_HOME,
      selectedUri: $r('app.media.nav_home_selected'),
      title: $r('app.string.tabTitleData_home')
    },
    {
      id: 1,
      uri: getTheme(theme).NAV_PRODUCT,
      selectedUri: $r('app.media.nav_product_selected'),
      title: $r('app.string.tabTitleData_newProduct')
    },
    {
      id: 2,
      uri: getTheme(theme).NAV_CART,
      selectedUri: $r('app.media.nav_cart_selected'),
      title: $r('app.string.tabTitleData_cart')
    },
    {
      id: 3,
      uri: getTheme(theme).NAV_ME,
      selectedUri: $r('app.media.nav_me_selected'),
      title: $r('app.string.tabTitleData_mine')
    }
  ]
  return data
}

// 首页搜索框的Swiper
export const searchTextData: Array<SearchTextModel> = [
  { searchText: $r('app.string.findSearchTextData_searchText') },
  { searchText: $r('app.string.findSearchTextData_searchTex') },
  { searchText: $r('app.string.findSearchTextData_searchTe') }
]

// 首页导航栏
export const navigationData: Array<NavigationDataModel> = [
  { id: 0, navigationData: $r('app.string.tabTitleData_home') },
  { id: 1, navigationData: $r('app.string.NavData_phone') },
  { id: 2, navigationData: $r('app.string.NavData_food') },
  { id: 3, navigationData: $r('app.string.NavData_men_wear') },
  { id: 4, navigationData: $r('app.string.NavData_sport') },
  { id: 5, navigationData: $r('app.string.NavData_home_appliances') }
]

// 首页轮播图
export const swiperData: Array<SwiperModel> = [
  { img: $r('app.media.banner') },
  { img: $r('app.media.banner2') }
]

export const indexData: Array<SwiperModel> = [
  { img: $r('app.media.banner') },
  { img: $r('app.media.banner2') }
]

// 首页中间部分的tabBar
export const titleBarData: Array<TitleBarModel> = [
  { id: 0, title: $r('app.string.titleBarData_title_all'), content: $r('app.string.titleBarData_content_recommend') },
  { id: 1, title: $r('app.string.titleBarData_title_selected'), content: $r('app.string.titleBarData_content_find') },
  {
    id: 2,
    title: $r('app.string.titleBarData_title_newProduct'),
    content: $r('app.string.titleBarData_content_first_publish')
  },
  {
    id: 3,
    title: $r('app.string.titleBarData_title_benefits'),
    content: $r('app.string.titleBarData_content_cheap_good')
  }
]

// 首页商品列表
export const productData: Array<ProductDataModel> = [
  {
    id: 1,
    detail: {
      uri: $r('app.media.product001'),
      title: $r('app.string.productData_title_device'),
      info: $r('app.string.productData_title_device'),
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product002'),
      title: $r('app.string.productData_title_device'),
      info: $r('app.string.productData_title_device'),
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product003'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product004'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product005'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product006'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product007'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product008'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  }, {
    id: 1,
    detail: {
      uri: $r('app.media.product001'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product002'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product003'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product004'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product005'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product006'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product007'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  },
  {
    id: 1,
    detail: {
      uri: $r('app.media.product008'),
      title: $r('app.string.productData_title_device'),
      info: undefined,
      labels: $r('app.string.productData_labels_newProduct'),
      price: $r('app.string.productData_price')
    }
  }
]

export const goodResponse: GoodResponse = {
  code: 0,
  data: {
    records: [{
                id: -1,
                detail: {
                  uri: '',
                  title: '',
                  info: '',
                  labels: '',
                  price: -1
                }
              }],
    totalCount: -1
  },
  error: null
}
