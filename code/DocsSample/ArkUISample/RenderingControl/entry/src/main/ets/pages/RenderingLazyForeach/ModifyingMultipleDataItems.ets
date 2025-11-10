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

// [Start change_multiple_data]
import { hilog } from '@kit.PerformanceAnalysisKit';
/** BasicDataSource代码见文档末尾BasicDataSource示例代码: String类型数组的BasicDataSource代码。**/
import { BasicDataSource } from './BasicDataSource';
const TAG = '[Sample_RenderingControl]';
const DOMAIN = 0xF811;

class ModifyingMultiSourceEleven extends BasicDataSource {
  private dataArray: string[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public pushData(data: string): void {
    this.dataArray.push(data);
  }

  public reloadData(): void {
    this.notifyDataReload();
  }

  public modifyAllData(): void {
    this.dataArray = this.dataArray.map((item: string) => {
      return item + '0';
    });
  }
}

@Entry
@Component
struct ModifyingMultipleDataItems {
  private data: ModifyingMultiSourceEleven = new ModifyingMultiSourceEleven();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(`Hello ${i}`);
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: string, index: number) => {
        ListItem() {
          Row() {
            Text(item).fontSize(50)
              .onAppear(() => {
                hilog.info(DOMAIN, TAG, 'appear: ${item}');
              })
          }.margin({ left: 10, right: 10 })
        }
        .onClick(() => {
          this.data.modifyAllData();
          this.data.reloadData();
        })
      }, (item: string) => item)
    }
    .cachedCount(5)
  }
}
// [End change_multiple_data]