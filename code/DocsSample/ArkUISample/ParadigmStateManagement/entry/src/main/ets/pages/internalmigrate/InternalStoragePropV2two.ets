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
// [Start Internal_StorageProp_V2_two]
import { common, Want } from '@kit.AbilityKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@ObservedV2
export class MyStorage {
  // 点击的次数
  @Trace public count: number = 0;
}

@Entry
@ComponentV2
struct Index1 {
  @Local storage: MyStorage = AppStorageV2.connect(MyStorage, 'storage', () => new MyStorage())!;
  // 获取到的storage存储点击的次数
  @Local count: number = this.storage.count;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  @Monitor('storage.count')
  onCountChange(mon: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `Index1 ${mon.value()?.before} to ${mon.value()?.now}`);
    this.count = this.storage.count;
  }

  build() {
    Column() {
      Text(`EntryAbility1 count: ${this.count}`)
        .fontSize(25)
        .onClick(() => {
          this.count++;
        })
      Button('change Storage Count')
        .onClick(() => {
          this.storage.count += 100;
        })
      Button('Jump to EntryAbility').onClick(() => {
        let wantInfo: Want = {
          bundleName: 'com.example.myapplication', // 替换成AppScope/app.json5里的bundleName
          abilityName: 'EntryAbility'
        };
        this.context.startAbility(wantInfo);
      })
    }
  }
}
// [End Internal_StorageProp_V2_two]
@Component
export struct InternalStoragePropV2two {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_StorageProp_V2_two'))
  }
}