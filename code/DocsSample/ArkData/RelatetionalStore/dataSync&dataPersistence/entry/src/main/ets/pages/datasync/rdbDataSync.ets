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

// [Start sync_import]
import { relationalStore } from '@kit.ArkData'; // 导入模块
import { BusinessError } from '@kit.BasicServicesKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0000;
// [End sync_import]

// [Start setDistributedTables]
let context = getContext();
let store: relationalStore.RdbStore | undefined = undefined;
// [StartExclude setDistributedTables]
export async function rdbDataSync() {
  // [EndExclude setDistributedTables]
  const STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'RdbTest.db', // 数据库文件名
    securityLevel: relationalStore.SecurityLevel.S3 // 数据库安全级别
  };
  // 打开数据库并设置分布式表
  relationalStore.getRdbStore(context, STORE_CONFIG).then(async (rdbStore: relationalStore.RdbStore) => {
    store = rdbStore;
    await store.executeSql('CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)');
    // 将已创建的表设置分布式表。
    await store.setDistributedTables(['EMPLOYEE']);
  }).catch((err: BusinessError) => {
    hilog.error(DOMAIN, "rdbDataSync", `Get RdbStore failed, code is ${err.code}, message is ${err.message}`);
  });
  // [End setDistributedTables]

  // [Start on_data_change]
  // 订阅组网内其他设备的数据变化消息
  if (store) {
    try {
      // 查询组网内的设备列表
      const deviceManager = distributedDeviceManager.createDeviceManager('com.example.rdbDataSync');
      const deviceList = deviceManager.getAvailableDeviceListSync();
      const devices: string[] = [];
      deviceList.forEach(item => {
        if (item.networkId) {
          devices.push(item.networkId);
        }
      });
      // 调用分布式数据订阅接口，注册数据库的观察者
      // 当分布式数据库中的数据发生更改时，将调用回调
      store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_REMOTE, async (devices) => {
        for (let i = 0; i < devices.length; i++) {
          let device = devices[i];
          if (!store) {
            return;
          }
          hilog.info(DOMAIN, "rdbDataSync", `The data of device:${device} has been changed.`);
          // 获取device对应的分布式表名。
          const distributedTableName = await store.obtainDistributedTableName(device, 'EMPLOYEE');
          // 创建查询谓词，查询组网内设备分布式表的数据
          const predicates = new relationalStore.RdbPredicates(distributedTableName);
          const resultSet = await store.query(predicates);
          hilog.info(DOMAIN, "rdbDataSync", `device ${device}, table EMPLOYEE rowCount is: ${resultSet.rowCount}`);
        }
      });
    } catch (err) {
      hilog.error(DOMAIN, "rdbDataSync", `Failed to register observer. Code:${err.code},message:${err.message}`);
    }
  }
  // [End on_data_change]

  // [Start data_sync_push]
  // 同步当前设备数据变化至组网内其他设备
  if (store) {
    // 当前设备分布式数据表中插入新数据
    const ret = store.insertSync('EMPLOYEE', {
      name: 'sync_me',
      age: 18,
      salary: 666
    });
    hilog.info(DOMAIN, "rdbDataSync", 'Insert to distributed table EMPLOYEE, result: ' + ret);
    // 查询组网内的设备列表
    const deviceManager = distributedDeviceManager.createDeviceManager('com.example.rdbDataSync');
    const deviceList = deviceManager.getAvailableDeviceListSync();
    const syncTarget: string[] = [];
    deviceList.forEach(item => {
      if (item.networkId) {
        syncTarget.push(item.networkId);
      }
    });
    if (syncTarget.length === 0) {
      hilog.error(DOMAIN, "rdbDataSync", 'no device to sync');
    } else {
      // 构造用于同步分布式表的谓词对象
      const predicates = new relationalStore.RdbPredicates('EMPLOYEE');
      // 指定要同步的设备列表
      predicates.inDevices(syncTarget);
      try {
        // 调用同步数据的接口推送当前设备数据变化至组网内其他设备
        const result = await store.sync(relationalStore.SyncMode.SYNC_MODE_PUSH, predicates);
        hilog.info(DOMAIN, "rdbDataSync", 'Push data success.');
        // 获取同步结果
        for (let i = 0; i < result.length; i++) {
          const deviceId = result[i][0];
          const syncResult = result[i][1];
          if (syncResult === 0) {
            hilog.info(DOMAIN, "rdbDataSync", `device:${deviceId} sync success`);
          } else {
            hilog.error(DOMAIN, "rdbDataSync", `device:${deviceId} sync failed, status:${syncResult}`);
          }
        }
      } catch (e) {
        hilog.error(DOMAIN, "rdbDataSync", 'Push data failed, code: ' + e.code + ', message: ' + e.message);
      }
    }
  }
  // [End data_sync_push]

  // [Start data_sync_pull]
  // 拉取组网内其他设备的数据变化
  if (store) {
    // 查询组网内的设备列表
    const deviceManager = distributedDeviceManager.createDeviceManager('com.example.rdbDataSync');
    const deviceList = deviceManager.getAvailableDeviceListSync();
    const syncTarget: string[] = [];
    deviceList.forEach(item => {
      if (item.networkId) {
        syncTarget.push(item.networkId);
      }
    });
    if (syncTarget.length === 0) {
      hilog.error(DOMAIN, "rdbDataSync", 'no device to pull data');
    } else {
      // 构造用于同步分布式表的谓词对象
      const predicates = new relationalStore.RdbPredicates('EMPLOYEE');
      // 指定要同步的设备列表
      predicates.inDevices(syncTarget);
      try {
        // 调用同步数据的接口拉取其他设备数据变化至当前设备
        const result = await store.sync(relationalStore.SyncMode.SYNC_MODE_PULL, predicates);
        hilog.info(DOMAIN, "rdbDataSync", 'Pull data success.');
        // 获取同步结果
        for (let i = 0; i < result.length; i++) {
          const deviceId = result[i][0];
          const syncResult = result[i][1];
          if (syncResult === 0) {
            hilog.info(DOMAIN, "rdbDataSync", `device:${deviceId} sync success`);
          } else {
            hilog.error(DOMAIN, "rdbDataSync", `device:${deviceId} sync failed, status:${syncResult}`);
          }
        }
      } catch (e) {
        hilog.error(DOMAIN, "rdbDataSync", 'Pull data failed, code: ' + e.code + ', message: ' + e.message);
      }
    }
  }
  // [End data_sync_pull]

  // [Start data_remote_query]
  // 查询组网内指定设备上分布式表中的数据
  if (store) {
    // 查询组网内的设备列表
    const deviceManager = distributedDeviceManager.createDeviceManager('com.example.rdbDataSync');
    const deviceList = deviceManager.getAvailableDeviceListSync();
    const devices: string[] = [];
    deviceList.forEach(item => {
      if (item.networkId) {
        devices.push(item.networkId);
      }
    });
    if (devices.length === 0) {
      hilog.error(DOMAIN, "rdbDataSync", 'no device to query data');
    } else {
      // 构造用于查询分布式表的谓词对象
      const predicates = new relationalStore.RdbPredicates('EMPLOYEE');
      try {
        // 查询组网内设备上的分布式表
        const resultSet = await store.remoteQuery(devices[0], 'EMPLOYEE', predicates, ['ID', 'NAME', 'AGE', 'SALARY', 'CODES']);
        hilog.info(DOMAIN, "rdbDataSync", `ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
      } catch (e) {
        hilog.error(DOMAIN, "rdbDataSync", 'Remote query failed, code: ' + e.code + ', message: ' + e.message);
      }
    }
  }
  // [End data_remote_query]
}