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
  ProductDataModel,
  Records,
  Info
} from '../model/GoodsModel';

export const Products_Data: GoodResponse = new GoodResponse(0, new Records([new Info(-1, '', '', '', '', -1)], -1), '')

export const TAB_TITLE_DATA: Array<TabTitleModel> = [
  new TabTitleModel($r('app.media.home'), $r('app.media.home_selected'), $r('app.string.tab_title_data_home')),
  new TabTitleModel($r('app.media.new'), $r('app.media.new_selected'), $r('app.string.tab_title_data_new_product')),
  new TabTitleModel($r('app.media.cart'), $r('app.media.cart_selected'), $r('app.string.tab_title_data_cart')),
  new TabTitleModel($r('app.media.user'), $r('app.media.user_selected'), $r('app.string.tab_title_data_mine'))
]

export const FAVOR_LIVE_LIST_DATA: Array<FavorLiveListsModel> = [
  new FavorLiveListsModel(0, $r('app.media.live_coriander'), $r('app.string.favor_live_lists_data_title'), $r('app.string.favor_live_lists_data_viewsInfo')),
  new FavorLiveListsModel(1, $r('app.media.live_scene'), $r('app.string.favor_live_lists_data_title'), $r('app.string.favor_live_lists_data_viewsInfo')),
  new FavorLiveListsModel(2, $r('app.media.live_scene'), $r('app.string.favor_live_lists_data_title'), $r('app.string.favor_live_lists_data_viewsInfo')),
  new FavorLiveListsModel(3, $r('app.media.live_coriander'), $r('app.string.favor_live_lists_data_title'), $r('app.string.favor_live_lists_data_viewsInfo'))
]

export const ORDER_DATA: Array<OrderModel> = [
  new OrderModel(1, $r('app.media.obligation'), $r('app.string.order_data_title_obligation')),
  new OrderModel(2, $r('app.media.wait_delivery'), $r('app.string.order_data_title_wait_deliver')),
  new OrderModel(3, $r('app.media.wait_receive'), $r('app.string.order_data_title_wait_receive')),
  new OrderModel(4, $r('app.media.wait_evaluted'), $r('app.string.order_data_title_wait_recommend')),
  new OrderModel(5, $r('app.media.refund'), $r('app.string.order_data_title_refund'))
]

export const SHOP_CART_ITEM_DATA: Array<ShopCartItemDataModel> = [
  new ShopCartItemDataModel(1, $r('app.media.product006'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(2, $r('app.media.product006'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(3, $r('app.media.product006'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(4, $r('app.media.product006'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(5, $r('app.media.product006'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(6, $r('app.media.product006'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(7, $r('app.media.product007'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(8, $r('app.media.product008'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(9, $r('app.media.product009'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price')),
  new ShopCartItemDataModel(10, $r('app.media.product010'), $r('app.string.product_data_title_device'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price'))
]

export const FIND_SEARCH_TEXT_DATA: Array<SearchTextModel> = [
  new SearchTextModel(0, $r('app.string.find_search_text_data_search_text')),
  new SearchTextModel(1, $r('app.string.find_search_text_data_searchTex')),
  new SearchTextModel(2, $r('app.string.find_search_text_data_searchTe'))
]

export const INDEX_DATA: Array<SwiperModel> = [
  new SwiperModel(0, $r('app.media.banner_movie1')),
  new SwiperModel(1, $r("app.media.banner_movie3")),
  new SwiperModel(2, $r('app.media.banner_movie1')),
  new SwiperModel(3, $r("app.media.banner_movie3"))
]

export const SWIPER_DATA: Array<SwiperModel> = [
  new SwiperModel(0, $r("app.media.banner_movie2")),
  new SwiperModel(1, $r("app.media.banner_movie2")),
  new SwiperModel(2, $r("app.media.banner_movie2")),
  new SwiperModel(3, $r("app.media.banner_movie2"))
]

export const NEW_PRODUCT_TITLE_BAR_DATA: Array<NewProductTitleBarModel> = [
  new NewProductTitleBarModel(0, $r('app.string.new_product_title_bar_data_title_selected')),
  new NewProductTitleBarModel(1, $r('app.string.new_product_title_bar_data_title_phone')),
  new NewProductTitleBarModel(2, $r('app.string.new_product_title_bar_data_title_electric_appliance')),
  new NewProductTitleBarModel(3, $r('app.string.new_product_title_bar_data_title_sport')),
  new NewProductTitleBarModel(4, $r('app.string.new_product_title_bar_data_title_clothes'))
]

export const NAV_DATA: Array<NavDataModel> = [
  new NavDataModel(0, $r('app.string.tab_title_data_home')),
  new NavDataModel(1, $r('app.string.nav_data_phone')),
  new NavDataModel(2, $r('app.string.nav_data_food')),
  new NavDataModel(3, $r('app.string.nav_data_men_wear')),
  new NavDataModel(4, $r('app.string.nav_data_sport')),
  new NavDataModel(5, $r('app.string.nav_data_home_appliances'))
]

export const TITLE_BAR_DATA: Array<TitleBarModel> = [
  new TitleBarModel(0, $r('app.string.title_bar_data_title_all'), $r('app.string.title_bar_data_content_recommend')),
  new TitleBarModel(1, $r('app.string.title_bar_data_title_selected'), $r('app.string.title_bar_data_content_find')),
  new TitleBarModel(2, $r('app.string.title_bar_data_title_new_product'), $r('app.string.title_bar_data_content_first_publish')),
  new TitleBarModel(3, $r('app.string.title_bar_data_title_benefits'), $r('app.string.title_bar_data_content_cheap_good'))
]

export const PRODUCT_DATA: Array<ProductDataModel> = [
  new ProductDataModel(0, $r('app.media.product001'), $r('app.string.product_data_title_device0'), $r('app.string.product_data_info_device0'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price0')),
  new ProductDataModel(1, $r('app.media.product002'), $r('app.string.product_data_title_device1'), $r('app.string.product_data_info_device1'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price1')),
  new ProductDataModel(2, $r('app.media.product003'), $r('app.string.product_data_title_device2'), $r('app.string.product_data_info_device2'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price2')),
  new ProductDataModel(3, $r('app.media.product004'), $r('app.string.product_data_title_device3'), $r('app.string.product_data_info_device3'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price3')),
  new ProductDataModel(4, $r('app.media.product005'), $r('app.string.product_data_title_device4'), $r('app.string.product_data_info_device4'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price4')),
  new ProductDataModel(5, $r('app.media.product006'), $r('app.string.product_data_title_device5'), $r('app.string.product_data_info_device5'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price5')),
  new ProductDataModel(6, $r('app.media.product007'), $r('app.string.product_data_title_device5'), $r('app.string.product_data_info_device5'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price5')),
  new ProductDataModel(7, $r('app.media.product008'), $r('app.string.product_data_title_device7'), $r('app.string.product_data_info_device7'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price7')),
  new ProductDataModel(8, $r('app.media.product001'), $r('app.string.product_data_title_device0'), $r('app.string.product_data_info_device0'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price0')),
  new ProductDataModel(9, $r('app.media.product002'), $r('app.string.product_data_title_device1'), $r('app.string.product_data_info_device1'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price1')),
  new ProductDataModel(10, $r('app.media.product003'), $r('app.string.product_data_title_device2'), $r('app.string.product_data_info_device2'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price2')),
  new ProductDataModel(11, $r('app.media.product004'), $r('app.string.product_data_title_device3'), $r('app.string.product_data_info_device3'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price3')),
  new ProductDataModel(12, $r('app.media.product005'), $r('app.string.product_data_title_device4'), $r('app.string.product_data_info_device4'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price4')),
  new ProductDataModel(13, $r('app.media.product006'), $r('app.string.product_data_title_device5'), $r('app.string.product_data_info_device5'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price5')),
  new ProductDataModel(14, $r('app.media.product007'), $r('app.string.product_data_title_device5'), $r('app.string.product_data_info_device5'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price5')),
  new ProductDataModel(15, $r('app.media.product008'), $r('app.string.product_data_title_device7'), $r('app.string.product_data_info_device7'), $r('app.string.product_data_labels_new_product'), $r('app.string.product_data_price7'))
]
