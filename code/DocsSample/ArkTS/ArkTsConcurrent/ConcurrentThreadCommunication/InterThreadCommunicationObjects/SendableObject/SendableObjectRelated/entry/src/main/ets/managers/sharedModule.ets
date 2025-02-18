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

// 共享模块
import { ArkTSUtils } from '@kit.ArkTS';

// 声明当前模块为共享模块，只能导出可Sendable数据
'use shared'

// 共享模块，SingletonA全局唯一
@Sendable
class SingletonA {
  private count_: number = 0;
  public lock_: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock();

  public async getCount(): Promise<number> {
    return this.lock_.lockAsync(() => {
      return this.count_;
    })
  }

  public async increaseCount() {
    await this.lock_.lockAsync(() => {
      this.count_++;
    })
  }
}

export let singletonA = new SingletonA();