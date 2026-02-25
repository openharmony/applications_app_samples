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

// [Start import_modulePartSix]
// PageSix.ets
import { data } from './ModulePartSix'; // 将AppStorage中的SomeAppStorageVar改为200

@Entry
@Component
struct Index {
  // 开发者可能预期该值为100，但是由于module模块导入，该值已经被修改为200，但开发者可能并不知道值已经被修改
  @StorageLink('SomeAppStorageVar') message: number = 100;
  build() {
    Row() {
      Column() {
        Text('test' + this.message)
          .fontSize(50)
      }
      .width('100%')
    }
    .height('100%')
  }
}
function maybeNotCalledAtAll() {
  console.info('data is ', data);
}
// [End import_modulePartSix]