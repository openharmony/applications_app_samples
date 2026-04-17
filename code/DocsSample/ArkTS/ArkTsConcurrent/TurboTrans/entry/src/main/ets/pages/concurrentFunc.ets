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
import { LayoutS } from '../turbotrans_JSON/layout';
import { testJSON1, testJSON2 } from '../turbotrans_JSON/test1';
import { testProtobuf } from '../turbotrans_protobuf/test1'

@Concurrent
export function observeProtobuf() {
  return testProtobuf();
}

@Concurrent
export function observeJSON1(): LayoutS {
  return testJSON1();
}

@Concurrent
export function observeJSON2(): LayoutS {
  return testJSON2();
}