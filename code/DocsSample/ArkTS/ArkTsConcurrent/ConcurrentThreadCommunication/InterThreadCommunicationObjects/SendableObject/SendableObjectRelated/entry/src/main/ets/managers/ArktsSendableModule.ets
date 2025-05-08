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

// [Start multi_thread_operate_exported_obj]
import { ArkTSUtils, taskpool } from '@kit.ArkTS';
import { singletonA } from './sharedModule';

export { num, str } from './test'; // 正确示例，导出对象合集

@Sendable
export class A {
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

@Concurrent
async function increaseCount() {
  await singletonA.increaseCount();
  console.info('SharedModule: count is:' + await singletonA.getCount());
}

@Concurrent
async function printCount() {
  console.info('SharedModule: count is:' + await singletonA.getCount());
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State mainThreadPrint: string = 'MainThread print count';
  @State taskpoolPrint: string = 'Taskpool print count';
  @State mainThreadIncrease: string = 'MainThread increase count';
  @State taskpoolIncrease: string = 'Taskpool increase count';

  build() {
    Row() {
      Column() {
        Button(this.mainThreadPrint)
          .id('MainThread print count')
          .onClick(async () => {
            await printCount();
            this.mainThreadPrint = 'success';
          })
        Button(this.taskpoolPrint)
          .id('Taskpool print count')
          .onClick(async () => {
            await taskpool.execute(printCount);
            this.taskpoolPrint = 'success';
          })
        Button(this.mainThreadIncrease)
          .id('MainThread increase count')
          .onClick(async () => {
            await increaseCount();
            this.mainThreadIncrease = 'success';
          })
        Button(this.taskpoolIncrease)
          .id('Taskpool increase count')
          .onClick(async () => {
            await taskpool.execute(increaseCount);
            this.taskpoolIncrease = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End multi_thread_operate_exported_obj]