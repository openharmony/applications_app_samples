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

import type DataRdb from '@ohos.data.relationalStore';
import type common from '@ohos.app.ability.common';
import type distributedAccount from '@ohos.account.distributedAccount';

export class GlobalContext {

  private constructor() {}

  public static getContext(): common.Context {
    return globalThis.context;
  }

  public static getrdbStore(): DataRdb.RdbStore {
    return globalThis.rdbStore;
  }

  public static setrdbStore(rdbStore: DataRdb.RdbStore): void {
    globalThis.rdbStore = rdbStore;
  }
}

export class routerParams {
  distributedInfo: distributedAccount.DistributedInfo;
}
