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
//[Start ReusableV2Component9]
@ReusableV2
@ComponentV2
export struct ReusableV2Component9 {
  @Require @Param num: number;
  aboutToAppear() {
    console.info('ReusableV2Component aboutToAppear', this.num); // 创建时触发
  }
  aboutToRecycle() {
    console.info('ReusableV2Component aboutToRecycle', this.num); // 回收时触发
  }
  aboutToReuse() {
    console.info('ReusableV2Component aboutToReuse', this.num); // 复用时触发
  }
  build() {
    Column() {
      Text(`child: ${this.num}`)
    }
  }
}
//[End ReusableV2Component9]