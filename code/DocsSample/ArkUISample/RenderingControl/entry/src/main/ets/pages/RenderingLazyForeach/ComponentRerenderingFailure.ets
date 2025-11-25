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

import { BasicDataSource } from './BasicDataSource';

class RerenderingDataSource extends BasicDataSource {
  private dataArray: string[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public pushData(data: string): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public updateAllData(): void {
    this.dataArray = this.dataArray.map((item: string) => item + `!`);
    this.notifyDataReload();
  }
}

@Entry
@Component
struct ComponentRerenderingFailure {
  private data: RerenderingDataSource = new RerenderingDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(`Hello ${i}`);
    }
  }

  build() {
    Column() {
      Button(`update all`)
        .onClick(() => {
          this.data.updateAllData();
        })
      List({ space: 3 }) {
        // [Start define_key]
        LazyForEach(this.data, (item: string) => {
          ListItem() {
            Text(item).fontSize(50)
          }
        }, (item: string) => item) // 定义键值生成函数
        // [End define_key]
      }
      .cachedCount(5)
    }
  }
}