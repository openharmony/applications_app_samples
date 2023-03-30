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

import GoodsInfo from '../model/GoodsModel';

import { DatabaseUtil } from 'shoppingdata';

let mockList: Array<GoodsInfo> = [];

export const GOODS_DATA_ROOT: string = 'https://gitee.com/hong-shengquan/as_orange_shopping/raw/master';

export async function makeGoodsData(): Promise<void> {
  for (let i = 0;i < 10; i++) {
    for (let j = 0;j < GOODS_MOCK_DATA.length - 1; j++) {
      mockList.push(GOODS_MOCK_DATA[j]);
    }
  }
}

export async function insertGoodsList(context: Context): Promise<void> {
  let databaseUtil = new DatabaseUtil(context);
  await databaseUtil.insertGoodsList(context, GOODS_MOCK_DATA);
}

let GOODS_MOCK_DATA: Array<GoodsInfo> = [
  {
    id: "001",
    imageUrl: "/data/images/product001.png",
    title: "桌面小冰箱|5L|夏日必备|宿舍神器|【居家】【学生】",
    introduction: "三级能效|累计销量1000+|直流制冷",
    type: '1,2',
    price: "￥399",
    old_price: "￥589",
    count: 0
  },
  {
    id: "002",
    imageUrl: "/data/images/product002.png",
    title: "HBook16|轻薄笔记本|星空灰|学生|办公",
    introduction: "13890K|DDR4 16G|256G硬盘|高清屏幕|16英寸",
    type: '0,2',
    price: "￥3988",
    old_price: "￥4999",
    count: 0
  },
  {
    id: "003",
    imageUrl: "/data/images/product003.png",
    title: "D90|2亿像素|5G手机|曲屏|前置双摄",
    introduction: "处理器9999|1T存储|32G内存|2亿像素|5G全网通",
    type: '0',
    price: "￥4599",
    old_price: "￥5999",
    count: 0
  },
  {
    id: "004",
    imageUrl: "/data/images/product004.png",
    title: "AI智能按摩椅|舒缓压力|放松神器|精准穴位",
    introduction: "腰部热敷|扶手包裹|智能语音控制|推拿",
    type: '2',
    price: "￥6899",
    old_price: "￥8999",
    count: 0
  },
  {
    id: "005",
    imageUrl: "/data/images/product005.png",
    title: "极简双肩包|学生,办公通勤|大牌做工|品质保证",
    introduction: "尼龙(聚酰胺纤维)|大空间|极简设计|学生|办公通勤",
    type: '1,2',
    price: "￥199",
    old_price: "￥256",
    count: 0
  },
  {
    id: "006",
    imageUrl: "/data/images/product006.png",
    title: "M90|旗舰手机|静谧黑|5G手机|品牌保证",
    introduction: "处理器9999|2.5T存储|64G内存|5G全网通|4k曲面屏",
    type: '2',
    price: "￥6599",
    old_price: "￥7299",
    count: 0
  },
  {
    id: "007",
    imageUrl: "/data/images/product007.png",
    title: "NA12|直屏5G手机|高性能芯片|2k高清屏幕|双扬声器",
    introduction: "512G存储|16G可拓展内存|5000w像素|超长待机|高屏占比",
    type: '0',
    price: "￥3699",
    old_price: "￥3899",
    count: 0
  },
  {
    id: "008",
    imageUrl: "/data/images/product008.png",
    title: "HN50|直屏5G手机|暗夜黑|新一代快充技术",
    introduction: "512G存储|16G可拓展内存|1亿像素|超广角拍摄|超高屏占比",
    type: '1',
    price: "￥3589",
    old_price: "￥3899",
    count: 0
  },
  {
    id: "009",
    imageUrl: "/data/images/product009.png",
    title: "OH3|新品手机|炫彩白|5G手机|后置广角",
    introduction: "512G存储|5000w像素|超长续航|快充新科技|炫彩后盖",
    type: '0,1,2',
    price: "￥3549",
    old_price: "￥3999",
    count: 0
  },
  {
    id: "010",
    imageUrl: "/data/images/product010.png",
    title: "OH4|年度热销新品|全新影像系统|5G全网通",
    introduction: "120HZ高刷|前置超广角|超级快充|心动紫",
    type: '2',
    price: "￥4199",
    old_price: "￥4599",
    count: 0
  },
  {
    id: "011",
    imageUrl: "/data/images/product011.png",
    title: "OH5|6000mAh超大电池|5G网络|炫彩白",
    introduction: "6000mAh超大电池|前后双广角|512G存储|16G内存|2k高清屏幕",
    type: '1,2',
    price: "￥3999",
    old_price: "￥4299",
    count: 0
  },
  {
    id: "012",
    imageUrl: "/data/images/product012.png",
    title: "M90E|青春版|5G全网通|双扬声器|水滴屏",
    introduction: "5G全网通|后置超广角|1T存储|16G内存|超级快充",
    type: '1',
    price: "￥3199",
    old_price: "￥3459",
    count: 0
  },
  {
    id: "013",
    imageUrl: "/data/images/product013.png",
    title: "D90E|5G全网通|自研操作系统|小屏旗舰",
    introduction: "2T存储|32G可拓展内存|曲面屏|9999处理器|超级快充|30倍光学变焦",
    type: '2',
    price: "￥5999",
    old_price: "￥6599",
    count: 0
  }
];

export enum GOODS_TYPE {
  SELECTED,
  NEW,
  AFFORDABLE
}

export const GOODS_TYPE_LIST: Array<Resource> = [
  $r('app.string.goods_type_selected'),
  $r('app.string.goods_type_new'),
  $r('app.string.goods_type_affordable')
];

export async function getGoodsList(type: number): Promise<Array<GoodsInfo>> {
  let result: Array<GoodsInfo> = [];
  let typeStr: string = type.toString()
  for (let i = 0;i < GOODS_LIST.length - 1; i++) {
    if (GOODS_LIST[i].type.split(',').includes(typeStr)) {
      result.push(GOODS_LIST[i]);
    }
  }
  return result;
}

export const GOODS_LIST: Array<GoodsInfo> = mockList;
