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

import { ArkTSUtils, taskpool } from '@kit.ArkTS';

@Sendable
export class A {
  private count_: number = 0;
  public lock_: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock();

  public async getCount(): Promise<number> {
    // 对需要保护的数据加异步锁
    return this.lock_.lockAsync(() => {
      return this.count_;
    })
  }

  public async increaseCount() {
    // 对需要保护的数据加异步锁
    await this.lock_.lockAsync(() => {
      this.count_++;
    })
  }
}

@Concurrent
async function printCount(a: A) {
  console.info('InputModule: count is:' + await a.getCount());
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(async () => {
          // 创建sendable对象a
          let a: A = new A();
          // 将实例a传递给子线程
          await taskpool.execute(printCount, a);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
