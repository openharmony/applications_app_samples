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

// [Start observing_nested_class_properties]
class ClassPropertiesDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: ClassPropertiesStringData[] = [];

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): ClassPropertiesStringData {
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

/** BasicDataSource代码见文档末尾BasicDataSource示例代码: StringData类型数组的BasicDataSource代码。
其中BasicDataSource、StringData等名称需要开发者自行修改。**/
class PropertiesDataSource extends ClassPropertiesDataSource {
  private dataArray: ClassPropertiesStringData[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): ClassPropertiesStringData {
    return this.dataArray[index];
  }

  public pushData(data: ClassPropertiesStringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

class ClassPropertiesStringData {
  public firstLayer: FirstLayer;

  constructor(firstLayer: FirstLayer) {
    this.firstLayer = firstLayer;
  }
}

class FirstLayer {
  public secondLayer: SecondLayer;

  constructor(secondLayer: SecondLayer) {
    this.secondLayer = secondLayer;
  }
}

class SecondLayer {
  public thirdLayer: ThirdLayer;

  constructor(thirdLayer: ThirdLayer) {
    this.thirdLayer = thirdLayer;
  }
}

@ObservedV2
class ThirdLayer {
  @Trace public fourthLayer: string;

  constructor(fourthLayer: string) {
    this.fourthLayer = fourthLayer;
  }
}

@Entry
@ComponentV2
struct ObservingNestedClassProperties {
  private data: PropertiesDataSource = new PropertiesDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(new ClassPropertiesStringData(new FirstLayer(new SecondLayer(new ThirdLayer(`Hello ${i}`)))));
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: ClassPropertiesStringData, index: number) => {
        ListItem() {
          Text(item.firstLayer.secondLayer.thirdLayer.fourthLayer).fontSize(50)
            .onClick(() => {
              item.firstLayer.secondLayer.thirdLayer.fourthLayer += '!';
            })
        }
      }, (item: ClassPropertiesStringData, index: number) => index.toString())
    }
    .cachedCount(5)
  }
}
// [End observing_nested_class_properties]