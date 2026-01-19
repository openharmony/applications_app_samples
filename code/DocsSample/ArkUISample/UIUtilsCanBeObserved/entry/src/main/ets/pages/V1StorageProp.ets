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

// [Start v1_storage_prop]
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'CanBeObserved';

class StoragePropUser {
  public name?: string;

  constructor(name?: string) {
    this.name = name ?? '';
  }

  // 在对象中提供判断该对象是否为可被观察对象的方法
  test(): void {
    hilog.info(0x00, TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(this))}`);
  }
}

AppStorage.setOrCreate('propUser', new StoragePropUser('Flowers'));

@Entry
@Component
struct V1StorageProp {
  @StorageLink('propUser') storagePropUser: StoragePropUser = new StoragePropUser();

  build() {
    Column({ space: 20 }) {

      Child01()

      Child02()

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.storagePropUser.test();
        })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@Component
export struct Child01 {
  @StorageProp('propUser') storagePropUser: StoragePropUser = new StoragePropUser();

  build() {
    Column() {
      Text('Child01 ' + this.storagePropUser.name)

      Child03()
    }
  }
}

@Component
export struct Child02 {
  @StorageProp('propUser') storagePropUser: StoragePropUser = new StoragePropUser();

  build() {
    Column() {
      Text('Child02 ' + this.storagePropUser.name)
    }
  }
}

@Component
export struct Child03 {
  @StorageProp('propUser') storagePropUser: StoragePropUser = new StoragePropUser();

  build() {
    Column() {
      Text('Child03 ' + this.storagePropUser.name)
    }
  }
}
// [End v1_storage_prop]