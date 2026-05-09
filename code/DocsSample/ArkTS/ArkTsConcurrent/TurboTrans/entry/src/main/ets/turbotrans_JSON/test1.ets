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
// [Start transferableObject_testJSON]
import { TJSON } from '@hadss/turbo-trans-json';
import { Layout, LayoutS } from 'entry/ets/turbotrans_JSON/layout';
import type { ITSerializable } from '@hadss/turbo-trans-json';
import { ArkTSUtils } from '@kit.ArkTS';

export function testJSON1(): LayoutS {
  let obj = new Layout();
  obj.type = 'Test';
  obj.arr = [3, 4];
  let str = JSON.stringify(obj);
  let layoutNormal = TJSON.fromString<Layout>(str, Layout);
  console.info('111 layout arr: ' + layoutNormal.arr);
  let layoutSendable = (layoutNormal as object as ITSerializable).toSendable();
  if (ArkTSUtils.isSendable(layoutSendable)) {
    console.info('expect layout from JSON string is Sendable');
  } else {
    console.error('test occur error');
  }
  let layoutS = layoutSendable as LayoutS;
  return layoutS;
}

export function testJSON2(): LayoutS {
  let layoutStr = '{"type":"Text","arr":[3,4]}';
  let layoutNormal = TJSON.fromString<Layout>(layoutStr, Layout);
  console.info('222 layout arr: ' + layoutNormal.arr);
  let layoutSendable = (layoutNormal as object as ITSerializable).toSendable();
  if (ArkTSUtils.isSendable(layoutSendable)) {
    console.info('expect layout from simple string is Sendable');
  } else {
    console.error('test occur error');
  }
  let layoutS = layoutSendable as LayoutS;
  return layoutS;
}

export function testJSON() {
  testJSON1();
  testJSON2();
}
// [End transferableObject_testJSON]