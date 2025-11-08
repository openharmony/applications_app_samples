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

// [Start screen_flickering_in_list]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BasicDataSource } from './BasicDataSource';
const TAG = '[Sample_RenderingControl]';
const DOMAIN = 0xF811;

class ScreenFliceringDataSource extends BasicDataSource {
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

  operateData(): void {
    const totalCount = this.dataArray.length;
    const batch = 5;
    for (let i = totalCount; i < totalCount + batch; i++) {
      this.dataArray.push(`Hello ${i}`);
    }
    // 替换 notifyDataReload
    this.notifyDatasetChange([{ type: DataOperationType.ADD, index: totalCount - 1, count: batch }]);
  }
}

@Entry
@Component
struct ScreenFlickeringInList {
  private moved: number[] = [];
  private data: ScreenFliceringDataSource = new ScreenFliceringDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 10; i++) {
      this.data.pushData(`Hello ${i}`);
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: string, index: number) => {
        ListItem() {
          Row() {
            Text(item)
              .width('100%')
              .height(80)
              .backgroundColor(Color.Gray)
              .onAppear(() => {
                hilog.info(DOMAIN, TAG, 'appear: ${item}');
              })
          }.margin({ left: 10, right: 10 })
        }
      }, (item: string) => item)
    }
    .cachedCount(10)
    .onScrollIndex((start, end, center) => {
      if (end === this.data.totalCount() - 1) {
        this.data.operateData();
      }
    })
  }
}
// [End screen_flickering_in_list]