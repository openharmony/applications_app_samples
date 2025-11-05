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
// [Start function threadGetData]
import { taskpool } from '@kit.ArkTS';
import { SendableData } from '../Model/modelView';
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Concurrent
function threadGetData(param: string): SendableData {
  const DOMAIN = 0xF811;
  const TAG = '[Sample_MakeObserved]';
  // 在子线程处理数据
  let ret = new SendableData();
  hilog.info(DOMAIN, TAG, `Concurrent threadGetData, param ${param}`);
  ret.name = param + '-o';
  ret.age = Math.floor(Math.random() * 40);
  ret.likes = Math.floor(Math.random() * 100);
  return ret;
}

@Entry
@ComponentV2
struct Page3 {
  // 通过makeObserved给普通对象或是SendableData对象添加可观察能力
  @Local send: SendableData = UIUtils.makeObserved(new SendableData());

  build() {
    Column() {
      Text(this.send.name)
      Button('change name').onClick(() => {
        // ok 可以观察到属性的改变
        this.send.name += '0';
      })

      Button('task').onClick(() => {
        // 将待执行的函数放入taskpool内部任务队列等待，等待分发到工作线程执行。
        taskpool.execute(threadGetData, this.send.name).then(val => {
          // 和@Local一起使用，可以观察this.send的变化
          this.send = UIUtils.makeObserved(val as SendableData);
        })
      })
    }
  }
}
// [End function threadGetData]