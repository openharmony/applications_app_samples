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

import { dataShare } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

// [Start publish_shared_config]
function publishSharedConfig() {
  dataShare.createDataProxyHandle().then((dataProxyHandle) => {
    const newConfigData: dataShare.ProxyData[] = [
      {
        uri: 'datashareproxy://com.samples.shareconfig/config1',
        value: 'Value1',
        allowList: [
          'appIdentifier1',
          'appIdentifier2'
        ]
      },
      {
        uri: 'datashareproxy://com.samples.shareconfig/config2',
        value: 'Value2',
        allowList: [
          'appIdentifier3',
          'appIdentifier4'
        ]
      }
    ];
    const config: dataShare.DataProxyConfig = {
      type: dataShare.DataProxyType.SHARED_CONFIG,
    };
    dataProxyHandle.publish(newConfigData, config).then((results: dataShare.DataProxyResult[]) => {
      results.forEach((result) => {
        console.info(`URI: ${result.uri}, Result: ${result.result}`);
      });
    }).catch((error: BusinessError) => {
      console.error('Error publishing config:', error);
    });
  }).catch((error: BusinessError) => {
    console.error('Error creating DataProxyHandle:', error);
  });
}

// [End publish_shared_config]

// [Start delete_shared_config]
function deleteSharedConfig() {
  dataShare.createDataProxyHandle().then((dataProxyHandle) => {
    const urisToDelete: string[] = [
      'datashareproxy://com.samples.shareconfig/config1',
      'datashareproxy://com.samples.shareconfig/config2'
    ];
    const config: dataShare.DataProxyConfig = {
      type: dataShare.DataProxyType.SHARED_CONFIG,
    };
    dataProxyHandle.delete(urisToDelete, config).then((results: dataShare.DataProxyResult[]) => {
      results.forEach((result) => {
        console.info(`URI: ${result.uri}, Result: ${result.result}`);
      });
    }).catch((error: BusinessError) => {
      console.error('Error deleting config:', error);
    });
  }).catch((error: BusinessError) => {
    console.error('Error creating DataProxyHandle:', error);
  });
}

// [End delete_shared_config]

// [Start get_shared_config]
function getSharedConfig() {
  dataShare.createDataProxyHandle().then((dataProxyHandle) => {
    const urisToGet: string[] = [
      'datashareproxy://com.samples.shareconfig/config1',
      'datashareproxy://com.samples.shareconfig/config2'
    ];
    const config: dataShare.DataProxyConfig = {
      type: dataShare.DataProxyType.SHARED_CONFIG,
    };
    dataProxyHandle.get(urisToGet, config).then((results: dataShare.DataProxyGetResult[]) => {
      results.forEach((result) => {
        console.info(`URI: ${result.uri}, Result: ${result.result}, AllowList: ${result.allowList}`);
      });
    }).catch((error: BusinessError) => {
      console.error('Error getting config:', error);
    });
  }).catch((error: BusinessError) => {
    console.error('Error creating DataProxyHandle:', error);
  });
}

// [End get_shared_config]

// [Start watch_shared_config]
function watchConfigChanges() {
  dataShare.createDataProxyHandle().then((dsProxyHelper) => {
    const uris: string[] = [
      'datashareproxy://com.samples.shareconfig/config1',
      'datashareproxy://com.samples.shareconfig/config2'
    ];
    const config: dataShare.DataProxyConfig = {
      type: dataShare.DataProxyType.SHARED_CONFIG,
    };
    const callback = (err: BusinessError<void>, changes: dataShare.DataProxyChangeInfo[]): void => {
      if (err) {
        console.error('err:', err);
      } else {
        changes.forEach((change) => {
          console.info(`Change Type: ${change.type}, URI: ${change.uri}, Value: ${change.value}`);
        });
      }
    };
    // 监听配置变化
    const listenResults: dataShare.DataProxyResult[] = dsProxyHelper.on('dataChange', uris, config, callback);
    listenResults.forEach((result) => {
      console.info(`URI: ${result.uri}, Result: ${result.result}`);
    });
    // 取消监听配置变化
    const unListenResults: dataShare.DataProxyResult[] = dsProxyHelper.off('dataChange', uris, config, callback);
    unListenResults.forEach((result) => {
      console.info(`URI: ${result.uri}, Result: ${result.result}`);
    });
  }).catch((error: BusinessError) => {
    console.error('Error creating DataProxyHandle:', error);
  });
}

// [End watch_shared_config]


@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Column() {
      TextArea({
        text: this.message,
        placeholder: '',
      })
        .width('100%')
        .height('50%');
      Row() {
        Button($r('app.string.publishSharedConfig'))
          .onClick(() => {
            publishSharedConfig();
            console.info('publishSharedConfig SUCCESS');
            this.message += 'publishSharedConfig SUCCESS' + '\n';
          })
          .margin({ top: 20 })
          .width('60%');
      };

      Row() {
        Button($r('app.string.deleteSharedConfig'))
          .onClick(() => {
            deleteSharedConfig();
            console.info('deleteSharedConfig SUCCESS');
            this.message += 'deleteSharedConfig SUCCESS' + '\n';
          })
          .margin({ top: 20 })
          .width('60%');
      };

      Row() {
        Button($r('app.string.getSharedConfig'))
          .onClick(() => {
            getSharedConfig();
            console.info('getSharedConfig SUCCESS');
            this.message += 'getSharedConfig SUCCESS' + '\n';
          })
          .margin({ top: 20 })
          .width('60%');
      };

      Row() {
        Button($r('app.string.watchConfigChanges'))
          .onClick(() => {
            watchConfigChanges();
            console.info('watchConfigChanges SUCCESS');
            this.message += 'watchConfigChanges SUCCESS' + '\n';
          })
          .margin({ top: 20 })
          .width('60%');
      };
    };
  }
}