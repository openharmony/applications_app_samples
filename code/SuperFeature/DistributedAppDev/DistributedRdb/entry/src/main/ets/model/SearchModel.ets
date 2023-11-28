/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this.searchData file except in compliance with the License.
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

import common from '@ohos.app.ability.common';
import data_rdb from '@ohos.data.relationalStore';

import RdbModel from '../model/RdbModel';
import { TABLE_NAME, SQL_CREATE_TABLE, COLUMNS } from '../model/RdbConst';
import Logger from '../model/Logger';
import Contact from '../model/Contact';
import { GlobalContext } from '../model/GlobalContext';

const TAG = 'SearchModel';


class SearchData {
  selectIndex: number = 0; // 当前选择的index
  isAscending: boolean = true; // true 升序 false 降序

  searchText: string = ''; // 搜索文本
  searchTexts: string[] = ['', '']; // 搜索文本：区间
  inputType: InputType = InputType.Normal; // 搜索框输入类型


  searchTips: string[] = ['', '']; // 搜索提示语
  orderColumn = COLUMNS[1]; // 指定的搜索字段
  isDoubleInput: boolean = false; // 是否区间输入项
  searchPlaceholder: Resource = $r('app.string.search_placeholder_start'); // 提示文本


  clear(): void {
    this.searchText = '';
    this.searchTexts = ['', ''];
    this.searchTips = ['', ''];
    this.orderColumn = COLUMNS[1];
    this.isDoubleInput = false;
    this.searchPlaceholder = $r('app.string.search_placeholder_start');
  }
}

export default class SearchModel {
  private rdbModel = new RdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS, getContext(this) as common.UIAbilityContext);
  searchData: SearchData = new SearchData();
  queryData: Array<Contact> = [];
  queryOtherData: Array<Contact> = [];
  onSelectCallback: () => void = () => {};
  onDataCallback: () => void = () => {};

  public onSelect(index: number): void {
    this.searchData.clear();
    this.searchData.selectIndex = index;
    this.searchData.inputType = InputType.Normal;
    switch (index) {
      case 0:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_start');
        this.searchData.orderColumn = COLUMNS[3];
        this.searchData.isDoubleInput = false;
        this.searchData.inputType = InputType.Number;
        break;
      case 1:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_end');
        this.searchData.orderColumn = COLUMNS[3];
        this.searchData.isDoubleInput = false;
        this.searchData.inputType = InputType.Number;
        break;
      case 2:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_content');
        this.searchData.orderColumn = COLUMNS[3];
        this.searchData.isDoubleInput = false;
        break;
      case 3:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_age');
        this.searchData.orderColumn = COLUMNS[5];
        this.searchData.isDoubleInput = true;
        this.searchData.inputType = InputType.Number;
        break;
      case 4:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_age');
        this.searchData.orderColumn = COLUMNS[5];
        this.searchData.isDoubleInput = true;
        this.searchData.inputType = InputType.Number;
        break;
      case 5:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_name');
        this.searchData.orderColumn = COLUMNS[1];
        this.searchData.isDoubleInput = false;
        break;
      case 6:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_index');
        this.searchData.orderColumn = COLUMNS[0];
        this.searchData.isDoubleInput = false;
        this.searchData.inputType = InputType.Number;
        break;
      case 7:
        this.searchData.searchPlaceholder = $r('app.string.search_placeholder_expression');
        this.searchData.orderColumn = COLUMNS[3];
        this.searchData.isDoubleInput = false;
        break;
      default:
        break;
    }

    if (this.onSelectCallback) {
      this.onSelectCallback();
    }

    if (this.onDataCallback) {
      this.onDataCallback();
    }
  }

  async getData(): Promise<void> {
    this.searchData.searchTips[0] = '';
    this.searchData.searchTips[1] = '';
    this.queryData = [];
    this.queryOtherData = [];
    let predicates = new data_rdb.RdbPredicates(TABLE_NAME);
    switch (this.searchData.selectIndex) {
      case 0:
        predicates.beginsWith(COLUMNS[3], this.searchData.searchText);
        this.searchData.searchTips[0] = `查询到手机号开头为${this.searchData.searchText}的联系人`;
        break;
      case 1:
        predicates.endsWith(COLUMNS[3], this.searchData.searchText);
        this.searchData.searchTips[0] = `查询到手机号结尾为${this.searchData.searchText}的联系人`;
        break;
      case 2:
        predicates.contains(COLUMNS[1], this.searchData.searchText)
          .or()
          .contains(COLUMNS[3], this.searchData.searchText)
          .or()
          .contains(COLUMNS[4], this.searchData.searchText);
        this.searchData.searchTips[0] = `查询到姓名、手机号、备注中包含${this.searchData.searchText}的联系人`;
        break;
      case 3:
        if (this.searchData.searchTexts[0] !== '' || this.searchData.searchTexts[1] !== '') {
          let otherPredicates = new data_rdb.RdbPredicates(TABLE_NAME);
          if (this.searchData.searchTexts[0] === '') {
            predicates.lessThan(COLUMNS[5], this.searchData.searchTexts[1]);
            otherPredicates.greaterThanOrEqualTo('age', this.searchData.searchTexts[1]);
            this.searchData.searchTips[0] = `查询到年龄小于${this.searchData.searchTexts[1]}的联系人`;
            this.searchData.searchTips[1] = `查询到年龄不小于${this.searchData.searchTexts[1]}的联系人`;
          }
          if (this.searchData.searchTexts[1] === '') {
            predicates.greaterThan(COLUMNS[5], this.searchData.searchTexts[0]);
            otherPredicates.lessThanOrEqualTo('age', this.searchData.searchTexts[0]);
            this.searchData.searchTips[0] = `查询到年龄大于${this.searchData.searchTexts[0]}的联系人`;
            this.searchData.searchTips[1] = `查询到年龄不大于${this.searchData.searchTexts[0]}的联系人`;
          }
          if (this.searchData.searchTexts[0] !== '' && this.searchData.searchTexts[1] !== '') {
            predicates.greaterThan(COLUMNS[5], this.searchData.searchTexts[0])
              .and()
              .lessThan(COLUMNS[5], this.searchData.searchTexts[1]);
            otherPredicates.lessThanOrEqualTo(COLUMNS[5], this.searchData.searchTexts[0])
              .or()
              .greaterThanOrEqualTo(COLUMNS[5], this.searchData.searchTexts[1]);
            this.searchData.searchTips[0] = `查询到年龄在${this.searchData.searchTexts[0]}-${this.searchData.searchTexts[1]}之间的联系人`;
            this.searchData.searchTips[1] = `查询到年龄不在${this.searchData.searchTexts[0]}-${this.searchData.searchTexts[1]}之间的联系人`;
          }
          if (this.searchData.isAscending) {
            otherPredicates.orderByAsc(this.searchData.orderColumn);
          } else {
            otherPredicates.orderByDesc(this.searchData.orderColumn);
          }
          this.queryOtherData = await this.rdbModel.query(otherPredicates);
          Logger.info(TAG, `query otherPredicates ${JSON.stringify(this.queryOtherData)}`);
        }
        break;
      case 4:
        if (this.searchData.searchTexts[0] !== '' && this.searchData.searchTexts[1] !== '') {
          predicates.between(COLUMNS[5], Number(this.searchData.searchTexts[0]), Number(this.searchData.searchTexts[1]));
          let otherPredicates = new data_rdb.RdbPredicates(TABLE_NAME);
          otherPredicates.notBetween(COLUMNS[5], Number(this.searchData.searchTexts[0]), Number(this.searchData.searchTexts[1]));
          this.searchData.searchTips[0] = `查询到年龄在${this.searchData.searchTexts[0]}-${this.searchData.searchTexts[1]}之间的联系人`;
          this.searchData.searchTips[1] = `查询到年龄不在${this.searchData.searchTexts[0]}-${this.searchData.searchTexts[1]}之间的联系人`;
          if (this.searchData.isAscending) {
            otherPredicates.orderByAsc(this.searchData.orderColumn);
          } else {
            otherPredicates.orderByDesc(this.searchData.orderColumn);
          }
          this.queryOtherData = await this.rdbModel.query(otherPredicates);
          Logger.info(TAG, `query otherPredicates ${JSON.stringify(this.queryOtherData)}`);
        } else {
          return;
        }
        break;
      case 5:
        predicates.equalTo(COLUMNS[1], this.searchData.searchText);
        let otherPredicates = new data_rdb.RdbPredicates(TABLE_NAME);
        otherPredicates.notEqualTo(COLUMNS[1], this.searchData.searchText);
        this.searchData.searchTips[0] = `查询到姓名是${this.searchData.searchText}的联系人`;
        this.searchData.searchTips[1] = `查询到姓名不是${this.searchData.searchText}的联系人`;
        if (this.searchData.isAscending) {
          otherPredicates.orderByAsc(this.searchData.orderColumn);
        } else {
          otherPredicates.orderByDesc(this.searchData.orderColumn);
        }
        this.queryOtherData = await this.rdbModel.query(otherPredicates);
        Logger.info(TAG, `query otherPredicates ${JSON.stringify(this.queryOtherData)}`);
        break;
      case 6:
        predicates
          .equalTo(COLUMNS[0], this.searchData.searchText);
        this.searchData.searchTips[0] = `查询到索引值为${this.searchData.searchText}的联系人`;
        break;
      case 7:
        predicates.glob(COLUMNS[1], this.searchData.searchText)
          .or()
          .glob(COLUMNS[3], this.searchData.searchText)
          .or()
          .glob(COLUMNS[4], this.searchData.searchText)
          .or()
          .glob(COLUMNS[5], this.searchData.searchText);
        break;
      default:
        break;
    }
    if (this.searchData.isAscending) {
      predicates.orderByAsc(this.searchData.orderColumn);
    } else {
      predicates.orderByDesc(this.searchData.orderColumn);
    }

    this.queryData = await this.rdbModel.query(predicates);
    Logger.info(TAG, `query predicates ${JSON.stringify(this.queryData)}`);

    if (this.searchData.selectIndex === 7) {
      let ids: number[] = [];
      this.queryData.forEach((value) => {
        ids.push(value.id);
      });
      let otherPredicates = new data_rdb.RdbPredicates(TABLE_NAME);
      otherPredicates.notIn(COLUMNS[0], ids);
      this.searchData.searchTips[0] = `查询到匹配表达式${this.searchData.searchText}的联系人`;
      this.searchData.searchTips[1] = `查询到不匹配表达式${this.searchData.searchText}的联系人`;
      if (this.searchData.isAscending) {
        otherPredicates.orderByAsc(this.searchData.orderColumn);
      } else {
        otherPredicates.orderByDesc(this.searchData.orderColumn);
      }
      this.queryOtherData = await this.rdbModel.query(otherPredicates);
      Logger.info(TAG, `query otherPredicates ${JSON.stringify(this.queryOtherData)}`);
    }

    if (this.onSelectCallback) {
      this.onSelectCallback();
    }

    if (this.onDataCallback) {
      this.onDataCallback();
    }
  }
}