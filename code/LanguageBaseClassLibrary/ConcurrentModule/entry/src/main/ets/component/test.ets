/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import collections from '@arkts.collections';
import utils from '@arkts.utils';
@Sendable
export class TestA {
  v1: number = 0;
  v2: string = "";
  v3: boolean = false;
  count_: number = 0;
  async getCount(): Promise<number> {
    let lock: utils.locks.AsyncLock = utils.locks.AsyncLock.request("lock_1");
    return lock.lockAsync(() => {
      return this.count_;
    })
  }
  async setCount(count: number) {
    let lock: utils.locks.AsyncLock = utils.locks.AsyncLock.request("lock_1");
    await lock.lockAsync(() => {
      this.count_ = count;
    })
  }

  constructor() {
  }
}


@Sendable
export class TestB {
  v1: collections.Array<number> = new collections.Array<number>();
  v2: collections.Map<number, string> = new collections.Map<number, string>();
  v3: collections.Set<string> = new collections.Set<string>();

  constructor() {
  }
}