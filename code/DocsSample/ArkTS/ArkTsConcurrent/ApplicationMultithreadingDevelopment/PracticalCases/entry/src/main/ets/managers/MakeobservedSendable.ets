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

import { taskpool } from '@kit.ArkTS';
import { SendableData } from './SendableData';
import { UIUtils } from '@kit.ArkUI';

@Concurrent
function threadGetData(param: string): SendableData {
  // 在子线程处理数据
  let ret = new SendableData();
  console.info(`Concurrent threadGetData, param ${param}`);
  ret.name = param + '-o';
  ret.age = Math.floor(Math.random() * 40);
  ret.likes = Math.floor(Math.random() * 100);
  return ret;
}

@Entry
@ComponentV2
struct Index {
  // 通过makeObserved给普通对象或是Sendable对象添加可观察能力
  @Local send: SendableData = UIUtils.makeObserved(new SendableData());

  build() {
    Column() {
      Text(this.send.name)
      Button('change name').onClick(() => {
        // 可以观察到属性的改变
        this.send.name += '0';
      })
        .id('change name')
      Button('task').onClick(() => {
        // 将待执行的函数放入taskpool内部任务队列等待，等待分发到工作线程执行。
        // 因为数据的构建和处理可以在子线程中完成，但有观察能力的数据不能传给子线程，只有在UI主线程里才可以操作可观察的数据。
        // 所以这里只是将`this.send`的属性`name`传给子线程操作。
        taskpool.execute(threadGetData, this.send.name).then(val => {
          // 和@Local一起使用，可以观察this.send的变化
          this.send = UIUtils.makeObserved(val as SendableData);
        })
      })
        .id('task')
    }
  }
}