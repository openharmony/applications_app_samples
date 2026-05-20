import distributedKVStore from '@ohos.data.distributedKVStore';
import { BusinessError } from '@ohos.base';
import LogManager from '../Log/LogManager';


const TAG = 'kvManagerService'


export default class kvManagerService {
  static kvManager: distributedKVStore.KVManager | undefined = undefined;
  static kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

  static createKV(context: Context, bundleName: string) {
    const kvManagerConfig: distributedKVStore.KVManagerConfig = {
      context,
      bundleName
    };
    try {
      // 创建KVManager实例
      kvManagerService.kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      LogManager.hilogIWithTag(TAG, `Succeeded in creating KVManager`)
    } catch (e) {
      let error = e as BusinessError;
      LogManager.hilogIWithTag(TAG, `Failed to create KVManager. Code:${error.code},message:${error.message}`)
    }
  }

  static createStore(storeId: string) {
    if (kvManagerService.kvManager !== undefined) {
      try {
        const options: distributedKVStore.Options = {
          createIfMissing: true,
          encrypt: false,
          backup: false,
          autoSync: false,
          // kvStoreType不填时，默认创建多设备协同数据库
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
          // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
          securityLevel: distributedKVStore.SecurityLevel.S1
        };
        kvManagerService.kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeId, options, (err: BusinessError, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            LogManager.hilogIWithTag(TAG, `Failed to get KVStore: Code:${err.code},message:${err.message}`)
            return;
          }
          LogManager.hilogIWithTag(TAG, `Succeeded in getting KVStore.`)

          kvManagerService.kvStore = store;
        });
      } catch (e) {
        let error = e as BusinessError;
        LogManager.hilogIWithTag(TAG, `An unexpected error occurred. Code:${error.code},message:${error.message}`)
      }
    }
  }

  static getValue(key: string, callBack: (val: string) => void) {
    if (kvManagerService.kvStore !== undefined) {
      kvManagerService.kvStore.get(key, (err: BusinessError, data: string | number | boolean | Uint8Array) => {
        if (err != undefined) {
          LogManager.hilogIWithTag(TAG, `Failed to get data. Code:${err.code},message:${err.message}`);
          callBack('[]')
          return;
        }
        LogManager.hilogIWithTag(TAG, `Succeeded in getting data. Data:${data}`);
        if (typeof (data) === 'string') {
          callBack(data)
        }
      });
    }
  }

  static putValue(key: string, value: string) {
    if (kvManagerService.kvStore !== undefined) {
      try {
        kvManagerService.kvStore.put(key, value, (err: BusinessError) => {
          if (err !== undefined) {
            LogManager.hilogIWithTag(TAG, `Failed to put data. Code:${err.code},message:${err.message}`);

            return;
          }
          LogManager.hilogIWithTag(TAG, `Succeeded in putting data.` + value);

        });
      } catch (e) {
        let error = e as BusinessError;
        LogManager.hilogIWithTag(TAG, `Failed to get data. Code:${error.code},message:${error.message}`);
      }
    }
  }

  static deleteValue(key: string) {
    if (kvManagerService.kvStore !== undefined) {
      kvManagerService.kvStore.delete(key, (err: BusinessError) => {
        if (err !== undefined) {
          LogManager.hilogIWithTag(TAG, `Failed to delete data. Code:${err.code},message:${err.message}`);
          return;
        }
        LogManager.hilogIWithTag(TAG, `Succeeded in deleting data.`);
      });
    }

  }
}