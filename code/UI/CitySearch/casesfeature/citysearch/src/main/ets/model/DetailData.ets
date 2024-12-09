/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 热门城市列表项视图
 * @param hotListItem: 热门列表项数据
 * @param contentBuilder: 列表项视图
 */

export class HotListItemView {
  hotListItem: string;
  contentBuilder: WrappedBuilder<[string]>;

  constructor(hotListItem: string, contentBuilder: WrappedBuilder<[string]>) {
    this.hotListItem = hotListItem;
    this.contentBuilder = contentBuilder;
  }
}

/**
 * 定义城市类型类
 * name: 数据名称的首字母
 * dataList: 字母对应的列表数据
 */
export class AlphabetListItemType {
  name: string;
  dataList: string[];

  constructor(name: string, dataList: string[]) {
    this.name = name;
    this.dataList = dataList;
  }
}

/**
 * 城市列表项视图
 * @param alphabetListItem: 列表项数据
 * @param contentBuilder: 列表项视图
 */
export class AlphabetListItemView {
  alphabetListItem: AlphabetListItemType;
  contentBuilder: WrappedBuilder<[string]>;

  constructor(alphabetListItem: AlphabetListItemType, contentBuilder: WrappedBuilder<[string]>) {
    this.alphabetListItem = alphabetListItem;
    this.contentBuilder = contentBuilder;
  }
}

// 城市列表数据
export const CITY_DATA = [
  new AlphabetListItemType('A', ['阿尔山', '阿勒泰地区', '安庆', '安阳']),
  new AlphabetListItemType('B', ['北京', '亳州', '包头', '宝鸡']),
  new AlphabetListItemType('C', ['重庆', '长春', '长沙', '成都']),
  new AlphabetListItemType('F', ['福州', '阜阳', '佛山', '抚顺']),
  new AlphabetListItemType('G', ['广州', '桂林', '赣州', '高雄']),
  new AlphabetListItemType('H', ['哈尔滨', '合肥', '杭州', '呼和浩特', '鹤岗', '呼兰']),
  new AlphabetListItemType('J', ['济南', '九江', '佳木斯']),
  new AlphabetListItemType('L', ['兰州', '丽江', '洛阳',]),
  new AlphabetListItemType('N', ['南昌', '南京', '宁波']),
  new AlphabetListItemType('Q', ['青岛', '七台河', '秦皇岛']),
  new AlphabetListItemType('S', ['上海', '沈阳', '石家庄', '三亚', '双鸭山', '深圳', '苏州']),
  new AlphabetListItemType('T', ['天津', '太原', '吐鲁番', '台北', '台湾', '唐山']),
  new AlphabetListItemType('W', ['武汉', '文昌', '温岭', '温州', '芜湖']),
  new AlphabetListItemType('X', ['西安', '咸阳', '信阳', '厦门', '香港', '响水', '湘西']),
  new AlphabetListItemType('Y', ['银川', '延吉', '宜昌', '延边', '扬州', '烟台']),
  new AlphabetListItemType('Z',
    ['郑州', '珠海', '张家口', '张家界', '镇江', '中山', '枣阳', '枣庄', '漳州', '枝江', '芷江', '织金', '中牟', '中卫',
      '周口', '舟山', '庄河', '珠海'])
];


// 国内热门城市数据
export const HOT_CITY =
  ['北京', '上海', '广州', '深圳', '杭州', '南京', '苏州', '天津', '武汉', '长沙', '重庆', '成都'];
