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
// [Start Internal_Persistent_Storage_V2]
// 迁移到globalConnect
import { PersistenceV2, Type } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s', `error key: ${key}, reason: ${reason}, message: ${msg}`);
});

class Data {
  public name: string = 'ZhangSan';
  public id: number = 0;
}

@ObservedV2
class V2Data {
  @Trace public name: string = '';
  @Trace public id: number = 1;
}

@ObservedV2
export class Sample {
  // 对于复杂对象需要@Type修饰，确保序列化成功
  @Type(V2Data)
  @Trace public num: number = 1;
  @Trace public V2: V2Data = new V2Data();
}

// 用于判断是否完成数据迁移的辅助数据
@ObservedV2
class StorageState {
  @Trace public isCompleteMoving: boolean = false;
}

function move() {
  let movingState = PersistenceV2.globalConnect({ type: StorageState, defaultCreator: () => new StorageState() })!;
  if (!movingState.isCompleteMoving) {
    PersistentStorage.persistProp('numProp', 47);
    PersistentStorage.persistProp('dataProp', new Data());
    let num = AppStorage.get<number>('numProp')!;
    let v1Data = AppStorage.get<Data>('dataProp')!;
    PersistentStorage.deleteProp('numProp');
    PersistentStorage.deleteProp('dataProp');

    // V2创建对应数据
    let migrate = PersistenceV2.globalConnect({
      type: Sample,
      key: 'connect2',
      defaultCreator: () => new Sample()
    })!; // 使用默认构造函数也可以
    // 赋值数据，@Trace修饰的会自动保存，对于非@Trace对象，也可以调用save保存，如：PersistenceV2.save('connect2');
    migrate.num = num;
    migrate.V2.name = v1Data.name;
    migrate.V2.id = v1Data.id;

    // 将迁移标志设置为true
    movingState.isCompleteMoving = true;
  }
}

move();

@Entry
@ComponentV2
struct Page1 {
  @Local refresh: number = 0;
  // 使用key:connect2存入数据
  @Local p: Sample =
    PersistenceV2.globalConnect({ type: Sample, key: 'connect2', defaultCreator: () => new Sample() })!;

  build() {
    Column({ space: 5 }) {
      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Text(`numProp: ${this.p.num}`)
        .onClick(() => {
          this.p.num += 1;
        })
        .fontSize(30)

      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Text(`dataProp.name: ${this.p.V2.name}`)
        .onClick(() => {
          this.p.V2.name += 'a';
        })
        .fontSize(30)
      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Text(`dataProp.id: ${this.p.V2.id}`)
        .onClick(() => {
          this.p.V2.id += 1;
        })
        .fontSize(30)
    }
    .width('100%')
  }
}
// [End Internal_Persistent_Storage_V2]
@Component
export struct InternalPersistentStorageV2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Persistent_Storage_V2'))
  }
}