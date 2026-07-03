/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import relationalStore from '@ohos.data.relationalStore';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { TableType } from './TableConfig';
import { GenericValues } from './GenericValues';
import { Logger } from '../utils/Logger';

/*
 * 数据库支持类
 * */
export class IDatabaseHelper {
  /*
   * 表信息
   * */
  public dataTypeToSqlTable: Map<TableType, Array<string>> = new Map([]);
  /*
   * 获取到的RdbStore
   * */
  protected store: relationalStore.RdbStore | undefined = undefined;

  /*
   * 执行sql语句
   * */
  async executeSql(sqlStr: string): Promise<boolean> {
    let res: boolean = false;
    if (this.store !== undefined) {
      await (this.store as relationalStore.RdbStore).executeSql(sqlStr).then(() => {
        res = true;
        Logger.info('IDatabaseHelper executeSql res');
      }).catch(() => {
        res = false;
        Logger.info('IDatabaseHelper executeSql error');
      });
    }
    return res;
  }

  /*
   * 插入
   * */
  async insert(type: TableType, value: ValuesBucket): Promise<boolean> {
    let res: boolean = false;
    if (this.store !== undefined) {
      await (this.store as relationalStore.RdbStore).insert(type, value).then((data) => {
        res = true;
        Logger.info('IDatabaseHelper insert res: ' + data);
      }).catch(() => {
        res = false;
        Logger.info('IDatabaseHelper insert error');
      });
    }
    return res;
  }

  /*
   * 插入多条数据
   * */
  async batchInsert(type: TableType, values: Array<ValuesBucket>): Promise<boolean> {
    let res: boolean = false;
    if (this.store !== undefined) {
      await (this.store as relationalStore.RdbStore).batchInsert(type, values).then((data) => {
        res = true;
        Logger.info('IDatabaseHelper batchInsert res: ' + data);
      }).catch(() => {
        res = false;
        Logger.info('IDatabaseHelper batchInsert error');
      });
    }
    return res;
  }

  /*
   * 删除
   * */
  async delete(predicates: relationalStore.RdbPredicates): Promise<boolean> {
    let res: boolean = false;
    if (this.store !== undefined) {
      await (this.store as relationalStore.RdbStore).delete(predicates).then((data) => {
        res = true;
        Logger.info('IDatabaseHelper delete res: ' + data);
      }).catch(() => {
        res = false;
        Logger.info('IDatabaseHelper delete error');
      });
    }
    return res;
  }

  /*
   * 更新
   * */
  async update(modifyValues: ValuesBucket, predicates: relationalStore.RdbPredicates): Promise<boolean> {
    let res: boolean = false;
    if (this.store !== undefined) {
      await (this.store as relationalStore.RdbStore).update(modifyValues, predicates).then((data) => {
        res = true;
        Logger.info('IDatabaseHelper update res: ' + data);
      }).catch(() => {
        res = false;
        Logger.info('IDatabaseHelper update error');
      });
    }
    return res;
  }

  /*
   * 查询
   * */
  async query(type: TableType): Promise<Array<GenericValues>> {
    let predicates = new relationalStore.RdbPredicates(type);
    let res: GenericValues[] = [];
    if (this.store !== undefined) {
      await (this.store as relationalStore.RdbStore).query(predicates).then((resultSet: relationalStore.ResultSet) => {
        Logger.info('IDatabaseHelper query res: ');
        while (resultSet.goToNextRow()) {
          let columns: string[] | undefined = this.dataTypeToSqlTable.get(type);
          let item = new GenericValues();
          if (columns !== undefined) {
            Logger.info('IDatabaseHelper query columns:' + columns.toString());
            for (let c of columns) {
              item.put(c, resultSet.getString(resultSet.getColumnIndex(c)));
            }
            res.push(item);
          }
        }
        resultSet.close();
      });
    }
    Logger.info('IDatabaseHelper query res :length=' + res.length);
    return res;
  }

  getData(resultSet: relationalStore.ResultSet, res: GenericValues[], type: TableType) {
    let item = new GenericValues();
    let mcolumns: string[] | undefined = this.dataTypeToSqlTable.get(type);
    if (mcolumns !== undefined) {
      Logger.info('IDatabaseHelper query columns:' + mcolumns.toString());
      for (let c of mcolumns) {
        item.put(c, resultSet.getString(resultSet.getColumnIndex(c)));
      }
      res.push(item);
    }
  }

  /*
   * 根据条件查询
   * */
  async queryByCondition(type: TableType, predicates: relationalStore.RdbPredicates,
    columns?: Array<string>): Promise<Array<GenericValues>> {
    let res: GenericValues[] = [];
    if (this.store !== undefined) {
      let resultSet: relationalStore.ResultSet =
        await (this.store as relationalStore.RdbStore).query(predicates, columns);
      Logger.info('IDatabaseHelper queryByCondition res: ');
      resultSet.goToNextRow();
      this.getData(resultSet, res, type);
      while (resultSet.goToNextRow()) {
        this.getData(resultSet, res, type);
      }
      resultSet.close();
    }
    Logger.info('IDatabaseHelper queryByCondition res :length=' + res.length);
    return res;
  }
}