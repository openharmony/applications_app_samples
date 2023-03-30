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

import { FavorLiveListsModel, OrderModel } from '../model/UserCenterModels';
import { FAVOR_LIVE_LIST_IMAGE } from './ImageData';

export const FAVOR_LIVE_LIST_DATA: Array<FavorLiveListsModel> = [
  {
    imgSrc: FAVOR_LIVE_LIST_IMAGE[0],
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  },
  {
    imgSrc: FAVOR_LIVE_LIST_IMAGE[0],
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  },
  {
    imgSrc: FAVOR_LIVE_LIST_IMAGE[1],
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  },
  {
    imgSrc: FAVOR_LIVE_LIST_IMAGE[1],
    title: $r('app.string.favor_live_lists_data_title'),
    viewsInfo: $r('app.string.favor_live_lists_data_viewsInfo')
  }
];

export const ORDER_DATA: Array<OrderModel> = [
  {
    img: $r('app.media.obligation'),
    title: $r('app.string.order_data_title_obligation')
  },
  {
    img: $r('app.media.wait_delivery'),
    title: $r('app.string.order_data_title_wait_deliver')
  },
  {
    img: $r('app.media.wait_receive'),
    title: $r('app.string.order_data_title_wait_receive')
  },
  {
    img: $r('app.media.wait_evaluted'),
    title: $r('app.string.order_data_title_wait_recommend')
  },
  {
    img: $r('app.media.refund'),
    title: $r('app.string.order_data_title_refund')
  }
];
