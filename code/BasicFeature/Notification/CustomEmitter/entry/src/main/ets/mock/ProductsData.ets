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
  GoodResponse,
  TabTitleModel,
  ShopCartItemDataModel,
  ProductDataModel
} from '../model/GoodsModel'

export const PRODUCTS_Data: GoodResponse = {
  code: 0,
  data: {
    records: [
      {
        id: -1,
        uri: '',
        title: '',
        info: '',
        label: '',
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

export const SHOP_CART_ITEM_DATA: Array<ShopCartItemDataModel> = [
  {
    id: 0,
    uri: $r('app.media.product001'),
    title: $r('app.string.product_data_title_device'),
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 1,
    uri: $r('app.media.product004'),
    title: $r('app.string.product_data_title_device'),
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 2,
    uri: $r('app.media.product005'),
    title: $r('app.string.product_data_title_device'),
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
]

export const PRODUCT_DATA: Array<ProductDataModel> = [
  {
    id: 0,
    uri: $r('app.media.product001'),
    title: $r('app.string.product_data_title_device'),
    info: $r('app.string.product_data_title_device'),
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 1,
    uri: $r('app.media.product004'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 2,
    uri: $r('app.media.product005'),
    title: $r('app.string.product_data_title_device'),
    info: $r('app.string.product_data_title_device'),
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 3,
    uri: $r('app.media.product001'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  },
  {
    id: 4,
    uri: $r('app.media.product004'),
    title: $r('app.string.product_data_title_device'),
    info: undefined,
    label: $r('app.string.product_data_label_new_product'),
    price: $r('app.string.product_data_price')
  }
]
