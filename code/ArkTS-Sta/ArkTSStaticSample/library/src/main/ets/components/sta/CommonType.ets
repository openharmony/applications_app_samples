/**
 *
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

'use static'

export type JsonObject = Record<String, Object>;

export type JsonArray = Array<Object>;

export type AnyType = Any;

export function jsonObjectToRecord(jsonElement : jsonx.JsonElement): JsonObject {
  let ret: Record<String, Object> = new Record<String, Object>();
  let it = jsonElement.$_iterator();
  while (true) {
    const v = it.next();
    if (v.done) {
      break;
    }
    const key = v.value![0];
    const value = v.value![1];
    console.error('---', key, ':', value);
    if (value.jsonType === jsonx.JsonType.JsonObject) {
      ret.set(key, jsonObjectToRecord(value));
    } else if (value.jsonType === jsonx.JsonType.JsonString) {
      ret.set(key, value.asString());
    } else if (value.jsonType === jsonx.JsonType.JsonArray) {
      ret.set(key, jsonToArray(value.asArray()));
    } else if (value.jsonType === jsonx.JsonType.JsonNumber) {
      ret.set(key, value.asDouble());
    } else if (value.jsonType === jsonx.JsonType.JsonTrue) {
      ret.set(key, value.asBoolean());
    } else if (value.jsonType === jsonx.JsonType.JsonFalse) {
      ret.set(key, value.asBoolean());
    }
  }
  return ret;
}

export function jsonToArray(jsonArray: Array<jsonx.JsonElement>): JsonArray {
  let ret: Object[] = [];
  jsonArray.forEach((ele: jsonx.JsonElement) => {
    if (ele.jsonType === jsonx.JsonType.JsonObject) {
      ret.push(jsonObjectToRecord(ele));
    } else if (ele.jsonType === jsonx.JsonType.JsonString) {
      ret.push(ele.asString());
    } else if (ele.jsonType === jsonx.JsonType.JsonArray) {
      ret.push(jsonToArray(ele.asArray()));
    } else if (ele.jsonType === jsonx.JsonType.JsonNumber) {
      ret.push(ele.asDouble());
    } else if (ele.jsonType === jsonx.JsonType.JsonTrue) {
      ret.push(ele.asBoolean());
    } else if (ele.jsonType === jsonx.JsonType.JsonFalse) {
      ret.push(ele.asBoolean());
    }
  })
  return ret;
}
