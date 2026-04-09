/**
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
import buffer from '@ohos.buffer';
import * as util from "../../util";
import Structure from "../../Structure";
import FileAttribute from "../FileAttribute";
import * as structureUtil from "../../structureUtil";
import DirectoryEntry from "../../models/DirectoryEntry";

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 33
  },
  fileInformationClass: {
    type: Number,
    size: 1,
    defaultValue: 37
  },
  flags: {
    type: Number,
    size: 1
  },
  fileIndex: {
    type: Number,
    size: 4
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  fileNameOffset: {
    type: Number,
    size: 2,
    defaultValue: 96
  },
  fileNameLength: {
    type: Number,
    size: 2
  },
  outputBufferLength: {
    type: Number,
    size: 4,
    defaultValue: 0x00010000
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "fileNameLength"
  }
};

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  },
  outputBufferOffset: {
    type: Number,
    size: 2
  },
  outputBufferLength: {
    type: Number,
    size: 4
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "outputBufferLength"
  }
};

const parseDirectoryEntry = (entryBuffer: buffer.Buffer): DirectoryEntry => {
  let offset = 0;
  const index = entryBuffer.readUInt32LE(offset);
  offset += 4;
  const creationTime = structureUtil.parseDate(entryBuffer.subarray(offset, offset + 8));
  offset += 8;
  const lastAccessTime = structureUtil.parseDate(entryBuffer.subarray(offset, offset + 8));
  offset += 8;
  const lastWriteTime = structureUtil.parseDate(entryBuffer.subarray(offset, offset + 8));
  offset += 8;
  const changeTime = structureUtil.parseDate(entryBuffer.subarray(offset, offset + 8));
  offset += 8;
  const fileSize = entryBuffer.readBigUInt64LE(offset);
  offset += 8;
  const allocationSize = entryBuffer.readBigUInt64LE(offset);
  offset += 8;
  const fileAttributes = structureUtil.parseEnumValues(FileAttribute, entryBuffer.readUInt32LE(offset));
  offset += 4;
  const filenameLength = entryBuffer.readUInt32LE(offset);
  offset += 4;
  const eaSize = entryBuffer.readUInt32LE(offset);
  offset += 4;
  const shortNameLength = entryBuffer.readUInt8(offset);
  offset += 1;
  offset += 1;
  let shortFilename: string;
  if (shortNameLength !== 0)
    shortFilename = util.toUnixPath(entryBuffer.subarray(offset, offset + shortNameLength).toString("ucs2"));
  offset += 24;
  offset += 2;
  const data = entryBuffer.subarray(offset, offset + 8).swap64();
  const fileId = structureUtil.parseString(data, { type: String, encoding: "hex" });
  offset += 8;
  const filename = util.toUnixPath(entryBuffer.subarray(offset, offset + filenameLength).toString("ucs2"));
  offset += filenameLength;
  return { type: fileAttributes.includes("Directory") ? "Directory" : "File",
    index, creationTime, lastAccessTime, lastWriteTime, changeTime, fileSize, allocationSize, eaSize, shortFilename, fileId, filename, fileAttributes,
    absoluteDir:'',shareEnum:'' };
};

const parseResponseBuffer = (buf: buffer.Buffer) => {
  return structureUtil.parseList<DirectoryEntry>(buf, parseDirectoryEntry);
};

export default {
  requestStructure,
  responseStructure,
  parseResponseBuffer
};