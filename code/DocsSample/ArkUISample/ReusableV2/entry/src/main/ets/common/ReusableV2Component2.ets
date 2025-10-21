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
//[Start ReusableV2Component2]
import { info, Info } from "../view/Page5";
@ReusableV2
@ComponentV2
export  struct ReusableV2Component2 {
  @Local info: Info = info; // 仅做演示使用，并不建议@Local赋值全局变量
  @Monitor('info.age')
  onValChange() {
    console.info('info.age change');
  }
  aboutToRecycle() {
    console.info('aboutToRecycle');
    this.info.age++;
  }
  aboutToReuse() {
    console.info('aboutToReuse');
    this.info.age++;
  }
  onRender(): string {
    console.info('info.age onRender');
    return this.info.age.toString();
  }
  build() {
    Column() {
      Text(this.onRender())
    }
  }
}
//[Start ReusableV2Component2]