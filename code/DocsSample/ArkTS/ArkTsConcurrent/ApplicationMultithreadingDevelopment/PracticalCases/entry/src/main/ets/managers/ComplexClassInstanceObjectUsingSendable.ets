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

// [Start complex_class_instance_object_using_sendable]
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { collections, taskpool } from '@kit.ArkTS';
import { IValueBucket, SharedValuesBucket } from './SharedValuesBucket';
import { Material } from './Material';

@Concurrent
async function create(context: Context): Promise<boolean> {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  try {
    // 默认数据库文件路径为 context.databaseDir + "/rdb/" + StoreConfig.name
    let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);
    console.info('Create Store.db successfully!');

    // 创建表
    const CREATE_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS test (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'name TEXT NOT NULL, ' +
      'age INTEGER, ' +
      'salary REAL, ' +
      'blobType BLOB)';
    await store.executeSql(CREATE_TABLE_SQL);
    console.info('Create table test successfully!');
    return true;
  } catch (err) {
    console.error(`Create db failed, code: ${err.code}, message: ${err.message}`);
    return false;
  }
}

@Concurrent
async function insert(context: Context, valueBucketArray: collections.Array<SharedValuesBucket | undefined>) {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + "/rdb/" + StoreConfig.name
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);
  console.info('Create Store.db successfully!');

  // 数据插入
  await store.batchInsert('test', valueBucketArray as Object as Array<ValuesBucket>);
}

@Concurrent
async function query(context: Context): Promise<collections.Array<SharedValuesBucket | undefined>> {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + "/rdb/" + StoreConfig.name
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);
  console.info('Create Store.db successfully!');

  // 获取用于查询的谓词
  let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('test');
  // 查询所有数据
  let resultSet = await store.query(predicates);
  console.info(`Query data successfully! row count:${resultSet.rowCount}`);
  let index = 0;
  let result = collections.Array.create<SharedValuesBucket | undefined>(resultSet.rowCount, undefined);
  resultSet.goToFirstRow();
  do {
    let value: IValueBucket = {
      id: resultSet.getLong(resultSet.getColumnIndex('id')),
      name: resultSet.getString(resultSet.getColumnIndex('name')),
      age: resultSet.getLong(resultSet.getColumnIndex('age')),
      salary: resultSet.getLong(resultSet.getColumnIndex('salary'))
    };
    result[index++] = new SharedValuesBucket(value);
  } while (resultSet.goToNextRow());
  resultSet.close();
  return result;
}

@Concurrent
async function deleteStore(context: Context) {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + "/rdb/" + StoreConfig.name
  await relationalStore.deleteRdbStore(context, CONFIG);
  console.info('Delete Store.db successfully!');
}

function initMaterial(): Material {
  // 数据准备
  const count = 5;
  let valueBucketArray = collections.Array.create<SharedValuesBucket | undefined>(count, undefined);
  for (let i = 0; i < count; i++) {
    let value: IValueBucket = {
      id: i,
      name: 'zhangsan' + i,
      age: 20,
      salary: 5000 + 50 * i
    };
    valueBucketArray[i] = new SharedValuesBucket(value);
  }
  let material = new Material(1, 'test', valueBucketArray);
  return material;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(async () => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          let material = initMaterial();
          let ret = await taskpool.execute(create, context);
          if (!ret) {
            console.error('Create db failed.');
            return;
          }
          await taskpool.execute(insert, context, material.getBuckets());
          let index = 0;
          let resultSet: collections.Array<SharedValuesBucket> =
            await taskpool.execute(query, context) as collections.Array<SharedValuesBucket>;
          material.setBuckets(resultSet);
          for (let value of resultSet.values()) {
            console.info(`Row[${index}].id = ${value.id}`);
            console.info(`Row[${index}].name = ${value.name}`);
            console.info(`Row[${index}].age = ${value.age}`);
            console.info(`Row[${index}].salary = ${value.salary}`);
            index++;
          }
          await taskpool.execute(deleteStore, context);
        })
    }
    .height('100%')
    .width('100%')
  }
}

// [End complex_class_instance_object_using_sendable]