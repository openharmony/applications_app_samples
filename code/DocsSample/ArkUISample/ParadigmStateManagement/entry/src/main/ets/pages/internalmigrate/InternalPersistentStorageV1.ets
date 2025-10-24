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
// [Start Internal_Persistent_Storage_V1]
class Data {
  public name: string = 'ZhangSan';
  public id: number = 0;
}

PersistentStorage.persistProp('numProp', 47);
PersistentStorage.persistProp('DataProp', new Data());

@Entry
@Component
struct Index {
  @StorageLink('numProp') numProp: number = 48;
  @StorageLink('DataProp') DataProp: Data = new Data();

  build() {
    Column() {
      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Text(`numProp: ${this.numProp}`)
        .onClick(() => {
          this.numProp += 1;
        })
        .fontSize(30)

      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Text(`DataProp.name: ${this.DataProp.name}`)
        .onClick(() => {
          this.DataProp.name += 'a';
        })
        .fontSize(30)
      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Text(`DataProp.id: ${this.DataProp.id}`)
        .onClick(() => {
          this.DataProp.id += 1;
        })
        .fontSize(30)

    }
    .width('100%')
  }
}
// [End Internal_Persistent_Storage_V1]
@Component
export struct InternalPersistentStorageV1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Persistent_Storage_V1'))
  }
}