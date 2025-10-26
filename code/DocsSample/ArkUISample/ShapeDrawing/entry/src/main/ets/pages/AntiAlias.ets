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

@Entry
@Component
struct anti_Alias {
  build() {
    Column() {
      Text('Turn on anti-aliasing').margin({bottom:10})
      // [Start antialias_open]
      //开启抗锯齿
      Circle()
        .width(150)
        .height(200)
        .fillOpacity(0)
        .strokeWidth(5)
        .stroke(Color.Black)
      // [End antialias_open]
      Text('Turn off anti-aliasing').margin({bottom:10})
      // [Start antialias_close]
      //关闭抗锯齿
      Circle()
        .width(150)
        .height(200)
        .fillOpacity(0)
        .strokeWidth(5)
        .stroke(Color.Black)
        .antiAlias(false)
      // [End antialias_close]
    }
  }
}