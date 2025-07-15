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

// [Start cale_model]
// 此段示例为伪代码仅作为逻辑示意，便于开发者理解使用内存共享模型和Actor模型的区别
class Queue {
  // ...
  push(value: number) {}

  empty(): boolean {
    // ...
    return true
  }

  pop(value: number) :number {
    // ...
    return value;
  }
}

class Mutex {
  // ...
  lock(): boolean {
    // ...
    return true;
  }

  unlock() {

  }
}
class BufferQueue {
  public queue: Queue = new Queue()
  public mutex: Mutex = new Mutex()
  add(value: number) {
    // 尝试获取锁
    if (this.mutex.lock()) {
      this.queue.push(value)
      this.mutex.unlock()
    }
  }

  take(value: number): number {
    let res: number = 0;
    // 尝试获取锁
    if (this.mutex.lock()) {
      if (this.queue.empty()) {
        res = 1;
      }
      let num: number = this.queue.pop(value)
      this.mutex.unlock()
      res = num;
    }
    return res;
  }
}

// 构造一段全局共享的内存
let gBufferQueue = new BufferQueue()

class Producer {
  constructor() {
  }
  run() {
    let value = Math.random()
    // 跨线程访问bufferQueue对象
    gBufferQueue.add(value)
  }
}

class ConsumerTest {
  constructor() {
  }
  run() {
    // 跨线程访问bufferQueue对象
    let num = 123;
    let res = gBufferQueue.take(num)
    if (res != null) {
      // 添加消费逻辑
    }
  }
}

export function Main(): void {
  console.info('Main start');
  let consumer: ConsumerTest = new ConsumerTest()
  let producer1: Producer = new Producer()
  let threadNum: number = 10;
  for (let i = 0; i < threadNum; i++) {
    // 模拟启动多线程执行生产任务
    /* let thread = new Thread()
     * thread.run(producer.run())
     * consumer.run()
     */
  }
  console.info('Main end');
}
// [End cale_model]