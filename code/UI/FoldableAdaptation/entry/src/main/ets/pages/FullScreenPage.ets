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

@Component
export struct FullScreenPage {
  private imageSrc: ResourceStr = '';

  build() {
    Column() {
      Text($r('app.string.full_screen_page'))
      Image(this.imageSrc)
        .width($r('app.string.size_percent_100'))
    }.height($r('app.string.size_percent_100'))
    .width($r('app.string.size_percent_100'))
  }
}