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

import nativeNode from 'libentry.so';

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        XComponent({
          id: "coastingAxisEvent",
          type: XComponentType.NODE,
          libraryname: "entry"
        }).onAppear(()=> {
          nativeNode.createNativeNode(this.getUIContext().px2vp(1))
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}