/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
// [Start appstorage_page_two]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG: string = '[Sample_appstorage]';

class Data {
  public code: number;

  constructor(code: number) {
    this.code = code;
  }
}

AppStorage.setOrCreate('propA', 47);
AppStorage.setOrCreate('propB', new Data(50));
let storage = new LocalStorage();
storage.setOrCreate('linkA', 48);
storage.setOrCreate('linkB', new Data(100));

@Entry(storage)
@Component
struct TestStorageProp {
  @StorageLink('propA') storageLink: number = 1;
  @StorageProp('propA') storageProp: number = 1;
  @StorageLink('propB') storageLinkObject: Data = new Data(1);
  @StorageProp('propB') storagePropObject: Data = new Data(1);

  build() {
    Column({ space: 20 }) {
      // @StorageLink与AppStorage建立双向联系，更改数据会同步回AppStorage中key为'propA'的值
      Text(`storageLink ${this.storageLink}`)
        .onClick(() => {
          this.storageLink += 1;
        })

      // @StorageProp与AppStorage建立单向联系，更改数据不会同步回AppStorage中key为'propA'的值
      // 但能被AppStorage的set/setorCreate更新值
      Text(`storageProp ${this.storageProp}`)
        .onClick(() => {
          this.storageProp += 1;
        })

      // AppStorage的API虽然能获取值，但是不具有刷新UI的能力，日志能看到数值更改
      // 依赖@StorageLink/@StorageProp才能建立起与自定义组件的联系，刷新UI
      Text(`change by AppStorage: ${AppStorage.get<number>('propA')}`)
        .onClick(() => {
          hilog.info(DOMAIN, TAG, `Appstorage.get: ${AppStorage.get<number>('propA')}`);
          AppStorage.set<number>('propA', 100);
        })

      Text(`storageLinkObject ${this.storageLinkObject.code}`)
        .onClick(() => {
          this.storageLinkObject.code += 1;
        })

      Text(`storagePropObject ${this.storagePropObject.code}`)
        .onClick(() => {
          this.storagePropObject.code += 1;
        })
    }
  }
}
// [End appstorage_page_two]