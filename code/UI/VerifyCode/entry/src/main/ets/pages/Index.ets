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

import { VerifyCodeViewComponent } from 'verifycode';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      /**
       * 功能介绍：本示例介绍如何使用Text组件实现验证码场景，并禁用对内容的选中、复制、光标。
       * 参数介绍：无
       */
      VerifyCodeViewComponent()
    }
    .height('100%')
    .width('100%')
  }
}