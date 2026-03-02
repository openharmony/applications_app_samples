/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start Change_Property_In_Constructor]
@Observed
class DataDownloader {
  public state: number;

  constructor() {
    this.state = 0;
  }

  startIntervalUpdate() {
    setInterval(() => {
      this.state += 1;
    }, 2000);
  }
}

@Entry
@Component
struct Index {
  @State dataDownloader: DataDownloader = new DataDownloader();

  aboutToAppear() {
    this.dataDownloader.startIntervalUpdate(); // @Observed装饰的类构建后再修改属性可以触发更新UI
  }

  build() {
    Column() {
      Text(`Download state is ${this.dataDownloader.state}`)
    }
  }
}
// [End Change_Property_In_Constructor]
const changePropertyInConstructor = Index;
export default changePropertyInConstructor;