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
// [Start Using_LazyForEach_component]
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: StringData[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): StringData {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: StringData[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): StringData {
    return this.dataArray[index];
  }

  public addData(index: number, data: StringData): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: StringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

@ObservedV2
class StringData {
  @Trace message: string;
  constructor(message: string) {
    this.message = message;
  }
}

@Entry
@ComponentV2
struct Index {
  data: MyDataSource = new MyDataSource(); // 数据源

  aboutToAppear() {
    for (let i = 0; i <= 200; i++) {
      this.data.pushData(new StringData('Hello' + i));
    }
  }
  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: StringData, index: number) => {
        ListItem() {
          Column() {
            Text(item.message)
            ChildComponent({ data: item.message })
              .onClick(() => {
                item.message += '!'; // message为@Trace装饰的变量，可观察变化
              })
          }
        }
      })
    }.cachedCount(5)
  }
}

@ReusableV2
@ComponentV2
struct ChildComponent {
  @Param @Require data: string;
  aboutToAppear(): void {
    console.info('ChildComponent aboutToAppear', this.data);
  }
  aboutToDisappear(): void {
    console.info('ChildComponent aboutToDisappear', this.data);
  }
  aboutToReuse(): void {
    console.info('ChildComponent aboutToReuse', this.data); // 复用时触发
  }
  aboutToRecycle(): void {
    console.info('ChildComponent aboutToRecycle', this.data); // 回收时触发
  }
  build() {
    Row() {
      Text(this.data).fontSize(50)
    }
  }
}
// [End Using_LazyForEach_component]