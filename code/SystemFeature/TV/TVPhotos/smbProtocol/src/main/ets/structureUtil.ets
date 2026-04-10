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

interface NormalizedField {
  value: buffer.Buffer;
  size: number;
}

class StructureData {
}

function getStructureField(structure: Structure, fieldName: string): StructureField {
  const structureField = Reflect.get(structure as Object, fieldName) as StructureField | undefined;
  if (structureField === undefined) {
    throw new Error(`invalid_structure_field: ${fieldName}`);
  }
  return structureField;
}

function getObjectValue(target: Object, fieldName: string): Object | undefined {
  return Reflect.get(target, fieldName) as Object | undefined;
}

function setObjectValue(target: Object, fieldName: string, value: Object): void {
  Reflect.set(target, fieldName, value);
}

function cloneStructureField(structureField: StructureField, count: number): StructureField {
  const clonedField = new StructureField(structureField.type).setCount(count);
  if (structureField.enum !== undefined) {
    clonedField.setEnum(structureField.enum);
  }
  if (structureField.signedness !== undefined) {
    clonedField.setSignedness(structureField.signedness);
  }
  if (structureField.encoding !== undefined) {
    clonedField.setEncoding(structureField.encoding);
  }
  if (structureField.countFieldName !== undefined) {
    clonedField.setCountFieldName(structureField.countFieldName);
  }
  if (structureField.sizeFieldName !== undefined) {
    clonedField.setSizeFieldName(structureField.sizeFieldName);
  }
  if (structureField.size !== undefined) {
    clonedField.setSize(structureField.size);
  }
  if (structureField.defaultValue !== undefined) {
    clonedField.setDefaultValue(structureField.defaultValue);
  }
  return clonedField;
}

function getValueBufferLength(value: Value): number {
  if (!buffer.isBuffer(value)) {
    return 0;
  }
  return (value as buffer.Buffer).length;
}

function getFieldSize(structureField: StructureField): number {
  if (structureField.size === undefined) {
    throw new Error('unknown_field_size');
  }
  return structureField.size;
}

function getFieldCount(structureField: StructureField): number {
  return typeof structureField.count === 'number' ? structureField.count : 1;
}

function getNormalizedField(normalizedData: Map<string, NormalizedField>, fieldName: string): NormalizedField {
  const normalizedField = normalizedData.get(fieldName);
  if (normalizedField === undefined) {
    throw new Error(`invalid_normalized_field: ${fieldName}`);
  }
  return normalizedField;
}

function getEnumValue(enumObject: Object, key: string): Object | undefined {
  return Reflect.get(enumObject, key) as Object | undefined;
}

export const parseStructure = (buf: buffer.Buffer, structure: Structure): Object => {
  let offset = 0;
  const data: Object = new StructureData();
  const structureFieldNames = Object.keys(structure);
  for (const structureFieldName of structureFieldNames) {
    const structureField = getStructureField(structure, structureFieldName);
    let size: number;
    if (structureField.sizeFieldName) {
      const sizeValue = getObjectValue(data, structureField.sizeFieldName);
      if (typeof sizeValue !== 'number') {
        throw new Error(`invalid_size_field_name: ${structureField.sizeFieldName}`);
      }
      size = sizeValue;
    } else if (typeof structureField.size === "number") {
      size = structureField.size;
    } else {
      throw new Error(`unknown_field_size`);
    }
    structureField.count = getFieldCount(structureField);
    if (structureField.countFieldName) {
      const countValue = getObjectValue(data, structureField.countFieldName);
      if (typeof countValue !== 'number') {
        throw new Error(`invalid_count_field_name: ${structureField.countFieldName}`);
      }
      structureField.count = countValue;
    }
    const count = getFieldCount(structureField);
    const value = buf.subarray(offset, offset + (size * count));
    setObjectValue(data, structureFieldName, parseValue(value, structureField) as Object);
    offset += size * structureField.count;
  }
  return data;
};

export const parseNumber = (buf: buffer.Buffer, structureField: StructureField): number | bigint => {
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
  const count = getFieldCount(structureField);
  if (count > 1) {
    const entryBuffers: buffer.Buffer[] = [];
    const size = getFieldSize(structureField);
    for (let index = 0; index < count; index++) {
      const entryBuffer = buf.subarray(index * size, (index + 1) * size);
      entryBuffers.push(entryBuffer);
    }
    return entryBuffers.map(entryBuffer => parseValue(entryBuffer, cloneStructureField(structureField, 1)));
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

export const parseString = (buf: buffer.Buffer, structureField: StructureField): string => {
  return buf.subarray(0, getFieldSize(structureField)).toString(structureField.encoding);
};

export const parseDate = (buf: buffer.Buffer): Date => {
  const milliseconds = Number(buf.readBigUInt64LE(0) / BigInt(10000));
  const date = new Date(Date.parse('1601-01-01T00:00:00.000Z'));
  date.setUTCMilliseconds(date.getUTCMilliseconds() + milliseconds);
  return date;
};

export const parseEnumValue = (enumObject: Object, value: number | string): string | undefined => {
  return Object.keys(enumObject).find(x => getEnumValue(enumObject, x) === value);
};

export const parseEnumValues = (enumObject: Object, value: number): string[] => {
  return Object.keys(enumObject).filter(x => {
    const enumValue = getEnumValue(enumObject, x);
    return typeof enumValue === 'number' && (enumValue & value) !== 0;
  });
};

export const parseList = <EntryType>(buf: buffer.Buffer, parser: (entryBuffer: buffer.Buffer) => EntryType): EntryType[] => {
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

export const serializeStructure = (structure: Structure, data: Object): buffer.Buffer => {
  const normalizedData = new Map<string, NormalizedField>();
  const structureFieldNames = Object.keys(structure);
  for (const structureFieldName of structureFieldNames) {
    const structureField = getStructureField(structure, structureFieldName);
    const value =
      getObjectValue(data, structureFieldName) ?? structureField.defaultValue ?? 0;
    normalizedData.set(structureFieldName, { value: buffer.alloc(0), size: 0 });
    if (structureField.sizeFieldName) {
      structureField.size = getValueBufferLength(value as Value);
      const referencedStructureField = getStructureField(structure, structureField.sizeFieldName);
      const referencedField = getNormalizedField(normalizedData, structureField.sizeFieldName);
      referencedField.value = serializeValue(getFieldSize(structureField), referencedStructureField);
      referencedField.size = referencedField.value.length;
    }
    structureField.count = getFieldCount(structureField);
    if (structureField.countFieldName) {
      structureField.count = Array.isArray(value) ? value.length : 0;
      const referencedStructureField = getStructureField(structure, structureField.countFieldName);
      const referencedField = getNormalizedField(normalizedData, structureField.countFieldName);
      referencedField.value = serializeValue(structureField.count, referencedStructureField);
      referencedField.size = referencedField.value.length;
    }
    const currentField = getNormalizedField(normalizedData, structureFieldName);
    currentField.value = serializeValue(value as Value, structureField);
    currentField.size = (structureField.size ?? currentField.value.length) * getFieldCount(structureField);
  }
  const normalizedFields = structureFieldNames.map(x => getNormalizedField(normalizedData, x));
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
  const count = getFieldCount(structureField);
  if (count > 1 && Array.isArray(value)) {
    const buffers = value.map(listEntry => serializeValue(listEntry, cloneStructureField(structureField, 1)));
    return buffer.concat(buffers);
  }
  if (buffer.isBuffer(value)) {
    return value as buffer.Buffer;
  }
  if (typeof value === "string") {
    return serializeString(value, structureField);
  }
  const bignumberValue = typeof value === 'bigint' ? value : BigInt(value as number);
  const size = getFieldSize(structureField);
  const result = buffer.alloc(size);
  for (let index = 0; index < size; index++) {
    const offset = BigInt(index * 8);
    const byte = BigInt(0xff) & (bignumberValue >> offset);
    result.writeUInt8(Number(byte), index);
  }
  return result;
};

export const serializeDate = (date: Date): buffer.Buffer => {
  const dateObj = new Date(date.toISOString());
  const referenceDateObj = new Date(Date.parse('1601-01-01T00:00:00.000Z'));
  const milliseconds = dateObj.getTime() - referenceDateObj.getTime();
  const buf = buffer.alloc(8);
  buf.writeBigInt64LE(BigInt(milliseconds * 10000), 0);
  return buf;
};

export const serializeString = (value: string, structureField: StructureField): buffer.Buffer => {
  return buffer.from(value, structureField.encoding);
};
