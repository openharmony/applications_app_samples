/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

const UNLOCKED: number = 0;
const LOCKED_SINGLE: number = 1;
const LOCKED_MULTI: number = 2;

export class NonReentrantLock {
  flag: Int32Array;

  constructor(sab: SharedArrayBuffer) {
    // 传入一个4bytes的SharedArrayBuffer
    this.flag = new Int32Array(sab); // 其视图为只有一位的int数组（1=4bytes*8/32bit）
  }

  lock(): void {
    const flag: Int32Array = this.flag;
    let c: number = UNLOCKED;
    // 如果flag数组的0位置，当前值为UNLOCKED，则改为LOCKED_SINGLE；否则，进入do-while循环，阻塞线程
    if ((c = Atomics.compareExchange(flag, 0, UNLOCKED, LOCKED_SINGLE)) !== UNLOCKED) {
      do {
        // 有线程拿不到锁时，修改标志位为LOCKED_MULTI，并使之进入睡眠阻塞状态
        if (c === LOCKED_MULTI || Atomics.compareExchange(flag, 0, LOCKED_SINGLE, LOCKED_MULTI) !== UNLOCKED) {
          Atomics.wait(flag, 0, LOCKED_MULTI);
        }
        //被唤醒的线程，如果还是没有拿到锁，就回到循环中，重新进入阻塞状态
      } while ((c = Atomics.compareExchange(flag, 0, UNLOCKED, LOCKED_MULTI)) !== UNLOCKED);
    }
  }

  tryLock(): boolean {
    const flag: Int32Array = this.flag;
    return Atomics.compareExchange(flag, 0, UNLOCKED, LOCKED_SINGLE) === UNLOCKED;
  }

  unlock(): void {
    // 局部化flag，保证只有获取锁的线程可以释放锁
    const flag: Int32Array = this.flag;
    let v0: number = Atomics.sub(flag, 0, 1);
    if (v0 !== LOCKED_SINGLE) {
      Atomics.store(flag, 0, UNLOCKED);
      // 只唤醒在数组0的索引位置等待的其中一个线程，去上方的lock()方法while条件中检测，尝试获取锁
      Atomics.notify(flag, 0, 1);
    }
  }
}