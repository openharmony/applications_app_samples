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

// [Start rdb_EntryAbility]
import { AbilityConstant, contextConstant, UIAbility, Want, application } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';
import { ECStoreManager } from '../encryptedEStoreGuidelines/ECStoreManager';
import { StoreInfo } from '../encryptedEStoreGuidelines/Store';
import { Mover } from '../encryptedEStoreGuidelines/Mover';
import { SecretKeyObserver } from '../encryptedEStoreGuidelines/SecretKeyObserver';
import { commonEventManager } from '@kit.BasicServicesKit';
import { BusinessError } from '@kit.BasicServicesKit';

export let storeManager = new ECStoreManager();
export let e_secretKeyObserver = new SecretKeyObserver();
let mover = new Mover();
let subscriber: commonEventManager.CommonEventSubscriber;

export function createCB(err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) {
  if (!err) {
    console.info('ECDB_Encrypt createSubscriber');
    subscriber = commonEventSubscriber;
    try {
      commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          console.error(`subscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          console.info(`ECDB_Encrypt SubscribeCB ${data.code}`);
          e_secretKeyObserver.updateLockStatus(data.code);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`subscribe failed, code is ${err.code}, message is ${err.message}`);
    }
  } else {
    console.error(`createSubscriber failed, code is ${err.code}, message is ${err.message}`);
  }
}

let cInfo: StoreInfo | null = null;
let eInfo: StoreInfo | null = null;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let cContext = this.context;
    cInfo = {
      context: cContext,
      config: {
        name: 'cstore.db',
        securityLevel: relationalStore.SecurityLevel.S3,
      },
      storeId: 'cstore.db'
    };
    let eContext = await application.createModuleContext(this.context, "entry");
    eContext.area = contextConstant.AreaMode.EL5;
    eInfo = {
      context: eContext,
      config: {
        name: 'estore.db',
        securityLevel: relationalStore.SecurityLevel.S3,
      },
      storeId: 'estore.db',
    };
    // 监听COMMON_EVENT_SCREEN_LOCK_FILE_ACCESS_STATE_CHANGED事件 code == 1解锁状态，code==0加锁状态
    console.info(`ECDB_Encry store area : estore:${eContext.area},cstore${cContext.area}`)
    try {
      commonEventManager.createSubscriber({
        events: ['COMMON_EVENT_SCREEN_LOCK_FILE_ACCESS_STATE_CHANGED']
      }, createCB);
      console.info(`ECDB_Encry success subscribe`);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`createSubscriber failed, code is ${err.code}, message is ${err.message}`);
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
// [End rdb_EntryAbility]