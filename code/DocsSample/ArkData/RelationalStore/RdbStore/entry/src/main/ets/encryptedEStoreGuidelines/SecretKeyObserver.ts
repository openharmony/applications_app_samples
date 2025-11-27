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

// [Start rdb_SecretKeyObserver]
import { ECStoreManager } from './ECStoreManager';

export enum SecretStatus {
  Lock,
  UnLock
}

export class SecretKeyObserver {
  onLock(): void {
    this.lockStatus = SecretStatus.Lock;
    this.storeManager.closeEStore();
  }

  onUnLock(): void {
    this.lockStatus = SecretStatus.UnLock;
  }

  getCurrentStatus(): number {
    return this.lockStatus;
  }

  initialize(storeManager: ECStoreManager): void {
    this.storeManager = storeManager;
  }

  updateLockStatus(code: number) {
    if (this.lockStatus === SecretStatus.Lock) {
      this.onLock();
    } else {
      this.lockStatus = code;
    }
  }

  private lockStatus: number = SecretStatus.UnLock;
  private storeManager: ECStoreManager;
}

export let lockObserve = new SecretKeyObserver();
// [End rdb_SecretKeyObserver]