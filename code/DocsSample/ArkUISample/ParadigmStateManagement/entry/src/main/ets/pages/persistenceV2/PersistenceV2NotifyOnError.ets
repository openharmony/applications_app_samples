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

// [Start persistence_v2_notifyOnError]
import { PersistenceV2, Type } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string, oldValue?: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s',
    `error key: ${key}, reason: ${reason}, message: ${msg}, oldValue: ${oldValue}`);
});

@ObservedV2
class SampleInfo {
  @Trace public info: boolean = true;
  @Trace public propertyName: string = 'Hello';
}

@ObservedV2
class SampleChild {
  // 起始时childInfo类型为SampleInfo，使用connect/globalConnect将其存储到磁盘
  @Type(SampleInfo)
  @Trace public childInfo: SampleInfo = new SampleInfo();
  // 将childInfo类型切换为number，并重新运行
  // @Trace public childInfo: number = 0;
  public groupId: number = 1;
}

@ObservedV2
export class Sample {
  // 对于复杂对象需要@Type修饰，确保序列化成功
  @Type(SampleChild)
  @Trace public father: SampleChild = new SampleChild();
}

@Entry
@ComponentV2
struct Index {
  @Local refresh: number = 0;
  // 调用connect或globalConnect存储
  @Local p: Sample = PersistenceV2.connect(Sample, 'connectSample', () => new Sample())!;
  // @Local p: Sample = PersistenceV2.globalConnect(
  //   { type: Sample, key: 'connectSample', defaultCreator: () => new Sample() })!;

  build() {
    Column({ space: 5 }) {
      // 显示数据
      Text('Key connectSample: ' + this.p.father.groupId.toString())
        .onClick(() => {
          this.p.father.groupId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)

      // save接口
      // 未被@Trace装饰的变量需要借助状态变量refresh才能刷新
      Text('save key connect3: ' + this.p.father.groupId.toString() + ' refresh:' + this.refresh)
        .onClick(() => {
          // 未被@Trace保存的对象无法自动存储，需要调用save存储
          this.p.father.groupId += 1;
          PersistenceV2.save('connectSample');
          this.refresh += 1;
        })
        .fontSize(25)
    }
    .width('100%')
  }
}
// [End persistence_v2_notifyOnError]