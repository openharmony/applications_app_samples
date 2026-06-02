/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import deviceInfo from '@ohos.deviceInfo';

// 在@Styles函数中使用if else实现不同版本之间的属性差异
@Styles
function someStyles() {
  // 条件表达式中支持使用deviceInfo命名空间中获取版本的属性或者方法进行判断
  if (deviceInfo.sdkApiVersion >= 26) {
    .backgroundColor(Color.Red)
  } else {
    .backgroundColor(Color.Black)
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  // 局部@Styles方法同样支持使用if else实现不同版本之间的属性差异
  @Styles
  someOtherStyles() {
    if (deviceInfo.sdkApiVersion < 24) {
      .width(200)
    } else {
      .width(300)
    }
  }

  build() {
    Column() {
      Text('1')
        .someStyles()
      Text('2')
        .someOtherStyles()
    }
    .height('100%')
    .width('100%')
  }
}