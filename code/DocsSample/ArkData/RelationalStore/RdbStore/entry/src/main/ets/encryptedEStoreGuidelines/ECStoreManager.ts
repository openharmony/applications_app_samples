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

// [Start rdb_ECStoreManager]
import { relationalStore } from '@kit.ArkData';
import { Mover } from './Mover';
import { BusinessError } from '@kit.BasicServicesKit';
import { StoreInfo, Store } from './Store';
import { SecretStatus } from './SecretKeyObserver';

let store = new Store();

export class ECStoreManager {
  config(cInfo: StoreInfo, other: StoreInfo): void {
    this.cInfo = cInfo;
    this.eInfo = other;
  }

  configDataMover(mover: Mover): void {
    this.mover = mover;
  }

  async getCurrentStore(screenStatus: number): Promise<relationalStore.RdbStore> {
    if (screenStatus === SecretStatus.UnLock) {
      try {
        this.eStore = await store.getECStore(this.eInfo);
      } catch (e) {
        let error = e as BusinessError;
        console.error(`Failed to GetECStore.code is ${error.code},message is ${error.message}`);
      }
      // 解锁状态 获取e类库
      if (this.needMove) {
        if (this.eStore != undefined && this.cStore != undefined) {
          await this.mover.move(this.eStore, this.cStore);
          console.info(`ECDB_Encry cstore data move to estore success`);
        }
        this.deleteCStore();
        this.needMove = false;
      }
      return this.eStore;
    } else {
      // 加锁状态 获取c类库
      this.needMove = true;
      try {
        this.cStore = await store.getECStore(this.cInfo);
      } catch (e) {
        let error = e as BusinessError;
        console.error(`Failed to GetECStore.code is ${error.code},message is ${error.message}`);
      }
      return this.cStore;
    }
  }

  closeEStore(): void {
    this.eStore = undefined;
  }

  async deleteCStore() {
    try {
      await relationalStore.deleteRdbStore(this.cInfo.context, this.cInfo.storeId)
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager.code is ${error.code},message is ${error.message}`);
    }
  }

  private eStore: relationalStore.RdbStore = null;
  private cStore: relationalStore.RdbStore = null;
  private cInfo: StoreInfo | null = null;
  private eInfo: StoreInfo | null = null;
  private needMove: boolean = false;
  private mover: Mover | null = null;
}
// [End rdb_ECStoreManager]