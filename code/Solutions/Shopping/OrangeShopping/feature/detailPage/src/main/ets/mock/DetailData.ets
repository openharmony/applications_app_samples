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

import { SwiperPicturesModel, CommentModel } from '../model/DetailMode';

export class CityType {
  name: string;
  city: CityType[] | string[];

  constructor(name: string, city: CityType[] | string[]) {
    this.name = name;
    this.city = city;
  }
}

export const SWIPER_PICTURE_DATA: Array<SwiperPicturesModel> = [
  new SwiperPicturesModel($r('app.media.swiper1')),
  new SwiperPicturesModel($r('app.media.swiper2')),
  new SwiperPicturesModel($r('app.media.swiper3')),
  new SwiperPicturesModel($r('app.media.swiper4'))
];

export const COMMENT_DATA: Array<CommentModel> = [
  new CommentModel($r('app.media.user_select'), '188****1765', $r('app.media.star'), '和描述相符很喜欢，做工细致，颜色好看，原装正品'),
  new CommentModel($r('app.media.user_select'), '188****1765', $r('app.media.star'), '和描述相符很喜欢，做工细致，颜色好看，原装正品'),
  new CommentModel($r('app.media.user_select'), '188****1765', $r('app.media.star'), '和描述相符很喜欢，做工细致，颜色好看，原装正品'),
  new CommentModel($r('app.media.user_select'), '188****1765', $r('app.media.star'), '和描述相符很喜欢，做工细致，颜色好看，原装正品'),
  new CommentModel($r('app.media.user_select'), '188****1765', $r('app.media.star'), '和描述相符很喜欢，做工细致，颜色好看，原装正品')
];

export const CITY_DATA = [
  new CityType('A', [new CityType('安徽', ['亳州', '安庆'])]),
  new CityType('B', [new CityType('北京', ['朝阳区', '大兴区'])]),
  new CityType('C', [new CityType('重庆', ['巴南区', '长寿区'])]),
  new CityType('F', [new CityType('福建', ['福州', '福安'])]),
  new CityType('G', ['甘肃', '广东', '广西', '贵州']),
  new CityType('H', ['海南', '河北', '河南', '黑龙江', '湖北', '湖南']),
  new CityType('J', ['吉林', '江苏', '江西']),
  new CityType('L', ['辽宁']),
  new CityType('N', ['内蒙古', '宁夏']),
  new CityType('Q', ['青海']),
  new CityType('S', ['山东', '山西', '陕西', '上海', '四川']),
  new CityType('T', ['天津']),
  new CityType('X', ['西藏', '新疆']),
  new CityType('Y', ['云南']),
  new CityType('Z', [new CityType('浙江', ['宁波', '杭州'])])
];


export const HOT_CITY = ['北京', '上海', '广州', '深圳', '杭州', '南京', '苏州', '天津', '武汉', '长沙', '重庆', '成都'];

export const TAB_VALUE = ['A', 'B', 'C', 'F', 'G', 'H', 'J', 'L', 'N', 'Q', 'S', 'T', 'X', 'Y', 'Z'];