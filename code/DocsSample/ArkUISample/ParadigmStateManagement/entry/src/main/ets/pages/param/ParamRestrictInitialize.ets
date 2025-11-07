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

// [Start Param_Restrict_Initialize]
@ComponentV2
struct ChildComponent {
  @Param param1: string = 'Initialize local';
  @Param param2: string = 'Initialize local and put in';
  @Require @Param param3: string;

  // @Param param4: string; // 错误用法，外部未传入初始化且本地也无初始值，编译报错
  build() {
    Column() {
      Text(`${this.param1}`) // 本地初始化，显示Initialize local
      Text(`${this.param2}`) // 外部传入初始化，显示Put in
      Text(`${this.param3}`) // 外部传入初始化，显示Put in
    }
  }
}

@Entry
@ComponentV2
struct MyComponent {
  @Local message: string = 'Put in';

  build() {
    Column() {
      ChildComponent({
        param2: this.message,
        param3: this.message
      })
    }
  }
}
// [End Param_Restrict_Initialize]