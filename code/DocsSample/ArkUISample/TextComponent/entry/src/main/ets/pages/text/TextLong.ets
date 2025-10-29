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
// [Start Text_Long]
@Entry
@Component
export struct TextLong {
  @State message: string = 'This is an excessively long text'.repeat(50);

  build() {
    Column() {
      Text(this.message)
        .height('auto')
        .maxLines(3)
    }
    .height(200)
    .width('80%')
    .margin('10%')
    .borderWidth(1)
    .justifyContent(FlexAlign.Center)
  }
}
// [End Text_Long]