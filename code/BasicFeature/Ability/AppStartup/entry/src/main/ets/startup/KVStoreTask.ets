import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';

import { BusinessError } from '@ohos.base';
import { SingleKVStoreUtil } from '../util/SingleKVStore';
import distributedKVStore from '@ohos.data.distributedKVStore';

@Sendable
export default class KVStoreTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    try {
      SingleKVStoreUtil.getKVStore()
        .then((kvStore: distributedKVStore.SingleKVStore) => {
          const KEY_TEST_STRING_ELEMENT = 'key_test_string';
          const VALUE_TEST_STRING_ELEMENT = 'value_test_string';
          kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
            if (err !== undefined) {
              console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
              return;
            }
            console.info('Succeeded in putting data.');
          });
        }).catch((err: BusinessError) => {
        console.error(`Failed to create KVManager.message:${err}`);
      });

    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }
  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}