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

// [Start reusable_for_correct_sample]
class BasicDataSource implements IDataSource {
  private listener: DataChangeListener | undefined = undefined;
  public dataArray: number[] = [];

  totalCount(): number {
    return this.dataArray.length;
  }

  getData(index: number): number {
    return this.dataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener;
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listener = undefined;
  }
}

@Entry
@Component
struct Index {
  private data: BasicDataSource = new BasicDataSource();

  aboutToAppear(): void {
    for (let index = 1; index <= 20; index++) { // 循环20次
      this.data.dataArray.push(index);
    }
  }

  build() {
    List() {
      LazyForEach(this.data, (item: number, index: number) => {
        ListItem() {
          ReuseComponent({ num: item })
        }
      }, (item: number, index: number) => index.toString())
    }.cachedCount(0)
  }
}

@Reusable
@Component
struct ReuseComponent {
  @State num: number = 0;

  aboutToReuse(params: ESObject): void {
    this.num = params.num;
  }

  build() {
    Column() {
      Text('ReuseComponent num:' + this.num.toString())
      ReuseComponentChild({ num: this.num })
      Button('plus')
        .onClick(() => {
          this.num += 10; // 每次点击增加10
        })
    }
    .height(200)
  }
}

@Component
struct ReuseComponentChild {
  @Link num: number;

  aboutToReuse(params: ESObject): void {
    setTimeout(() => {
      this.num = -1 * params.num;
    }, 1)
  }

  build() {
    Text('ReuseComponentChild num:' + this.num.toString());
  }
}
// [End reusable_for_correct_sample]