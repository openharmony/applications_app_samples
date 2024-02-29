/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

class ChildDataSource implements IDataSource {
  private list: string[] = [];

  constructor(list: string[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): string {
    return this.list[index];
  }

  registerDataChangeListener(_: DataChangeListener): void {
  }

  unregisterDataChangeListener(): void {
  }
}

@Component
export struct FrameTimelineAfterOptimization {
  // 创建长度500的空数组，使用每个元素的索引转成的字符串作为元素的值，生成包含字符串0-499的数组
  @State children: string[] = Array.from<undefined, string>(Array(500).fill(undefined), (item: undefined, index) => index.toString());
  @State data: ChildDataSource = new ChildDataSource(this.children)
  build() {
    Scroll() {
      Grid() {
        LazyForEach(this.data, (item: string) => {
          GridItem() {
            Text(item)
              .fontSize(32)
          }
        }, (item: string) => item)
      }
      .cachedCount(80)
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(0)
      .rowsGap(0)
      .size({ width: "100%", height: "100%" })
    }
  }
}