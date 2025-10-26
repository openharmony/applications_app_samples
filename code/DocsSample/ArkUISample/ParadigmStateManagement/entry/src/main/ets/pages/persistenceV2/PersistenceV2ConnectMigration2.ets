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

// [Start persistence_v2_connect_migration_two]
// 使用connect存储数据
import { PersistenceV2, Type } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s', `error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@ObservedV2
class SampleChild {
  // 应用持久化Key connect2:点击的数量，默认为0，如果点击后退出再次进入，则默认为持久化的数量
  @Trace public childId: number = 0;
  // 应用持久化save key Sample:点击的数量，默认为1，如果点击后退出再次进入，则默认为持久化的数量
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
struct Page1 {
  // 进入当前页面后点击了save key Sample:多少次
  @Local refresh: number = 0;
  // 使用key:connect2存储
  @Local p: Sample = PersistenceV2.connect(Sample, 'connect2', () => new Sample())!;

  build() {
    Column({ space: 5 }) {
      /**************************** 显示数据 **************************/
      Text('Key connect2: ' + this.p.father.childId.toString())
        .onClick(() => {
          this.p.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)

      /**************************** save接口 **************************/
      // 非状态变量需要借助状态变量refresh才能刷新
      Text('save key Sample: ' + this.p.father.groupId.toString() + ' refresh:' + this.refresh)
        .onClick(() => {
          // 未被@Trace保存的对象无法自动存储，需要调用save存储
          this.p.father.groupId += 1;
          PersistenceV2.save('connect2');
          this.refresh += 1;
        })
        .fontSize(25)
    }
    .width('100%')
  }
}
// [End persistence_v2_connect_migration_two]

@Component
export struct PersistenceV2ConnectMigration2Decorator {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.persistence_v2_connect_migration2'))
  }
}