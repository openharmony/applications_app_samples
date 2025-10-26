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

// [Start EntryAbility]
import { AbilityConstant, application, contextConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { distributedKVStore } from '@kit.ArkData';
import { ECStoreManager } from './ECStoreManager';
import { StoreInfo } from './Store';
import { Mover } from './Mover';
import { SecretKeyObserver } from './SecretKeyObserver';
import { commonEventManager } from '@kit.BasicServicesKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';

export let storeManager = new ECStoreManager();
export let e_secretKeyObserver = new SecretKeyObserver();
let mover = new Mover();
let subscriber: commonEventManager.CommonEventSubscriber;

export function createCB(err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) {
  if (!err) {
    Logger.info('ECDB_Encry createSubscriber');
    subscriber = commonEventSubscriber;
    try {
      commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          Logger.error(`subscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          Logger.info(`ECDB_Encry SubscribeCB ${data.code}`);
          e_secretKeyObserver.updateLockStatus(data.code);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`subscribe failed, code is ${err.code}, message is ${err.message}`);
    }
  } else {
    Logger.error(`createSubscriber failed, code is ${err.code}, message is ${err.message}`);
  }
}

let cInfo: StoreInfo | null = null;
let eInfo: StoreInfo | null = null;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let cContext = this.context;
    cInfo = {
      'kvManagerConfig': {
        context: cContext,
        bundleName: 'com.example.ecstoresamples'
      },
      'storeId': 'cstore',
      'option': {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: false,
        // kvStoreType不填时，默认创建多设备协同数据库
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION
        securityLevel: distributedKVStore.SecurityLevel.S3
      }
    }
    let eContext = await application.createModuleContext(this.context,'entry');
    eContext.area = contextConstant.AreaMode.EL5;
    eInfo = {
      'kvManagerConfig': {
        context: eContext,
        bundleName: 'com.example.ecstoresamples'
      },
      'storeId': 'estore',
      'option': {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: false,
        // kvStoreType不填时，默认创建多设备协同数据库
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION
        securityLevel: distributedKVStore.SecurityLevel.S3
      }
    }
    Logger.info(`ECDB_Encry store area : estore:${eContext.area},cstore${cContext.area}`);
    // 监听COMMON_EVENT_SCREEN_LOCK_FILE_ACCESS_STATE_CHANGED事件 code == 1解锁状态，code==0加锁状态
    try {
      commonEventManager.createSubscriber({
        events: [ 'COMMON_EVENT_SCREEN_LOCK_FILE_ACCESS_STATE_CHANGED' ]
      }, createCB);
      Logger.info(`ECDB_Encry success subscribe`);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`createSubscriber failed, code is ${err.code}, message is ${err.message}`);
    }
    storeManager.config(cInfo, eInfo);
    storeManager.configDataMover(mover);
    e_secretKeyObserver.initialize(storeManager);
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
// [End EntryAbility]