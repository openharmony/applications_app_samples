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
import { relationalStore } from '@kit.ArkData'; // 导入模块
import { BusinessError } from '@kit.BasicServicesKit';


// [Start vector_TS_getStore]
let store: relationalStore.RdbStore | undefined = undefined;
let context = getContext();
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'VectorTest.db', // 数据库文件名
  securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
  vector: true // 可选参数，该参数为true时才可以使用向量数据库。
};
// [StartExclude vector_TS_getStore]

export async function getVectorStore() {
  // [Start vector_TS_isVectorSupported]
  // 判断当前系统是否支持向量数据库
  let ret = relationalStore.isVectorSupported();
  if (!ret) {
    console.error(`vectorDB is not supported.`);
    return;
  }
  // [End vector_TS_isVectorSupported]
  // [EndExclude  vector_TS_getStore]
  relationalStore.getRdbStore(context, STORE_CONFIG).then(async (rdbStore: relationalStore.RdbStore) => {
    store = rdbStore;
    // 建表语句，floatvector(2)代表repr的维度是2
    const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, repr floatvector(2));';
    // 第二个入参表示不开启显示事务，第三个参数undefined表示未使用参数绑定
    await store!.execute(SQL_CREATE_TABLE, 0, undefined);
  }).catch((err: BusinessError) => {
    console.error(`Get RdbStore failed, code is ${err.code}, message is ${err.message}`);
  });
  // [End vector_TS_getStore]

  // [Start vector_TS_execute_insert]
  try {
    // 使用参数绑定
    const vectorValue: Float32Array = Float32Array.from([1.2, 2.3]);
    await store!.execute('insert into test VALUES(?, ?);', 0, [0, vectorValue]);
    // 不使用参数绑定
    await store!.execute("insert into test VALUES(1, '[1.3, 2.4]');", 0, undefined);
  } catch (err) {
    console.error(`execute insert failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_execute_insert]

  // [Start vector_TS_execute_update_and_delete]
  // 修改数据
  try {
    // 使用参数绑定
    const vectorValue1: Float32Array = Float32Array.from([2.1, 3.2]);
    await store!.execute('update test set repr = ? where id = ?', 0, [vectorValue1, 0]);
    // 不使用参数绑定
    await store!.execute("update test set repr = '[5.1, 6.1]' where id = 0", 0, undefined);
  } catch (err) {
    console.error(`execute update failed, code is ${err.code}, message is ${err.message}`);
  }

  // 删除数据
  try {
    // 使用参数绑定
    await store!.execute('delete from test where id = ?', 0, [0]);
    // 不使用参数绑定
    await store!.execute('delete from test where id = 0', 0, undefined);
  } catch (err) {
    console.error(`execute delete failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_execute_update_and_delete]

  // [Start vector_TS_query]
  // 单表查询
  try {
    // 使用参数绑定
    const QUERY_SQL = 'select id, repr <-> ? as distance from test where id > ? order by repr <-> ? limit 5;';
    const vectorValue2: Float32Array = Float32Array.from([6.2, 7.3]);
    let resultSet = await store!.querySql(QUERY_SQL, [vectorValue2, 0, vectorValue2]);
    while (resultSet!.goToNextRow()) {
      let id = resultSet.getValue(0);
      let dis = resultSet.getValue(1);
    }
    resultSet!.close();

    // 不使用参数绑定
    const QUERY_SQL1 = "select id, repr <-> '[6.2, 7.3]' as distance from test where id > 0 order by repr <-> '[6.2, 7.3]' limit 5;";
    resultSet = await store!.querySql(QUERY_SQL1);
    resultSet!.close();
  } catch (err) {
    console.error(`query failed, code is ${err.code}, message is ${err.message}`);
  }

  // 子查询
  try {
    // 创建第二张表
    let CREATE_SQL = 'CREATE TABLE IF NOT EXISTS test1(id text PRIMARY KEY);';
    await store!.execute(CREATE_SQL);
    let resultSet = await store!.querySql('select * from test where id in (select id from test1);');
    resultSet!.close();
  } catch (err) {
    console.error(`query failed, code is ${err.code}, message is ${err.message}`);
  }

  // 聚合查询
  try {
    let resultSet = await store!.querySql("select * from test where repr <-> '[1.0, 1.0]' > 0 group by id having max(repr <=> '[1.0, 1.0]');");
    resultSet!.close();
  } catch (err) {
    console.error(`query failed, code is ${err.code}, message is ${err.message}`);
  }

  // 多表查询
  try {
    // union all与union的区别在于union会将数据去重
    let resultSet = await store!.querySql("select id, repr <-> '[1.5, 5.6]' as distance from test union select id, repr <-> '[1.5, 5.6]' as distance from test order by distance limit 5;");
    resultSet!.close();
  } catch (err) {
    console.error(`query failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_query]

  // [Start vector_TS_execute_create_view]
  // 视图查询
  try {
    // 创建视图
    await store!.execute('CREATE VIEW v1 as select * from test where id > 0;');
    let resultSet = await store!.querySql('select * from v1;');
    resultSet!.close();
  } catch (err) {
    console.error(`query failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_execute_create_view]

  // [Start vector_TS_execute_create_index]
  // 基础用法
  try {
    // 创建的索引名称为diskann_l2_idx，索引列为repr，类型为gsdiskann，距离度量类型为L2
    await store!.execute('CREATE INDEX diskann_l2_idx ON test USING GSDISKANN(repr L2);');
    // 删除表test中的diskann_l2_idx索引
    await store!.execute('DROP INDEX test.diskann_l2_idx;');
  } catch (err) {
    console.error(`create index failed, code is ${err.code}, message is ${err.message}`);
  }

  // 扩展语法
  try {
    // 设置QUEUE_SIZE为20，OUT_DEGREE为50
    await store!.execute('CREATE INDEX diskann_l2_idx ON test USING GSDISKANN(repr L2) WITH (queue_size=20, out_degree=50);');
  } catch (err) {
    console.error(`create ext index failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_execute_create_index]

  // [Start vector_TS_execute_gsdiskann]
  try {
    // 手动触发异步删除整理，对向量数据库下所有gsdiskann执行磁盘碎片回收
    await store!.execute('PRAGMA DISKANN_ASYNC_COLLECTING;');
  } catch (err) {
    console.error(`diskann async collecting failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_execute_gsdiskann]

  // [Start vector_TS_execute_dataAging]
  try {
    // content列配置了数据压缩，并且配置了数据老化。
    await store!.execute("CREATE TABLE IF NOT EXISTS test3 (time integer not null, content text) with (time_col = 'time', interval = '5 minute', compress_col = 'content');");
  } catch (err) {
    console.error(`configure data compress failed, code is ${err.code}, message is ${err.message}`);
  }
  // [End vector_TS_execute_dataAging]

  // [Start vector_TS_deleteStore]
  try {
    // 删除数据库前，需要先将store对象关闭，否则会导致下一次调用getRdbStore接口创建数据库失败
    await store!.close();
    await relationalStore.deleteRdbStore(context, STORE_CONFIG);
  } catch (err) {
    console.error(`delete rdbStore failed, code is ${err.code},message is ${err.message}`);
  }
  // [End vector_TS_deleteStore]
}