/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start using_union_types_in_structs]
class Data {
  public aa: number = 11;
}

class Model {
  public aa: string = '11';
}

type UnionData = Data | Model;

@Entry
@Component
struct DatauionPage {
  array: UnionData[] = [new Data(), new Data(), new Data()];

  @Builder
  componentCloser(data: UnionData) {
    if (data instanceof Data) {
      Text(data.aa + '').fontSize(50)
    }
  }

  build() {
    Row() {
      Column() {
        ForEachCom({ arrayList: this.array, closer: this.componentCloser })
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
export struct ForEachCom {
  arrayList: UnionData[] = [new Data(), new Data(), new Data()];
  @BuilderParam closer: (data: UnionData) => void = this.componentCloser;

  @Builder
  componentCloser() {
  }

  build() {
    Column() {
      ForEach(this.arrayList, (item: UnionData) => {
        Row() {
          this.closer(item)
        }.width('100%').height(200).backgroundColor('#eee')
      })
    }
  }
}
// [End using_union_types_in_structs]