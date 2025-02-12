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

import { data } from './module'; // 将AppStorage中的SomeAppStorageVar改为200
import { dataOptimize } from './moduleOptimize';

@Entry
@Component
struct Index {
  // 开发者可能预期该值为100，但是由于module模块导入，该值已经被修改为200，但开发者可能并不知道值已经被修改
  @StorageLink('SomeAppStorageVar1') message1: number = 100;
  @StorageLink('SomeAppStorageVar2') message2: number = 100;

  build() {
    Column() {
      Row() {
        Text($r('app.string.side_effect'))
          .fontSize(30)
          .height(30)
        Divider()
          .vertical(true)
          .height(30)
          .margin({ left: 8, right: 8 })
          .strokeWidth(2)
        Text($r('app.string.optimize'))
          .fontSize(30)
          .height(30)
      }

      Row() {
        Text('test' + this.message1)
          .fontSize(30)
          .height(30)
        Divider()
          .vertical(true)
          .height(30)
          .margin({ left: 8, right: 8 })
          .strokeWidth(2)
        Text('test' + this.message2)
          .fontSize(30)
          .height(30)
      }
    }.width('100%')
  }
}

function maybeNotCalledAtAll() {
  console.log(data);
}

function maybeNotCalledAtAllOptimize() {
  console.log(dataOptimize);
}