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

let res_: number = 0;

import('./test1').then((ns:ESObject) => {
  ns.add.add(2, 3);

  let res: number = ns.add.add(2, 3);
  res_ = res;
  console.info('rest result',res);
})

@Entry
@Component
struct Notes {
  @State result: number = res_;

  build() {
    Row() {
      Column() {
        Text(String(this.result))
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }.height('100%')
  }
}
