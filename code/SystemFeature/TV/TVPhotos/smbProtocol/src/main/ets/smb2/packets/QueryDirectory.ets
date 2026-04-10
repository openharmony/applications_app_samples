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
import buffer from '@ohos.buffer';
import * as util from "../../util";
import Structure from "../../Structure";
import StructureField from "../../StructureField";
import FileAttribute from "../FileAttribute";
import * as structureUtil from "../../structureUtil";
import DirectoryEntry from "../../models/DirectoryEntry";

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(33))
  .addField('fileInformationClass', new StructureField(Number).setSize(1).setDefaultValue(37))
  .addField('flags', new StructureField(Number).setSize(1))
  .addField('fileIndex', new StructureField(Number).setSize(4))
  .addField('fileId', new StructureField(String).setEncoding("hex").setSize(16))
  .addField('fileNameOffset', new StructureField(Number).setSize(2).setDefaultValue(96))
  .addField('fileNameLength', new StructureField(Number).setSize(2))
  .addField('outputBufferLength', new StructureField(Number).setSize(4).setDefaultValue(0x00010000))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("fileNameLength"));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('outputBufferOffset', new StructureField(Number).setSize(2))
  .addField('outputBufferLength', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("outputBufferLength"));

class DirectoryEntryModel implements DirectoryEntry {
  index: number;
  type: "File" | "Directory";
  creationTime: Date;
  lastAccessTime: Date;
  lastWriteTime: Date;
  changeTime: Date;
  fileSize: BigInt;
  allocationSize: BigInt;
  shortFilename?: string;
  eaSize: number;
  fileId: string;
  filename: string;
  fileAttributes: string[];
  shareEnum: string;
  absoluteDir: string;

  constructor(index: number, type: "File" | "Directory", creationTime: Date, lastAccessTime: Date, lastWriteTime: Date,
    changeTime: Date, fileSize: BigInt, allocationSize: BigInt, shortFilename: string | undefined, eaSize: number,
    fileId: string, filename: string, fileAttributes: string[]) {
    this.index = index;
    this.type = type;
    this.creationTime = creationTime;
    this.lastAccessTime = lastAccessTime;
    this.lastWriteTime = lastWriteTime;
    this.changeTime = changeTime;
    this.fileSize = fileSize;
    this.allocationSize = allocationSize;
    this.shortFilename = shortFilename;
    this.eaSize = eaSize;
    this.fileId = fileId;
    this.filename = filename;
    this.fileAttributes = fileAttributes;
    this.shareEnum = '';
    this.absoluteDir = '';
  }
}

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
  let shortFilename: string | undefined = undefined;
  if (shortNameLength !== 0)
    shortFilename = util.toUnixPath(entryBuffer.subarray(offset, offset + shortNameLength).toString("ucs2"));
  offset += 24;
  offset += 2;
  const data = entryBuffer.subarray(offset, offset + 8).swap64();
  const fileId = structureUtil.parseString(data, new StructureField(String).setEncoding("hex"));
  offset += 8;
  const filename = util.toUnixPath(entryBuffer.subarray(offset, offset + filenameLength).toString("ucs2"));
  offset += filenameLength;
  const type: "File" | "Directory" = fileAttributes.includes("Directory") ? "Directory" : "File";
  return new DirectoryEntryModel(index, type, creationTime, lastAccessTime, lastWriteTime, changeTime, fileSize,
    allocationSize, shortFilename, eaSize, fileId, filename, fileAttributes);
};

const parseResponseBuffer = (buf: buffer.Buffer) => {
  return structureUtil.parseList<DirectoryEntry>(buf, parseDirectoryEntry);
};

class QueryDirectoryPacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
  parseResponseBuffer = parseResponseBuffer;
}

export default new QueryDirectoryPacket();
