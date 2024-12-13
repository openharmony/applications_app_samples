/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ProductDataModel } from '../model/GoodsModel';

// 商品列表数据源
export const PRODUCT_DATA: ProductDataModel[] = [
  new ProductDataModel(0, $r('app.media.immersive_product00'), $r('app.string.immersive_product_title00'), $r('app.string.immersive_product_price00'), $r('app.string.immersive_product_view00')),
  new ProductDataModel(1, $r('app.media.immersive_product01'), $r('app.string.immersive_product_title01'), $r('app.string.immersive_product_price01'), $r('app.string.immersive_product_view01')),
  new ProductDataModel(2, $r('app.media.immersive_product02'), $r('app.string.immersive_product_title02'), $r('app.string.immersive_product_price02'), $r('app.string.immersive_product_view02')),
  new ProductDataModel(3, $r('app.media.immersive_product03'), $r('app.string.immersive_product_title03'), $r('app.string.immersive_product_price03'), $r('app.string.immersive_product_view03')),
  new ProductDataModel(4, $r('app.media.immersive_product04'), $r('app.string.immersive_product_title04'), $r('app.string.immersive_product_price04'), $r('app.string.immersive_product_view04')),
  new ProductDataModel(5, $r('app.media.immersive_product05'), $r('app.string.immersive_product_title05'), $r('app.string.immersive_product_price05'), $r('app.string.immersive_product_view05'))
];