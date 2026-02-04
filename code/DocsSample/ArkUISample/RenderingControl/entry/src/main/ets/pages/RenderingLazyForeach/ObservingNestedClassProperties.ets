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
// GenericBasicDataSource代码见文档末尾BasicDataSource示例代码: 泛型数组的BasicDataSource代码。
import { GenericBasicDataSource } from './GenericBasicDataSource';

class PropertiesDataSource extends GenericBasicDataSource<ClassPropertiesStringData> {
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