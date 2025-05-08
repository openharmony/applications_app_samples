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

// [Start operate_child_thread_data]
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function create(context: Context) {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + rdb + StoreConfig.name
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);
  console.info(`Create Store.db successfully!`);

  // 创建表
  const CREATE_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS test (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name TEXT NOT NULL, ' +
    'age INTEGER, ' +
    'salary REAL, ' +
    'blobType BLOB)';
  await store.executeSql(CREATE_TABLE_SQL);
  console.info(`Create table test successfully!`);
}

@Concurrent
async function insert(context: Context, valueBucketArray: Array<relationalStore.ValuesBucket>) {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + rdb + StoreConfig.name
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);
  console.info(`Create Store.db successfully!`);

  // 数据插入
  await store.batchInsert('test', valueBucketArray as Object as Array<relationalStore.ValuesBucket>);
}

@Concurrent
async function query(context: Context): Promise<Array<relationalStore.ValuesBucket>> {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + rdb + StoreConfig.name
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);
  console.info(`Create Store.db successfully!`);

  // 获取结果集
  let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('test');
  let resultSet = await store.query(predicates); // 查询所有数据
  console.info(`Query data successfully! row count:${resultSet.rowCount}`);
  let index = 0;
  let result = new Array<relationalStore.ValuesBucket>(resultSet.rowCount)
  resultSet.goToFirstRow()
  do {
    result[index++] = resultSet.getRow();
  } while (resultSet.goToNextRow());
  resultSet.close();
  return result;
}

@Concurrent
async function clear(context: Context) {
  const CONFIG: relationalStore.StoreConfig = {
    name: 'Store.db',
    securityLevel: relationalStore.SecurityLevel.S1,
  };

  // 默认数据库文件路径为 context.databaseDir + rdb + StoreConfig.name
  await relationalStore.deleteRdbStore(context, CONFIG);
  console.info(`Delete Store.db successfully!`);
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
          let context = getContext(this);

          // 数据准备
          const count = 5
          let valueBucketArray = new Array<relationalStore.ValuesBucket>(count);
          for (let i = 0; i < count; i++) {
            let v: relationalStore.ValuesBucket = {
              id: i,
              name: 'zhangsan' + i,
              age: 20,
              salary: 5000 + 50 * i
            };
            valueBucketArray[i] = v;
          }
          await taskpool.execute(create, context);
          await taskpool.execute(insert, context, valueBucketArray);
          let index = 0;
          let ret = await taskpool.execute(query, context) as Array<relationalStore.ValuesBucket>;
          for (let v of ret) {
            console.info(`Row[${index}].id = ${v.id}`)
            console.info(`Row[${index}].name = ${v.name}`)
            console.info(`Row[${index}].age = ${v.age}`)
            console.info(`Row[${index}].salary = ${v.salary}`)
            index++
          };
          await taskpool.execute(clear, context);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End operate_child_thread_data]
