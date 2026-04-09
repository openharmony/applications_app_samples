/**
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

import { Context } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import Logger from '../common/Logger';
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { PhotoModel } from '../models/PhotoModel';
import { dfsManager } from './DfsManager';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { taskpool } from '@kit.ArkTS';
import { deleteDfsPhoto } from './loader/MediaTasks';

const TAG = 'RdbManager';
const DB_NAME = 'dfs_photo.db';
const ID_PHOTO_KEY = 'ID';
const REMOTE_URI_PHOTO_KEY = 'REMOTE_URI';
const PHOTO_TYPE_PHOTO_KEY = 'PHOTO_TYPE';
const DISPLAY_NAME_PHOTO_KEY = 'DISPLAY_NAME';
const DATE_ADDED_PHOTO_KEY = 'DATE_ADDED';
const DATE_TRASHED_PHOTO_KEY = 'DATE_TRASHED';
const DURATION_PHOTO_KEY = 'DURATION';

export const PHOTO_TABLE_NAME = 'photo';

export const URI_PHOTO_KEY = 'URI';

export const STORE_CONFIG: relationalStore.StoreConfig = {
  name: DB_NAME,
  securityLevel: relationalStore.SecurityLevel.S1
};

@Observed
class RdbManager {
  private store: relationalStore.RdbStore | undefined = undefined;
  private photoTableColumns: string[] =
    [ID_PHOTO_KEY, URI_PHOTO_KEY, REMOTE_URI_PHOTO_KEY, PHOTO_TYPE_PHOTO_KEY,
      DISPLAY_NAME_PHOTO_KEY, DATE_ADDED_PHOTO_KEY, DATE_TRASHED_PHOTO_KEY, DURATION_PHOTO_KEY];
  availableDeviceList: distributedDeviceManager.DeviceBasicInfo[] = []

  async init(context: Context) {
    try {
      let rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
      if (!rdbStore) {
        Logger.error(TAG, `Get RdbStore failed , rdbStore is error`);
        return;
      }
      this.store = rdbStore;
      Logger.info(TAG, 'Get RdbStore successfully.')
    } catch (error) {
      Logger.error(TAG, `Get RdbStore failed, err is ${error}`);
    }
  }

  // 创建分布式数据库
  creatDfsDB() {
    if (!this.store) {
      Logger.error(TAG, `creatDfsDB failed, rdb store is error`);
      return;
    }

    // 照片表
    this.store.executeSql(`CREATE TABLE IF NOT EXISTS ${PHOTO_TABLE_NAME} (ID INTEGER PRIMARY KEY AUTOINCREMENT,URI TEXT UNIQUE NOT NULL, REMOTE_URI TEXT, PHOTO_TYPE INTEGER, DISPLAY_NAME TEXT, DATE_ADDED INTEGER ,DATE_TRASHED INTEGER,DURATION INTEGER)`,
      (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `create table PHOTOS failed, err = ${err}`)
          return;
        }
        Logger.info(TAG, `create table photo success`)
        // 设置分布式同步表。
        if (!this.store) {
          Logger.error(TAG, `rdb store is error`);
          return;
        }
        this.store.setDistributedTables([PHOTO_TABLE_NAME]);
      })
  }

  async insertDfsPhotoData(context: Context, photos: PhotoModel[]) {
    if (!this.store) {
      Logger.error(TAG, `rdb store is error`);
      return;
    }
    for (let i = 0; i < photos.length; i++) {
      let isExist = await this.isPhotoDataExist(photos[i].uri);
      if (!isExist) {
        let remoteUri = photos[i].remoteUri;
        if (remoteUri) {
          try {
            let valueBucket = this.putPhotoDataToValueBucket(photos[i]);
            let result = await this.store.insert(PHOTO_TABLE_NAME, valueBucket);
            dfsManager.copyFileToDfsDir(photos[i].uri, remoteUri, context);
            Logger.info(TAG, `insertDfsPhotoData success ${result}`);
          } catch (err) {
            Logger.error(TAG, `insertDfsPhotoData failed, err = ${err}`);
          }
        } else {
          Logger.error(TAG, `insertDfsPhotoData failed, remoteUri is error`);
        }
      }
    }
  }

  putPhotoDataToValueBucket(item: PhotoModel) {
    let thumbnail = item.thumbnail;
    if (thumbnail) {
      let bufferArray = new ArrayBuffer(thumbnail.getPixelBytesNumber());
      thumbnail.readPixelsToBufferSync(bufferArray);
      const valueBucket: ValuesBucket = {
        'URI': item.uri,
        'DISPLAY_NAME': item.displayName,
        'DATE_ADDED': item.dateAdded,
        'DATE_TRASHED': item.dateTrashed ?? 0,
        'PHOTO_TYPE': item.photoType ?? 1,
        'REMOTE_URI': item.remoteUri ?? '',
        'THUMBNAIL': new Uint8Array(bufferArray),
        'DURATION': item.duration ?? 0,
      };
      return valueBucket;
    } else {
      const valueBucket: ValuesBucket = {
        'URI': item.uri,
        'DISPLAY_NAME': item.displayName,
        'DATE_ADDED': item.dateAdded,
        'DATE_TRASHED': item.dateTrashed ?? 0,
        'PHOTO_TYPE': item.photoType ?? 1,
        'REMOTE_URI': item.remoteUri ?? '',
        'DURATION': item.duration ?? 0,
      };
      return valueBucket;
    }
  }

  isPhotoDataExist(uri: string): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      if (!this.store) {
        Logger.error(TAG, `rdb store is error`);
        resolve(false);
      }
      try {
        this.store?.querySql(`SELECT * FROM ${PHOTO_TABLE_NAME} WHERE ${URI_PHOTO_KEY} = '${uri}'`,
          (err: BusinessError, resultSet: relationalStore.ResultSet) => {
            if (err) {
              Logger.error(`Failed to remoteQuery data. Code:${err.code},message:${err.message}`);
              resolve(false);
            }
            Logger.info(`ResultSet isAtLastRow: ${resultSet.rowCount}`);
            if (resultSet.rowCount <= 0) {
              resolve(false);
            } else {
              resolve(true);
            }
            // 释放数据集的内存
            resultSet.close();
          }
        )
      } catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        Logger.error("queryTest errCode:" + code + ",errMessage:" + message);
        resolve(false);
      }
    })
  }

  async queryDfsPhotoData(deviceId: string): Promise<PhotoModel[]> {
    let photoList: PhotoModel[] = [];
    if (!this.store) {
      Logger.error(TAG, `rdb store is error`);
      return photoList;
    }
    try {
      // 构造用于查询分布式表的谓词对象
      let predicates = new relationalStore.RdbPredicates(PHOTO_TABLE_NAME);
      // 调用跨设备查询接口，并返回查询结果
      let resultSet = await this.store.remoteQuery(deviceId, PHOTO_TABLE_NAME, predicates, this.photoTableColumns);
      if (resultSet) {
        Logger.error(TAG,`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
        while (resultSet.goToNextRow()) {
          const uri = resultSet.getString(resultSet.getColumnIndex(URI_PHOTO_KEY));
          const remoteUri = resultSet.getString(resultSet.getColumnIndex(REMOTE_URI_PHOTO_KEY));
          const photoType = resultSet.getLong(resultSet.getColumnIndex(PHOTO_TYPE_PHOTO_KEY));
          const name = resultSet.getString(resultSet.getColumnIndex(DISPLAY_NAME_PHOTO_KEY));
          const dateAdded = resultSet.getLong(resultSet.getColumnIndex(DATE_ADDED_PHOTO_KEY));
          const dateTrashed = resultSet.getLong(resultSet.getColumnIndex(DATE_TRASHED_PHOTO_KEY));
          const duration = photoType == photoAccessHelper.PhotoType.VIDEO ?
          resultSet.getLong(resultSet.getColumnIndex(DURATION_PHOTO_KEY)) : 0
          let tmp: PhotoModel = {
            uri: uri,
            displayName: name,
            dateAdded: dateAdded,
            remoteUri: remoteUri,
            photoType: photoType,
            dateTrashed: dateTrashed,
            duration: duration,
            width: 0,
            height: 0,
            imageUri: ''
          }
          photoList.push(tmp);
        }
        // 释放数据集的内存，若不释放可能会引起fd泄露与内存泄露
        resultSet.close();
      }
    } catch (err) {
      Logger.error(TAG, `queryDfsPhotoData is failed, err = ${err}`);
    }
    return photoList;
  }

  async deleteDfsPhotoData(context: Context, photos: PhotoModel[]) {
    if (!this.store) {
      Logger.error(TAG, `rdb store is error`);
      return;
    }
    const deleteUris: string[] = photos.map(item => item.uri);
    // 采用多线程删除
    const task = new taskpool.Task(deleteDfsPhoto, context, deleteUris);
    await taskpool.execute(task);
  }

  syncRemoteData() {
    if (!this.store) {
      Logger.error(TAG, `rdb store is error`);
      return;
    }
    let predicates = new relationalStore.RdbPredicates(PHOTO_TABLE_NAME);
    // 调用同步数据的接口
    this.store.sync(relationalStore.SyncMode.SYNC_MODE_PUSH, predicates, (err, result) => {
      // 判断数据同步是否成功
      if (err) {
        Logger.error(TAG, `Failed to sync data. Code:${err.code},message:${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in syncing data.');
    })
  }

  registerRemoteDataChange(observer: Callback<Array<string>>) {
    if (!this.store) {
      Logger.error(TAG, `rdb store is error`);
      return;
    }
    try {
      // 调用分布式数据订阅接口，注册数据库的观察者
      // 当分布式数据库中的数据发生更改时，将调用回调
      this.store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_REMOTE, observer);
    } catch (err) {
      Logger.error(TAG, `Failed to register observer. Code:${err.code},message:${err.message}`);
    }
  }

  unregisterRemoteDataChange() {
    if (!this.store) {
      Logger.error(TAG, `rdb store is error`);
      return;
    }
    // 当前不需要订阅数据变化时，可以将其取消。
    try {
      this.store.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_REMOTE,
        (storeObserver) => {
        });
    } catch (err) {
      Logger.error(TAG, `Failed to unregister observer. Code:${err.code},message:${err.message}`);
    }
  }
}

export let rdbManager = new RdbManager();
