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

// [Start Index]
import { storeManager, e_secretKeyObserver } from '../entryability/EntryAbility';
import { distributedKVStore } from '@kit.ArkData';
import { Store } from '../entryability/Store';

let storeOption = new Store();
let lockStatus: number = 1;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Button('加锁/解锁').onClick((event: ClickEvent) => {
          if (lockStatus) {
            e_secretKeyObserver.onLock();
            lockStatus = 0;
          } else {
            e_secretKeyObserver.onUnLock();
            lockStatus = 1;
          }
          lockStatus ? this.message = '解锁' : this.message = '加锁';
        }).margin(5)
          .width(100) // 宽度，单位默认vp（可视像素）
          .height(40) // 高度

        Button('StoreType').onClick(async (event: ClickEvent) => {
          e_secretKeyObserver.getCurrentStatus() ? this.message = 'estore' : this.message = 'cstore';
        }).margin(5)
          .width(100) // 宽度，单位默认vp（可视像素）
          .height(40) // 高度

        Button('Put').onClick(async (event: ClickEvent) => {
          let store: distributedKVStore.SingleKVStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
          storeOption.putOnedata(store);
        }).margin(5)
          .width(100) // 宽度，单位默认vp（可视像素）
          .height(40) // 高度

        Button('Get').onClick(async (event: ClickEvent) => {
          let store: distributedKVStore.SingleKVStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
          storeOption.getDataNum(store);
        }).margin(5)
          .width(100) // 宽度，单位默认vp（可视像素）
          .height(40) // 高度

        Button('Delete').onClick(async (event: ClickEvent) => {
          let store: distributedKVStore.SingleKVStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
          storeOption.deleteOnedata(store);
        }).margin(5)
          .width(100) // 宽度，单位默认vp（可视像素）
          .height(40) // 高度

        Button('Update').onClick(async (event: ClickEvent) => {
          let store: distributedKVStore.SingleKVStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
          storeOption.updateOnedata(store);
        }).margin(5)
          .width(100) // 宽度，单位默认vp（可视像素）
          .height(40) // 高度

        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Index]