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

// [Start persistence_v2_module_connect_storage_two]
// 模块2
import { PersistenceV2, Type } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s', `error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@ObservedV2
class SampleChild {
  @Trace public childId: number = 0;
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
  @Local a: number = 0;
  // 使用key:global1连接，传入加密等级为EL1
  @Local p1: Sample =
    PersistenceV2.globalConnect({ type: Sample, key: 'globalConnect1', defaultCreator: () => new Sample() })!;
  // 使用key:global2连接，使用构造函数形式，加密参数不传入默认加密等级为EL2
  @Local p2: Sample = PersistenceV2.connect(Sample, 'connect2', () => new Sample())!;

  build() {
    Column() {
      /**************************** 显示数据 **************************/
      Text('Key globalConnect1: ' + this.p1.father.childId.toString())
        .onClick(() => {
          this.p1.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
      Text('Key connect2: ' + this.p2.father.childId.toString())
        .onClick(() => {
          this.p2.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
    }
    .width('100%')
  }
}
// [End persistence_v2_module_connect_storage_two]

@Component
export struct PersistenceV2ModuleConnectStorage2Decorator {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.persistence_v2_module_connect_storage2'))
  }
}