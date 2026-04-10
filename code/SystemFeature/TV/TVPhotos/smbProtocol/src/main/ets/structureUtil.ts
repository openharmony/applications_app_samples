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
import Structure from './Structure';
import StructureField from './StructureField';

export const parseStructure = (buf: buffer.Buffer, structure: Structure) => {
  let offset = 0;
  const data: any = {};
  const structureFieldNames = Object.keys(structure);
  for (const structureFieldName of structureFieldNames) {
    const structureField = structure[structureFieldName];
    let size: number;
    if (structureField.sizeFieldName) {
      size = data[structureField.sizeFieldName] as number;
      if (typeof size === "undefined") {
        throw new Error(`invalid_size_field_name: ${structureField.sizeFieldName}`);
      }
    } else if (typeof structureField.size === "number") {
      size = structureField.size;
    } else {
      throw new Error(`unknown_field_size`);
    }
    structureField.count = typeof structureField.count === "number" ? structureField.count : 1;
    if (structureField.countFieldName) {
      structureField.count = data[structureField.countFieldName] as number;
      if (typeof structureField.count ===
        "undefined") {
        throw new Error(`invalid_count_field_name: ${structureField.countFieldName}`);
      }
    }
    const value = buf.subarray(offset, offset + (size * structureField.count));
    data[structureFieldName] = parseValue(value, structureField);
    offset += size * structureField.count;
  }
  return data;
};

export const parseNumber = (buf: buffer.Buffer, structureField: StructureField) => {
  if (structureField.size === 2 && buf.length === 2) {
    return structureField.signedness === "Unsigned" ? buf.readUInt16LE(0) : buf.readInt16LE(0);
  }
  if (structureField.size === 4 && buf.length === 4) {
    return structureField.signedness === "Unsigned" ? buf.readUInt32LE(0) : buf.readInt32LE(0);
  }
  if (structureField.size === 8 && buf.length === 8) {
    return structureField.signedness === "Unsigned" ? buf.readBigUInt64LE(0) : buf.readBigInt64LE(0);
  }
  let result = 0;
  for (let index = 0; index < buf.length; index++) {
    result += buf.readUInt8(index) << (index * 8);
  }
  return result;
};

export const parseValue = (buf: buffer.Buffer, structureField: StructureField): Value => {
  if (structureField.count > 1) {
    const entryBuffers: buffer.Buffer[] = [];
    for (let index = 0; index < structureField.count; index++) {
      const entryBuffer = buf.subarray(index * structureField.size, (index + 1) * structureField.size);
      entryBuffers.push(entryBuffer);
    }
    return entryBuffers.map(entryBuffer => parseValue(entryBuffer, { ...structureField, count: 1 }));
  }
  let value: Value = buf;
  if (structureField.type === String) {
    value = parseString(buf, structureField);
  } else if (structureField.type ===
    Number) {
    value = parseNumber(buf, structureField);
  }
  return value;
};

export const parseString = (buf: buffer.Buffer, structureField: StructureField) => {
  return buf.subarray(0, structureField.size).toString(structureField.encoding);
};

export const parseDate = (buf: buffer.Buffer) => {
  const milliseconds = Number(buf.readBigUInt64LE(0) / BigInt(10000));
  const date = new Date(Date.parse('1601-01-01T00:00:00.000Z'));
  date.setUTCMilliseconds(date.getUTCMilliseconds() + milliseconds);
  return date;
};

export const parseEnumValue = (enumObject: any, value: number | string) => {
  return Object.keys(enumObject).find(x => enumObject[x] === value);
};

export const parseEnumValues = (enumObject: any, value: number) => {
  return Object.keys(enumObject).filter(x => (enumObject[x] & value) !== 0);
};

export const parseList = <EntryType = any>(buf: buffer.Buffer, parser: (entryBuffer: buffer.Buffer) => EntryType) => {
  if (buf.length === 0) {
    return [];
  }
  let currentOffset = 0;
  let nextEntryOffset = -1;
  const list: EntryType[] = [];
  while (nextEntryOffset !== 0) {
    nextEntryOffset = buf.readUInt32LE(currentOffset);
    const entryBufferStart = currentOffset + 4;
    const entryBufferEnd = nextEntryOffset === 0 ? buf.length : currentOffset + nextEntryOffset;
    const entryBuffer = buf.subarray(entryBufferStart, entryBufferEnd);
    list.push(parser(entryBuffer));
    currentOffset += nextEntryOffset;
  }
  return list;
};

export const serializeStructure = (structure: Structure, data: any) => {
  const normalizedData: { [fieldName: string]: { value?: buffer.Buffer; size?: number; } } = {};
  const structureFieldNames = Object.keys(structure);
  for (const structureFieldName of structureFieldNames) {
    const structureField = structure[structureFieldName];
    const value =
      typeof data[structureFieldName] !== "undefined" ? data[structureFieldName] : structureField.defaultValue || 0;
    normalizedData[structureFieldName] = {};
    if (structureField.sizeFieldName) {
      structureField.size = buffer.isBuffer(value) ? value.length : 0;
      const referencedStructureField = structure[structureField.sizeFieldName];
      normalizedData[structureField.sizeFieldName].value =
        serializeValue(structureField.size, referencedStructureField);
    }
    structureField.count = typeof structureField.count === "number" ? structureField.count : 1;
    if (structureField.countFieldName) {
      structureField.count = Array.isArray(value) ? value.length : 0;
      const referencedStructureField = structure[structureField.countFieldName];
      normalizedData[structureField.countFieldName].value =
        serializeValue(structureField.count, referencedStructureField);
    }
    normalizedData[structureFieldName].value = serializeValue(value, structureField);
    normalizedData[structureFieldName].size =
      (structureField.size ?? normalizedData[structureFieldName].value?.length) * structureField.count;
  }
  const normalizedFields = structureFieldNames.map(x => normalizedData[x]);
  const bufferSize = normalizedFields.reduce((prev, current) => prev + current.size, 0);
  const buf = buffer.alloc(bufferSize);
  let offset = 0;
  for (const normalizedField of normalizedFields) {
    normalizedField.value.copy(buf, offset);
    offset += normalizedField.size;
  }
  return buf;
};

export const serializeValue = (value: Value, structureField: StructureField): buffer.Buffer => {
  if (structureField.count > 1 && Array.isArray(value)) {
    const buffers = value.map(listEntry => serializeValue(listEntry, { ...structureField, count: 1 }));
    return buffer.concat(buffers);
  }
  if (buffer.isBuffer(value)) {
    return value as buffer.Buffer;
  }
  if (typeof value === "string") {
    return serializeString(value, structureField);
  }
  const bignumberValue = BigInt(value as ESObject);
  const result = buffer.alloc(structureField.size);
  for (let index = 0; index < structureField.size; index++) {
    const offset = BigInt(index * 8);
    const byte = BigInt(0xff) & (bignumberValue >> offset);
    result.writeUInt8(Number(byte), index);
  }
  return result;
};

export const serializeDate = (date: Date) => {
  const dateObj = new Date(date.toISOString());
  const referenceDateObj = new Date(Date.parse('1601-01-01T00:00:00.000Z'));
  const milliseconds = dateObj.getTime() - referenceDateObj.getTime();
  const buf = buffer.alloc(8);
  buf.writeBigInt64LE(BigInt(milliseconds * 10000), 0);
  return buf;
};

export const serializeString = (value: string, structureField: StructureField) => {
  return buffer.from(value, structureField.encoding);
};