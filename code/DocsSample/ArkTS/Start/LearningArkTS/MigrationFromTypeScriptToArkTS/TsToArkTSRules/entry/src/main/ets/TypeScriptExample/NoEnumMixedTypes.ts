/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start no_enumMixedTypes_ts]
enum E1 {
  A = 0xa,
  B = 0xb,
  C = Math.random(),
  D = 0xd,
  E // 推断出0xe。
}

enum E2 {
  A = 0xa,
  B = '0xb',
  C = 0xc,
  D = '0xd'
}
// [End no_enumMixedTypes_ts]
