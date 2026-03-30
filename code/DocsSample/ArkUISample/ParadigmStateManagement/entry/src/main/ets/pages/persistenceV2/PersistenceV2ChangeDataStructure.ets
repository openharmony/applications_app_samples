/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start persistence_v2_change_data_structure]
import { PersistenceV2, Type } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string, oldValue?: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s',
    `error key: ${key}, reason: ${reason}, message: ${msg}, oldValue: ${oldValue}`);
});

@ObservedV2
class SampleChild {
  @Trace public info: string = 'Hello';
}

@ObservedV2
class Sample {
  // 起始时childInfo类型为SampleChild，使用connect/globalConnect将其存储到磁盘
  @Type(SampleChild)
  @Trace public childInfo: SampleChild = new SampleChild();
}

@Entry
@ComponentV2
struct Index {
  // 调用connect或globalConnect存储
  @Local sample: Sample =
    PersistenceV2.globalConnect({ type: Sample, key: 'connectSample', defaultCreator: () => new Sample() })!;

  build() {
    Column({ space: 5 }) {
      Text(JSON.stringify(this.sample)) // 序列化sample变量并显示
      Button('Change Info')
        .onClick(() => {
          // 通过将类型转换为ESObject，再转为SampleChild，绕过了类型校验，故点击后不会触发notifyOnError。
          // 点击并重新运行后，由于此处存储的info为Array类型，但SampleChild中的info仍是string类型，故会触发notifyOnError。
          this.sample.childInfo = { info: [1, 2] } as ESObject as SampleChild;
        })
    }
    .width('100%')
  }
}
// [End persistence_v2_change_data_structure]