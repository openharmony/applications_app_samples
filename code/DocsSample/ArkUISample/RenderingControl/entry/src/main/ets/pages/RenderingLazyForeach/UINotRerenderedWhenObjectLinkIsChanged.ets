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

class BasicDataSource19 implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: StringData19[] = [];

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): StringData19 {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    });
  }
}

// [Start ui_not_rerendered]
/** BasicDataSource代码见文档末尾BasicDataSource示例代码: StringData类型数组的BasicDataSource代码 **/
class MyDataSource19 extends BasicDataSource19 {
  private dataArray: StringData19[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): StringData19 {
    return this.dataArray[index];
  }

  public pushData(data: StringData19): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

@Observed
class StringData19 {
  public message: NestedString;

  constructor(message: NestedString) {
    this.message = message;
  }
}

@Observed
class NestedString {
  public message: string;

  constructor(message: string) {
    this.message = message;
  }
}

@Entry
@Component
struct UINotRerenderedWhenObjectLinkIsChanged {
  private moved: number[] = [];
  private data: MyDataSource19 = new MyDataSource19();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(new StringData19(new NestedString(`Hello ${i}`)));
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: StringData19, index: number) => {
        ListItem() {
          UINotRerenderedChildComponent({ data: item })
        }
        .onClick(() => {
          // @ObjectLink装饰的成员变量仅能监听到其子属性的变化，再深入嵌套的属性便无法观测到
          item.message = new NestedString(item.message.message + '0');
        })
      }, (item: StringData19, index: number) => item.message.message + index.toString())
    }
    .cachedCount(5)
  }
}

@Component
struct UINotRerenderedChildComponent {
  @ObjectLink data: StringData19;

  build() {
    Row() {
      Text(this.data.message.message).fontSize(50)
    }.margin({ left: 10, right: 10 })
  }
}
// [End ui_not_rerendered]