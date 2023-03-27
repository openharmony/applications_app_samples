/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
  NavigationBarModel,
  FastSelectionModel
} from '../model/ComponentModel';

export const NAVIGATION_BAR_DATA: Array<NavigationBarModel> = [
  new NavigationBarModel($r('app.media.home'), $r('app.media.home_selected'), $r("app.string.navigation_title_home")),
  new NavigationBarModel($r('app.media.cart'), $r('app.media.cart_selected'), $r("app.string.navigation_title_shoppingcart"))
];

export const FAST_SELECTION_DATA:Array<FastSelectionModel> = [
  new FastSelectionModel($r('app.string.goods_type_selected'), $r('app.string.fast_selection_digital_product')),
  new FastSelectionModel($r('app.string.goods_type_new'), $r('app.string.fast_selection_new_arrival')),
  new FastSelectionModel($r('app.string.goods_type_affordable'), $r('app.string.fast_selection_fine_living'))
];