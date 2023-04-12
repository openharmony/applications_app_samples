/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
  GoodResponse,
  TabTitleModel,
  FavorLiveListsModel,
  OrderModel,
  ShopCartItemDataModel,
  SearchTextModel,
  SwiperModel,
  NewProductTitleBarModel,
  NavDataModel,
  TitleBarModel,
  ProductDataModel
} from '../model/GoodsModel'

export const Products_Data: GoodResponse = {
  code: 0,
  data: {
    records: [
      {
        id: -1,
        uri: '',
        title: '',
        info: '',
        labels: '',
        price: -1
      }
    ],
    totalCount: -1
  },
  error: null
}

export const TAB_TITLE_DATA: Array<TabTitleModel> = [
  new TabTitleModel($r('app.media.home'), $r('app.media.home_selected'), $r('app.string.tab_title_data_home')),
  new TabTitleModel($r('app.media.new'), $r('app.media.new_selected'), $r('app.string.tab_title_data_new_product')),
  new TabTitleModel($r('app.media.cart'), $r('app.media.cart_selected'), $r('app.string.tab_title_data_cart')),
  new TabTitleModel($r('app.media.user'), $r('app.media.user_selected'), $r('app.string.tab_title_data_mine'))
]

export const FAVOR_LIVE_LIST_DATA: Array<FavorLiveListsModel> = [
  {
    id:0,
    imgSrc: $r('app.media.live_coriander'),
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  },
  {
    id:1,
    imgSrc: $r('app.media.live_scene'),
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  },
  {
    id:2,
    imgSrc: $r('app.media.live_scene'),
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  },
  {
    id:3,
    imgSrc: $r('app.media.live_coriander'),
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  }
]

export const ORDER_DATA: Array<OrderModel> = [
  {
    id: 1,
    img: $r('app.media.obligation'),
    title: $r('app.string.order_data_title_obligation')
  },
  {
    id: 2,
    img: $r('app.media.wait_delivery'),
    title: $r('app.string.order_data_title_wait_deliver')
  },
  {
    id: 3,
    img: $r('app.media.wait_receive'),
    title: $r('app.string.order_data_title_wait_receive')
  },
  {
    id: 4,
    img: $r('app.media.wait_evaluted'),
    title: $r('app.string.order_data_title_wait_recommend')
  },
  {
    id: 5,
    img: $r('app.media.refund'),
    title: $r('app.string.order_data_title_refund')
  }
]

export const SHOP_CART_ITEM_DATA: Array<ShopCartItemDataModel> = [
  {
    id: 1,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 2,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 3,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 4,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 5,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 6,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 7,
    uri: $r('app.media.product007'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 8,
    uri: $r('app.media.product008'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 9,
    uri: $r('app.media.product009'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 10,
    uri: $r('app.media.product010'),
    title: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  }
]

export const FIND_SEARCH_TEXT_DATA: Array<SearchTextModel> = [
  { searchText: $r('app.string.find_search_text_data_search_text') },
  { searchText: $r('app.string.find_search_text_data_searchTex') },
  { searchText: $r('app.string.find_search_text_data_searchTe') }
]

export const INDEX_DATA: Array<SwiperModel> = [
  { id: 0, img: $r('app.media.banner_movie1') },
  { id: 1, img: $r("app.media.banner_movie3") },
  { id: 2, img: $r('app.media.banner_movie1') },
  { id: 3, img: $r("app.media.banner_movie3") }
]

export const SWIPER_DATA: Array<SwiperModel> = [
  { id: 0, img: $r("app.media.banner_movie2") },
  { id: 1, img: $r("app.media.banner_movie2") },
  { id: 2, img: $r("app.media.banner_movie2") },
  { id: 3, img: $r("app.media.banner_movie2") }
]

export const NEW_PRODUCT_TITLE_BAR_DATA: Array<NewProductTitleBarModel> = [
  { id: 0, title: $r('app.string.new_product_title_bar_data_title_selected') },
  { id: 1, title: $r('app.string.new_product_title_bar_data_title_phone') },
  { id: 2, title: $r('app.string.new_product_title_bar_data_title_electric_appliance') },
  { id: 3, title: $r('app.string.new_product_title_bar_data_title_sport') },
  { id: 4, title: $r('app.string.new_product_title_bar_data_title_clothes') }
]

export const NAV_DATA: Array<NavDataModel> = [
  { id: 0, navData: $r('app.string.tab_title_data_home') },
  { id: 1, navData: $r('app.string.nav_data_phone') },
  { id: 2, navData: $r('app.string.nav_data_food') },
  { id: 3, navData: $r('app.string.nav_data_men_wear') },
  { id: 4, navData: $r('app.string.nav_data_sport') },
  { id: 5, navData: $r('app.string.nav_data_home_appliances') }
]

export const TITLE_BAR_DATA: Array<TitleBarModel> = [
  {
    id: 0,
    title: $r('app.string.title_bar_data_title_all'),
    content: $r('app.string.title_bar_data_content_recommend')
  },
  {
    id: 1,
    title: $r('app.string.title_bar_data_title_selected'),
    content: $r('app.string.title_bar_data_content_find')
  },
  {
    id: 2,
    title: $r('app.string.title_bar_data_title_new_product'),
    content: $r('app.string.title_bar_data_content_first_publish')
  },
  {
    id: 3,
    title: $r('app.string.title_bar_data_title_benefits'),
    content: $r('app.string.title_bar_data_content_cheap_good')
  }
]

export const PRODUCT_DATA: Array<ProductDataModel> = [
  {
    id: 0,
    uri: $r('app.media.product001'),
    title: $r('app.string.product_data_title_device'),
    info: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 1,
    uri: $r('app.media.product002'),
    title: $r('app.string.product_data_title_device'),
    info: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 2,
    uri: $r('app.media.product003'),
    title: $r('app.string.product_data_title_device'),
    info: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 3,
    uri: $r('app.media.product004'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 4,
    uri: $r('app.media.product005'),
    title: $r('app.string.product_data_title_device'),
    info: $r('app.string.product_data_title_device'),
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 5,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 6,
    uri: $r('app.media.product007'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 7,
    uri: $r('app.media.product008'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 8,
    uri: $r('app.media.product001'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 9,
    uri: $r('app.media.product002'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 10,
    uri: $r('app.media.product003'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 11,
    uri: $r('app.media.product004'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 12,
    uri: $r('app.media.product005'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 13,
    uri: $r('app.media.product006'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 14,
    uri: $r('app.media.product007'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 15,
    uri: $r('app.media.product008'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    labels: $r('app.string.product_data_labels_new_product'),
    price: $r('app.string.product_data_price')
  }
]
