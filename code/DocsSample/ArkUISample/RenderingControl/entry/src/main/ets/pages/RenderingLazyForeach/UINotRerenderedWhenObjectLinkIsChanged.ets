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

// [Start ui_not_rerendered]
/** GenericBasicDataSource代码见文档末尾BasicDataSource示例代码: 泛型数组的BasicDataSource代码 **/
import { GenericBasicDataSource } from './GenericBasicDataSource';

class UINoteRenderingSource extends GenericBasicDataSource<UINoteRenderingStringData> {
  private dataArray: UINoteRenderingStringData[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): UINoteRenderingStringData {
    return this.dataArray[index];
  }

  public pushData(data: UINoteRenderingStringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

@Observed
class UINoteRenderingStringData {
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
  private data: UINoteRenderingSource = new UINoteRenderingSource();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(new UINoteRenderingStringData(new NestedString(`Hello ${i}`)));
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: UINoteRenderingStringData, index: number) => {
        ListItem() {
          UINotRerenderedChildComponent({ data: item })
        }
        .onClick(() => {
          // @ObjectLink装饰的成员变量仅能监听到其子属性的变化，再深入嵌套的属性便无法观测到
          item.message = new NestedString(item.message.message + '0');
        })
      }, (item: UINoteRenderingStringData, index: number) => item.message.message + index.toString())
    }
    .cachedCount(5)
  }
}

@Component
struct UINotRerenderedChildComponent {
  @ObjectLink data: UINoteRenderingStringData;

  build() {
    Row() {
      Text(this.data.message.message).fontSize(50)
    }.margin({ left: 10, right: 10 })
  }
}
// [End ui_not_rerendered]