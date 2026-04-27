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
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

const TAG = 'Rdb ';

export interface TrustEquipmentRow {
  IP: string;
}

export abstract class BasicErrorLike {
  abstract code: number;
  abstract message: string;
}

export abstract class QueryResultLike {
  abstract columnNames: Array<string>;
  abstract columnCount: number;
  abstract rowCount: number;
  abstract rowIndex: number;
  abstract isAtFirstRow(): boolean;
  abstract isAfterLastRow(): boolean;
  abstract close(): void;
}

export class TrustEquipmentBucket {
  public IP: string = '';

  constructor(ip: string) {
    this.IP = ip;
  }
}

export abstract class RdbStoreLike {
  abstract executeSql(sql: string): Promise<void>;
  abstract insert(
    table: string, 
    bucket: relationalStore.ValuesBucket, 
    callback: (err: BusinessError | BasicErrorLike | null, 
    rowId: number) => void): void;
  abstract delete(
    predicates: relationalStore.RdbPredicates, 
    callback: (err: BusinessError | BasicErrorLike | null, 
    rows: number) => void): void;
  abstract query(predicates: relationalStore.RdbPredicates, columns: Array<string>): 
  Promise<relationalStore.ResultSet | QueryResultLike>;
}

export class StoreConfigModel implements relationalStore.StoreConfig {
  public name: string = 'Projection.db';
  public securityLevel: relationalStore.SecurityLevel = relationalStore.SecurityLevel.S1;
}

export default class DeviceInfo {
  public ID: number = 0;
  public NAME: string = '';
  public INFO: string = '';

  constructor() {
  }
}

export class Rdb extends DeviceInfo {
  public static rdb: Rdb = new Rdb();
  public deviceInfo: DeviceInfo = new DeviceInfo();
  public context: common.UIAbilityContext | null = null;
  public rdbStore: relationalStore.RdbStore | RdbStoreLike | undefined = undefined;

  private createStoreConfig(): relationalStore.StoreConfig {
    return new StoreConfigModel();
  }

  private getContextValue(): common.UIAbilityContext {
    if (this.context !== null) {
      return this.context;
    }
    this.context = getContext(this) as common.UIAbilityContext;
    return this.context;
  }

  createRdb(): void {
    console.info(TAG + 'relationalStore ' + 'createRdb');
    const storeConfig: relationalStore.StoreConfig = this.createStoreConfig();
    //建库，创建关系型数据库
    relationalStore.getRdbStore(this.getContextValue(), storeConfig).then((rdbStore: relationalStore.RdbStore) => {
      this.rdbStore = rdbStore;
      console.info(TAG + 'relationalStore ' + 'Get RdbStore successfully.');
    }).catch((err: BusinessError) => {
      console.error(TAG + 'relationalStore ' + `Get RdbStore failed, code is ${err.code},message is ${err.message}`);
    }).finally(() => {
      const sql: string = 'CREATE TABLE IF NOT EXISTS TRUSTEQUIPMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, IP TEXT NOT NULL)';
      if (this.rdbStore !== undefined) {
        //建表，数据库表结构和相关数
        this.rdbStore.executeSql(sql).then(() => {
          console.info(TAG + 'relationalStore ' + 'Create table done.');
        }).catch((err: BusinessError) => {
          console.error(TAG + 'relationalStore ' + 'ExecuteSql failed, err: ' + JSON.stringify(err));
        });
      }
    });
  }

  insetRdb(ip: string): void {
    const tableName: string = 'TRUSTEQUIPMENT';
    const valueBacket: TrustEquipmentBucket = new TrustEquipmentBucket(ip);
    if (this.rdbStore !== undefined) {
      this.rdbStore.insert(
        tableName, { IP: valueBacket.IP }, 
        (err: BusinessError | BasicErrorLike | null, rowId: number) => {
        if (err) {
          console.error(TAG + 'relationalStore ' + 'Insert data failed, err: ' + JSON.stringify(err));
          return;
        }
        console.info(TAG + 'relationalStore ' + 'Insert data successful, rowId = ' + rowId);
      });
    } else {
      console.info(TAG + 'relationalStore ' + 'Insert rdbStore*****');
    }
  }

  deleteRdb(ip: string): void {
    const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('TRUSTEQUIPMENT');
    predicates.equalTo('IP', ip);
    if (this.rdbStore !== undefined) {
      this.rdbStore.delete(predicates, (err: BusinessError | BasicErrorLike | null, rows: number) => {
        if (err) {
          console.error(TAG + 'relationalStore ' + `Delete failed, code is ${err.code},message is ${err.message}`);
          return;
        }
        console.info(TAG + 'relationalStore ' + `Delete rows: ${rows}`);
      });
    }
  }

  async equalTo(ip: string): Promise<boolean> {
    const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('TRUSTEQUIPMENT');
    console.info(TAG + 'relationalStore ' + 'RdbPredicates = ' + predicates);
    predicates.equalTo('IP', ip);
    if (this.rdbStore !== undefined) {
      const result: relationalStore.ResultSet | QueryResultLike = await this.rdbStore.query(predicates, ['IP']);
      console.info(TAG + 'relationalStore ' + `resultSet columnNames: ${result.columnNames}`);
      console.info(TAG + 'relationalStore ' + `resultSet columnCount: ${result.columnCount}`);
      console.info(TAG + 'relationalStore ' + `resultSet rowCount: ${result.rowCount}`);
      if (result.rowCount === 0) {
        AppStorage.setOrCreate('IsTrust', false);
        return false;
      }
      AppStorage.setOrCreate('IsTrust', true);
      return true;
    }
    return false;
  }

  async createRdbandequalTo(ip: string): Promise<boolean> {
    console.info(TAG + 'relationalStore ' + 'createRdb');
    const storeConfig: relationalStore.StoreConfig = this.createStoreConfig();
    //建库，创建关系型数据库
    const rdbStore: relationalStore.RdbStore = await relationalStore.getRdbStore(this.getContextValue(), storeConfig);
    this.rdbStore = rdbStore;
    const sql: string = 'CREATE TABLE IF NOT EXISTS TRUSTEQUIPMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, IP TEXT NOT NULL)';
    if (this.rdbStore !== undefined) {
      //建表，数据库表结构和相关数
      await this.rdbStore.executeSql(sql);
      return this.equalTo(ip);
    }
    return false;
  }
}
