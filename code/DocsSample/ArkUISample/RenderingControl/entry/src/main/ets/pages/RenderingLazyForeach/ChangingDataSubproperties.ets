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

// [Start changing_data_sub_properties]
/** GenericBasicDataSource代码见文档末尾BasicDataSource示例代码: 泛型数组的BasicDataSource代码 **/
import { GenericBasicDataSource } from './GenericBasicDataSource';

class MySubDataSource extends GenericBasicDataSource<StringData> {
  private dataArray: StringData[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): StringData {
    return this.dataArray[index];
  }

  public pushData(data: StringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

@Observed
class StringData {
  public message: string;

  constructor(message: string) {
    this.message = message;
  }
}

@Entry
@Component
struct ChangingDataSubproperties {
  private data: MySubDataSource = new MySubDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(new StringData(`Hello ${i}`));
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: StringData, index: number) => {
        ListItem() {
          ChangingDataSubpropertiesChildComponent({ data: item })
        }
        .onClick(() => {
          item.message += '0';
        })
      }, (item: StringData, index: number) => index.toString())
    }
    .cachedCount(5)
  }
}

@Component
struct ChangingDataSubpropertiesChildComponent {
  @ObjectLink data: StringData;

  build() {
    Row() {
      Text(this.data.message).fontSize(50)
        .onAppear(() => {
        })
    }.margin({ left: 10, right: 10 })
  }
}
// [End changing_data_sub_properties]