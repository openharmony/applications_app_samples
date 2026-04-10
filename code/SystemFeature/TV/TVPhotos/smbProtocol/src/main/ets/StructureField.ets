/**
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
import Value from './Value';
import buffer from '@ohos.buffer';

export type StructureFieldType = NumberConstructor | StringConstructor | Function;

export default class StructureField {
  public type: StructureFieldType;
  public enum?: Object;
  public signedness?: 'Signed' | 'Unsigned';
  public encoding?: 'hex' | 'utf-8';
  public countFieldName?: string;
  public count?: number;
  public sizeFieldName?: string;
  public size?: number;
  public defaultValue?: Value;

  constructor(type: StructureFieldType) {
    this.type = type;
  }

  setEnum(enumValue: Object): StructureField {
    this.enum = enumValue;
    return this;
  }

  setSignedness(signedness: 'Signed' | 'Unsigned'): StructureField {
    this.signedness = signedness;
    return this;
  }

  setEncoding(encoding: 'hex' | 'utf-8'): StructureField {
    this.encoding = encoding;
    return this;
  }

  setCountFieldName(countFieldName: string): StructureField {
    this.countFieldName = countFieldName;
    return this;
  }

  setCount(count: number): StructureField {
    this.count = count;
    return this;
  }

  setSizeFieldName(sizeFieldName: string): StructureField {
    this.sizeFieldName = sizeFieldName;
    return this;
  }

  setSize(size: number): StructureField {
    this.size = size;
    return this;
  }

  setDefaultValue(defaultValue: Value): StructureField {
    this.defaultValue = defaultValue;
    return this;
  }
}
