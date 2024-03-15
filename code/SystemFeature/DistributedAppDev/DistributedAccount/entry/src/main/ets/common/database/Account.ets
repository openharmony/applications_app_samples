/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import DataRdb from '@ohos.data.relationalStore';

/**
 * Database account entity class.
 */
export default class Account {
  /**
   * The name in the distributed information of the OS account.
   */
  distributedAccountName: string = "";

  /**
   * The ID in the distributed information of the OS account.
   */
  distributedAccountID: string = "";

  /**
   * The local ID of an OS account.
   */
  localId: number = 0;

  /**
   * Get inserted account data.
   *
   * @return Return account data.
   */
  toValuesBucket(): DataRdb.ValuesBucket {
    return {
      distributedAccountName: this.distributedAccountName,
      distributedAccountID: this.distributedAccountID,
      localId: this.localId
    };
  }
}
