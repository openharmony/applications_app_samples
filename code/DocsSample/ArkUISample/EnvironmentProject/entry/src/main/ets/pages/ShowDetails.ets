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

// [Start showfirst_details]
// 将设备的languageCode存入AppStorage，默认值为en
Environment.envProp('languageCode', 'en');
// [End showfirst_details]

@Entry
@Component
struct ShowDetails {
  // [Start showsecond_details]
  @StorageProp('languageCode') lang: string = 'en';
  // [End showsecond_details]
  build() {}
}