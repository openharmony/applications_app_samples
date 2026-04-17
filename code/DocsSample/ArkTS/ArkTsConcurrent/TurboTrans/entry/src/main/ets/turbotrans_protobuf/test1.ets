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
// [Start tranferabledObject_testCreate]
import { test_pb } from '../protobuf/test_pb'
import { ArkTSUtils, collections } from '@kit.ArkTS';

function testCreate() {
  const obj = test_pb.create();
  obj.value_int32 = 1;
  obj.value_int64 = 2;
  obj.value_uint32 = 3;
  obj.value_uint64 = 4;
  obj.value_sint32 = 5;
  obj.value_sint64 = 6;
  obj.value_fixed32 = 7;
  obj.value_fixed64 = 8;
  obj.value_sfixed32 = 9;
  obj.value_sfixed64 = 10;
  obj.value_float = 11;
  obj.value_double = 12;
  obj.value_bool = true;
  obj.value_string = 'TestProtobuf_Success';
  obj.value_bytes?.fill(13);

  if (ArkTSUtils.isSendable(obj)) {
    console.info('create a sendable object');
  }

  return obj;
}

function testencode(obj: test_pb) {
  return test_pb.encode(obj);
}

function testdecode(data: ArrayBuffer | collections.ArrayBuffer) {
  let obj = test_pb.decode(data);
  if (obj?.value_int32 != 1) {
    throw new Error('Failed to get value_int32');
  }
  if (obj?.value_double != 12) {
    throw new Error('Failed to get value_double');
  }
  if (ArkTSUtils.isSendable(obj)) {
    console.info('decode a sendable object');
  }
  return obj;
}

export function testProtobuf(): test_pb | undefined {
  let obj = testCreate();
  let buf = testencode(obj);
  if (buf) {
    return testdecode(buf);
  }
  return undefined;
}
// [End tranferabledObject_testCreate]