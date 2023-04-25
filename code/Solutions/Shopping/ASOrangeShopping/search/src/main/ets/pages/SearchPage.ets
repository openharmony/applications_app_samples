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

import router from '@ohos.router';

import Resource2String from '../utils/StringUtil';
import GoodsInfo from '../model/GoodsModel';
import DataPreferencesUtil from '../utils/DataPreferencesUtil';
import RouterUtil from '../utils/RouterUtil';

import { logger } from '../utils/Logger';
import { ResultList } from './common/ResultList';
import { RecentSearches } from './common/RecentSearches';
import { DatabaseUtil } from 'shoppingdata';

let TAG: string = 'Search';

/**
 * 从传入商品列表中搜索关键字信息
 * @param list 待检索的商品信息列表
 * @param keyWord 检索关键字
 */
function getResultList(list: Array<GoodsInfo>, keyWord: string): Array<GoodsInfo> {
  logger.info(TAG, `list: ${JSON.stringify(list.toString())}`);
  logger.info(TAG, `keyWord: ${keyWord}`);
  let result: Array<GoodsInfo> = [];
  for (let i = 0;i < list.length - 1; i++) {
    if (list[i].title.includes(keyWord) || list[i].introduction.includes(keyWord)) {
      result.push(list[i]);
      logger.info(TAG, `find goods: ${JSON.stringify(list[i])}`);
    }
  }
  return result;
}

@Entry
@Component
export struct SearchPage {
  private placeHolder: string;
  private context: Context = getContext(this);
  private preferencesUtil: DataPreferencesUtil;
  private databaseUtil: DatabaseUtil;
  private stringUtil: Resource2String = new Resource2String(this.context);
  @State hasResult: boolean = true;
  @State currentSearch: string = '';
  @Provide('recentList') recentList: Array<string> = [];
  @State goodsList: Array<GoodsInfo> = [];
  @State isResentSearchShow: boolean = true;
  @Provide('resultList') resultList: Array<GoodsInfo> = [];

  aboutToAppear() {
    let routerParam = router.getParams();
    this.placeHolder = routerParam['placeHolder'];
    this.databaseUtil = new DatabaseUtil(this.context);
    this.databaseUtil.getGoodsList(this.context).then(list => {
      this.goodsList = list;
    })
    this.preferencesUtil = new DataPreferencesUtil();
    this.preferencesUtil.getSearchList(this.context).then(list => {
      this.recentList = list;
    })
    RouterUtil.setContext(this.context);
  }

  async onSearch() {
    // 去重
    if (this.recentList.includes(this.currentSearch) || this.currentSearch === '') {
      logger.info(TAG, 'Current search value is null or exist.');
      return;
    }
    this.recentList.unshift(this.currentSearch);
    if (this.preferencesUtil !== undefined) {
      this.recentList = await this.preferencesUtil.pushSearchList(this.context, this.recentList);
    }
    this.build();
  }

  build() {
    Column() {
      Search({ placeholder: this.placeHolder, value: this.currentSearch })
        .backgroundColor($r('app.color.white'))
        .size({ width: '100%', height: 35 })
          //TODO 资源文件转换有问题, 暂时用字符串替代 this.stringUtil.getString($r('app.string.search_button_text'))
        .searchButton('search')
        .onSubmit(value => {
          this.currentSearch = value;
          this.onSearch();
          this.resultList = getResultList(this.goodsList, value);
        })
        .onChange(value => {
          this.isResentSearchShow = value.length === 0;
          this.resultList = getResultList(this.goodsList, value);
          this.hasResult = this.resultList.length > 0 || this.isResentSearchShow;
        })

      Text($r("app.string.no_related_products"))
        .fontSize(16)
        .fontColor(Color.Gray)
        .visibility(this.hasResult ? Visibility.None : Visibility.Visible)

      if (this.isResentSearchShow) {
        RecentSearches({ context: this.context, currentSearch: $currentSearch })
      } else {
        ResultList()
      }
    }
    .height('100%')
    .width('100%')
    .padding({ left: 12, right: 12 })
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.background'))
  }
}