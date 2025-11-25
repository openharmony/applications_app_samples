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

class MyLazyLoadingDataSource extends BasicDataSource {
  public dataArray: string[] = [];

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
}

@Entry
@Component
struct LazyLoadingFailure {
  private data: MyLazyLoadingDataSource = new MyLazyLoadingDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 100; i++) {
      this.data.pushData(``);
    }
  }

  build() {
    List() {
      // [Start set_default_height]
      LazyForEach(this.data, (item: string, index: number) => {
        ChildComponent({ message: item, index: index })
        // 设置子组件默认高度，首次渲染懒加载生效
          .height(60)
      }, (item: string, index: number) => item + index)
      // [End set_default_height]
    }
    .cachedCount(2)
  }
}

@Component
struct ChildComponent {
  message: string = ``;
  index: number = -1;

  aboutToAppear(): void {
  }

  build() {
    Text(this.message).fontSize(50)
  }
}