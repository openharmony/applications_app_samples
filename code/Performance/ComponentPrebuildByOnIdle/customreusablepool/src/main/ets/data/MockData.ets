/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ViewItem } from './ViewItem'

// 模拟数据图片资源列表
export const banners1: Resource[] = [
  $r('app.media.custom_reusable_text_expand_img1'),
  $r('app.media.custom_reusable_text_expand_img2'),
  $r('app.media.custom_reusable_text_expand_img3'),
  $r('app.media.custom_reusable_text_expand_img4')
];
export const banners2: Resource[] = [
  $r('app.media.custom_reusable_image_1'),
  $r('app.media.custom_reusable_image_2'),
  $r('app.media.custom_reusable_image_3'),
  $r('app.media.custom_reusable_image_4')
];

const furnitureImages: Resource[] =
  [$r('app.media.custom_reusable_waterFlow1'), $r('app.media.custom_reusable_waterFlow2'),
    $r('app.media.custom_reusable_waterFlow3'), $r('app.media.custom_reusable_waterFlow4'),
    $r('app.media.custom_reusable_waterFlow5'), $r('app.media.custom_reusable_waterFlow6'),
    $r('app.media.custom_reusable_waterFlow7'), $r('app.media.custom_reusable_waterFlow8')];
const furnitureNames: string[] =
  ['地铁口 精装带地暖三房', '精装花了两百多万',
    '靠东白马湖 高楼层视野开阔', '万科映月华庭',
    '乐虹湾三房精装修好', '湘湖地铁口，次新小区',
    '白马湖畔 三千余户的小区', '开发商精装，面对花园'];
const furnitureDes: string[] = ['3室2厅 | 88.78㎡ | 南 北', '5室2厅 | 256.86㎡ | 南',
  '3室2厅 | 88.86㎡ | 南', '3室2厅 | 81.72㎡ | 东 南',
  '3室2厅 | 88.86㎡ | 南', '3室2厅 | 88.86㎡ | 南',
  '3室2厅 | 88.86㎡ | 南', '3室2厅 | 89.71㎡ | 南'];

export function furnitureData(): ViewItem[] {
  const data: ViewItem[] = [];
  for (let i = 0; i < 100; i++) {
    const viewItem: ViewItem = new ViewItem();
    viewItem.id = i + '';
    viewItem.name = furnitureNames[i%furnitureNames.length];
    viewItem.des = furnitureDes[i%furnitureDes.length];
    viewItem.type = i % 2;
    viewItem.image = furnitureImages[i%furnitureImages.length];
    data.push(viewItem);
  }
  return data;
}

const goodsImages: Resource[] = [$r('app.media.custom_reusable_product00'), $r('app.media.custom_reusable_product01'),
  $r('app.media.custom_reusable_product02'), $r('app.media.custom_reusable_product03'),
  $r('app.media.custom_reusable_product04'), $r('app.media.custom_reusable_product05')];

const goodsNames: string[] = ['充电宝', '笔记本电脑', '移动手机', '电动按摩椅', '折叠屏', '极简潮流背包'];
const goodsDes: string[] = ['￥79.9', '￥6975.8', '￥4279.6', '￥5385.4', '￥1252.9', '￥105.3'];

export function goodsData(): ViewItem[] {
  const data: ViewItem[] = [];
  for (let i = 0; i < 100; i++) {
    const viewItem: ViewItem = new ViewItem();
    viewItem.id = i + '';
    viewItem.name = goodsNames[i % goodsNames.length];
    viewItem.des = goodsDes[i % goodsDes.length];
    viewItem.type = i % 2;
    viewItem.image = goodsImages[i % goodsImages.length];
    data.push(viewItem);
  }
  return data;
}

const travelImages:Resource[]=[$r('app.media.custom_reusable_image1'),$r('app.media.custom_reusable_image2'),
  $r('app.media.custom_reusable_image3'),$r('app.media.custom_reusable_image4'),
  $r('app.media.custom_reusable_image5'),$r('app.media.custom_reusable_image6'),];

const travelNames: string[] = ['云海日出星空', '穿过人山人海', '旅游攻略', '走进现实', '西湖为什么没有栏杆', '外滩很美了'];
const travelDes: string[] = ['小众旅行地 位于杭州桐庐的高山露营天花板', '没有计划，直接出发', '#旅行社 #穷游攻略', '光遇岛龙石岛', '#西湖 #景区', '来了这些地方...'];

export function travelData(): ViewItem[] {
  const data: ViewItem[] = [];
  for (let i = 0; i < 100; i++) {
    const viewItem: ViewItem = new ViewItem();
    viewItem.id = i + '';
    viewItem.name = travelNames[i % travelNames.length];
    viewItem.des = travelDes[i % travelDes.length];
    viewItem.type = i % 2;
    viewItem.image = travelImages[i % travelImages.length];
    data.push(viewItem);
  }
  return data;
}

const avatarImages:Resource[]=[$r('app.media.custom_reusable_avator1'),$r('app.media.custom_reusable_avator2'),
  $r('app.media.custom_reusable_avator3'),$r('app.media.custom_reusable_avator4'),
  $r('app.media.custom_reusable_avator5'),$r('app.media.custom_reusable_avator6')];

const avatarNames: string[] = ['开野', '顺子', '壹宅壹院', 'tzu-hsiao', '冰汤葫芦', '阳崽'];

export function avatarData(): ViewItem[] {
  const data: ViewItem[] = [];
  for (let i = 0; i < 100; i++) {
    const viewItem: ViewItem = new ViewItem();
    viewItem.id = i + '';
    viewItem.name = avatarNames[i % avatarNames.length];
    viewItem.des = '';
    viewItem.type = i % 2;
    viewItem.image = avatarImages[i % avatarImages.length];
    data.push(viewItem);
  }
  return data;
}

const natureImages:Resource[]=[$r('app.media.custom_reusable_nature_1'),$r('app.media.custom_reusable_nature_2'),
  $r('app.media.custom_reusable_nature_3'),$r('app.media.custom_reusable_nature_4')];
const natureNames: string[] = ['月亮', '山水', '湖泊', '雪山'];

export function natureData(): ViewItem[] {
  const data: ViewItem[] = [];
  for (let i = 0; i < 100; i++) {
    const viewItem: ViewItem = new ViewItem();
    viewItem.id = i + '';
    viewItem.name = natureNames[i % natureNames.length];
    viewItem.des = '';
    viewItem.type = i % 2;
    viewItem.image = natureImages[i % natureImages.length];
    data.push(viewItem);
  }
  return data;
}